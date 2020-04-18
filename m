Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6C11AF1CB
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 17:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgDRPvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 11:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725879AbgDRPvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 11:51:36 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6930C061A0C;
        Sat, 18 Apr 2020 08:51:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e6so30138pjt.4;
        Sat, 18 Apr 2020 08:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0TKQZ7Y52qkZE5tRa53qohqKu4aHiJzFT5U1ZhFT2Ho=;
        b=inlWLnNhW0N6VWPrG1+xl4+2SvK3e3jybJXOw3fAz7kpLnitpyv6+7Ptjal/0PqDfd
         7J9YeS9hvI6z6r07YdnB3G4nlH9srwLN803UwyyZB9qv++Ph7RaE7En/5s9kV6CGOVc+
         b8nzoJnHf2wlbgHmy9RlK1xKnuuL6UiF+SRHB7C4qqV5cTKTyEx4kDz5VJdNRQQFij1c
         raR8W6C8BQalbr28fmN6kkPPD+O0svAJYZfg5QEWD6GhoyUwMd1dyic+K915keqgP8zt
         +ZQpNDsBwbv8v7WsN60V7SF+ABSTQfi9Tm+kTiSid3pDQax4eezAsySF+UyRFrQ+YiGk
         TETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0TKQZ7Y52qkZE5tRa53qohqKu4aHiJzFT5U1ZhFT2Ho=;
        b=oWmwsqNBcLXTVbDEuHCZSrWKh41SLQiXw6c0kXCp6OX3rNDtMxqqyDchcc/DTFx/m/
         bqJlYjLTr/UfoMZVPU0hpDhnnTpCyR06ohhTx7gnjJk+EbIwh8c2NJ66mGPEptRjxvtB
         BUs/hsJM0cXdXMhte3FRyG/z/GOFrcDz0BU5S35gfIncH3c0YIVKO+uav5asbaYg3Ewc
         jyKE/nqkcLuC4u4165AIWWMUfC3kNxHWQXy3FuAa8f5Ht74b8Z1jYJ0IF67sTyzsrP0E
         /TF5MYQhE4teJ9PQQ2kmhyusidxMNZnVhqcRllergBygebj6jjoyZxjDRQQPL6S3FoJo
         86Cw==
X-Gm-Message-State: AGi0PubfMMWfVzp6gE/5w160vIW3BiiQrHpCgREbX0qz4lKR3nV6DfGg
        hhOk5rLkmfS8ODXYUEm2hVYB+xet
X-Google-Smtp-Source: APiQypKtx8mEU3M5odve966NmskfRG9yFqqh4p3dHqHz77XNujWnD5vT68YT7sBC5CXhs6oVug7gLg==
X-Received: by 2002:a17:90a:1743:: with SMTP id 3mr11250029pjm.106.1587225095709;
        Sat, 18 Apr 2020 08:51:35 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v26sm3859404pff.45.2020.04.18.08.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 08:51:34 -0700 (PDT)
Subject: Re: [PATCH] net: systemport: Omit superfluous error message in
 bcm_sysport_probe()
To:     Tang Bin <tangbin@cmss.chinamobile.com>, f.fainelli@gmail.com,
        davem@davemloft.net
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200418085105.12584-1-tangbin@cmss.chinamobile.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <170ca41c-caa5-572b-9178-71e7235e05f6@gmail.com>
Date:   Sat, 18 Apr 2020 08:51:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418085105.12584-1-tangbin@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/18/2020 1:51 AM, Tang Bin wrote:
> In the function bcm_sysport_probe(), when get irq failed, the function
> platform_get_irq() logs an error message, so remove redundant message
> here.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
