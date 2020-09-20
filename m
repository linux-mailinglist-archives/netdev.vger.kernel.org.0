Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D205271805
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgITVHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITVHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:07:13 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86953C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:07:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d6so7212213pfn.9
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sTO+QCa+LrknLxidosv8L4AeRRoTrrgkBxb+WmU5Zlo=;
        b=QcZDAbbTzdy0D5daMc/2EyB1lLj8fHZFPGZ0N5y1J2hxbrX/H/J76p5OIL6fv2DzjX
         f9P7fCmyfieChn/xKGomeYGOEnZiw6GTlTB+QcIV6X7bLegG6CwG1mKh3ek96k4I9MIp
         WxAXMqAHVWgHcW6B1bM8Jwyblcc5dWbBeWLSUWbjeopD6iBbMRK9cdNot+k8EKsvFhFT
         B8Zf6ALAaguHtYY5b/5CLr934bIUnhrpIzDboBVc1DAdBAbHAKApVUWrXwVqSJg6A8uX
         7YyLXlF3oRs94p8jbSc5ssM7h8/sQW0zcgsLQg4os++0fSKF6gTlzLVFxwv2P+Ji8hXJ
         mEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sTO+QCa+LrknLxidosv8L4AeRRoTrrgkBxb+WmU5Zlo=;
        b=qKBj37qEgy+VXWrynRDa+Ou9zrNzqTesfr2eIWO6vbTuuBCthFWhyff1u64bCXiuNC
         6eyAvmE6/pAKcTksrJy2H7j1pwO4uNF9FgYQ3vg4AwILKyqPi7pew3jKfDNzunooGUhr
         ZoO7+PHz7/gHoIsV9BqLMTZNw4Q4s6MuW1Y7lJ27IFEesIKZT94fxbABjVuM1KG8xfVI
         wN+iF1IaqKFBbHJA3GaZ4sZcALjSFbJvAfVuxZeEDEXvlXzOfoulKfhVSpw4iwoEu4yd
         Tn/ApUVaJIi6NIQu2RlRTykJFRg/WP33pjn9NVw1ui/BO1ggkuLb7OCF0/SrvXvbeqL5
         aa2A==
X-Gm-Message-State: AOAM530fnMW/qhBMzuWHzDwRueiuaozI1SbeFYj8HCyTOD16kvyOjr87
        f/xvlwPUiB7wdz1nFmj+BdKDuzP5q4iMCA==
X-Google-Smtp-Source: ABdhPJxNopPpiWp9P8lGRniwZROmIyTLe30QUiScxLd1tE886zA730qJF0xB8KhNqrfGgG5WjDsc/Q==
X-Received: by 2002:a17:902:fe13:b029:d0:89f4:6226 with SMTP id g19-20020a170902fe13b02900d089f46226mr43093723plj.14.1600636033023;
        Sun, 20 Sep 2020 14:07:13 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id o5sm8580079pjs.13.2020.09.20.14.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 14:07:12 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] net: netdevice.h: Document proto_down_reason
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
References: <20200920171703.3692328-1-andrew@lunn.ch>
 <20200920171703.3692328-2-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4a41e362-386a-d218-37f2-ceae446c9dcc@gmail.com>
Date:   Sun, 20 Sep 2020 14:07:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920171703.3692328-2-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/2020 10:16 AM, Andrew Lunn wrote:
> Fix the Sphinx warning:
> 
> ./include/linux/netdevice.h:2162: warning: Function parameter or member
> 'proto_down_reason' not described in 'net_device'
> 
> by adding the needed documentation.
> 
> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
