Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5257BE285C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 04:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437153AbfJXCjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 22:39:15 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:39055 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390666AbfJXCjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 22:39:14 -0400
Received: by mail-pg1-f169.google.com with SMTP id p12so13282170pgn.6;
        Wed, 23 Oct 2019 19:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0tVbVKTYrYXfKRmckodJ4ebCvP/YbG9onuU8tHlEvLo=;
        b=nJJTvtTpVexCQwYYmz9Y07I2r3XUxUDbD3RvwMAQPk2OVeIb02RkZ9iw7PqcsQUDzL
         4smHxEc2cr6/xFV77ZsJLi7KylC8PcgX1hHa7SuqzWukvD3eFYDcSv6QmbpTjua96KyT
         Z9gQ6t4ghUW61nEjKOYbnPZA8SS1xzdJ800/x+B1nAsw4bKy/K2DylIXaQf7RRkc/Gc1
         Wim79fT8lXraHRlo3ImmRXjMo1NV73PdsJUXDI7YttbYLd9yFxulCoTmvr/Qb+OTxtRY
         JNLLaDNwx/I1lUGp8V/+KDi051UXXvq/Ptqe8abfsK2A2RyrHNdQsLMaoBvrrwwe4WI4
         SIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0tVbVKTYrYXfKRmckodJ4ebCvP/YbG9onuU8tHlEvLo=;
        b=LKFtz4vPUV5W+HvPOLKAyWek7BNj1HX1+qhKNnqtIP/MONeG33mZGMYtNeolnxoGLe
         rOYgs1x7ccMD1AAQS6pUfAQ4CqoYGH7bO/cEEssGrHbIy7bOFbtX7h+HNIrskD4wWXic
         oluv/llFTaCFTD9K+u22083oKY3Z+jat6smpQQOfMjhWAK0DcRnC0TzK5Q5IyGcRzzTz
         EDW+cMKzV+JprE48owtLImNs8wRmFtXvhglwGuG82wWp74ER5zRipnTon5fuLNMN2Wrd
         v0Ziz+oCJxr8sBUYyhjcfFhJAQwJdtmEmU5zyAAaa8INVnb6f2PD2PnC0ByF6XLPPaOX
         FAyg==
X-Gm-Message-State: APjAAAW6keOVKf/v4FAjzCWBxEki/DMU32bQKJ+PELt6qit0VJIoZadL
        8wF7NFtFd877HlWZLm32rSMP2tbe
X-Google-Smtp-Source: APXvYqxDzMzOdo0Eq0y/NTsC1Kw8fz6Vz0NsPuAxrRRboV/3WRYPUQWwn0vuT67oEN9/2p4S0xAkMw==
X-Received: by 2002:a63:ff08:: with SMTP id k8mr13655944pgi.8.1571884753852;
        Wed, 23 Oct 2019 19:39:13 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r13sm336868pfg.3.2019.10.23.19.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2019 19:39:13 -0700 (PDT)
Subject: Re: [PATCH 2/2] net: phy: dp83867: move dt parsing to probe
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org
References: <20191023144846.1381-1-grygorii.strashko@ti.com>
 <20191023144846.1381-3-grygorii.strashko@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ec7aae09-327c-5420-71f6-351d1614509d@gmail.com>
Date:   Wed, 23 Oct 2019 19:39:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191023144846.1381-3-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/23/2019 7:48 AM, Grygorii Strashko wrote:
> Move DT parsing code to probe dp83867_probe() as it's one time operation.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
