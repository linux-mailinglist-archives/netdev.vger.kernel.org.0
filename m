Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90951455047
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241119AbhKQWVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241100AbhKQWVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 17:21:08 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2EFC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 14:18:09 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id u17so3429266plg.9
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 14:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=erdGS5/UqGtcSsQ0WaEgON+6yirhDWT7nAsvVuoPd5k=;
        b=EKUxq0queiPs8ke/dfcawPH6R5sKB2Fybna0IYWOYYv4fI7DqdSCLw8D1APeivdR0v
         YA62UyP6ZWd93UfFgB8M4DkDwYoSFKqDReeSI75PAjxti3FCxjxXfhCbpOWx6kM1kG3y
         VDsoxv8OKTXJ7gv7CTVr9YkBIsfKebsKj03wqTYxqiP7wMP0To874Prt5AcPIcSMimRI
         XaqQryyy3NgHuBUfBYw90LYTRJbRy923rDz966Bs6AWY1010qAjPHLBuNSZqjEztkI2+
         B75lICwsJNdFq0leB1QhqjEpNSHPNAUpuUi0KIuQpT8oRA7Msfwhf5VYJ4+o553nv3gC
         Au7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=erdGS5/UqGtcSsQ0WaEgON+6yirhDWT7nAsvVuoPd5k=;
        b=T73SnUSwApDtWKpWyGms2rJTZZInvaHH3L4OeGI0+cuvfSS79M6n6rqmKe23YessF0
         lWMKCuWOd7Z/BRxXm3Wrsvh7m0tzyZ/P/dRAc6BpVbAjVcS63pivGAGu3oORjOGU4Zkh
         ZG+kw7oNRVyB9arwgshbIhWd1pCL6aW7pxrZHkCM8KJ/ZGiqJGOSQLEo5XlX66SriF6h
         u9X1bfRq9Vhy/Ve57yR5NuwSKagtpQXEnJ5FPW+ik+vImhNWUSINaJ9s4JNR3riwDVIp
         zd+WQTEJ34td3f582DDW2QRtOrH6NHlUC2/E6sGbMBCuh9rmemFJ/mwcVSJAmJaHvBcY
         8/NA==
X-Gm-Message-State: AOAM531oSoYewZI4Zt7G/uh5OhrtNJwh9QQw9cZIGwu7gMHQSusH8iad
        1tzW1YcaCEhMDh6X9MyCGKLeWOHnzx0=
X-Google-Smtp-Source: ABdhPJyINurdxA8TZz+it52GEBAm4T1s+yh7oZO6CAI0vu3ioksbK6AWkLmk8h444h02+jio2jnSJQ==
X-Received: by 2002:a17:902:ee8d:b0:143:8e80:62a8 with SMTP id a13-20020a170902ee8d00b001438e8062a8mr58899285pld.30.1637187488994;
        Wed, 17 Nov 2021 14:18:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h186sm616397pfg.64.2021.11.17.14.18.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 14:18:08 -0800 (PST)
Subject: Re: [PATCH] Revert "net: ethernet: bgmac: Use
 devm_platform_ioremap_resource_byname"
To:     Jonas Gorski <jonas.gorski@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dejin Zheng <zhengdejin5@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
References: <20211117160718.122929-1-jonas.gorski@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5348489e-c4a9-c534-5aac-c74bc22583e2@gmail.com>
Date:   Wed, 17 Nov 2021 14:18:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211117160718.122929-1-jonas.gorski@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/21 8:07 AM, Jonas Gorski wrote:
> This reverts commit 3710e80952cf2dc48257ac9f145b117b5f74e0a5.
> 
> Since idm_base and nicpm_base are still optional resources not present
> on all platforms, this breaks the driver for everything except Northstar
> 2 (which has both).
> 
> The same change was already reverted once with 755f5738ff98 ("net:
> broadcom: fix a mistake about ioremap resource").
> 
> So let's do it again.
> 
> Fixes: 3710e80952cf ("net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname")
> Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
-- 
Florian
