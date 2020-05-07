Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7CF1C9547
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgEGPn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725914AbgEGPn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 11:43:29 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11FAC05BD43;
        Thu,  7 May 2020 08:43:28 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u127so7352088wmg.1;
        Thu, 07 May 2020 08:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nxytJDY25nkqSUWT50yMCdYYj0ekyfNznUK4WOz0DVI=;
        b=L1/MOuVDUG0p7mIYU33P0f9znn3dYJoLcPCAKSwVbXOk9lbvjqpYPCRJHaJuXF30WW
         3l20IAb8hqT3l5LowVj7NtdFryxksvUaWyG5/b+EG4eJYqUoqOOC9TkTx4K4nv3Z9vn/
         zsDLO1Es61ahEOl0B6PmHUFB9+RV8gkYA3fLzr2tjEw26R2/cUocW+QyGOjgIsqPLUCE
         6t5Ae711fJAUW6auxtBpE4xVcqSyQIcmRdAteu6gapcoLntYqqndM6Hfq243dkuE5maf
         CdVdEzDrmgFaGo/dNknWRbyWcuCfFLP5rxK3yLR23BoJMeZgL758MErarcwGnXq3r8VL
         G0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nxytJDY25nkqSUWT50yMCdYYj0ekyfNznUK4WOz0DVI=;
        b=bcwh5giACgm8mFqItqxKEW0Yxm3xRBUVIMGT4j4SIcgbr0Wnvug/N1sQXNHLlO4Kua
         qV1NTogrLollga6NoRLVpDm6Nn5w1ZENWntss5c2vsynUApsommn4X6DDcg2V5ohmTqr
         2fUuliVWYwe0kGPT0byVWNT2rL8oVc3RYEhpQews7iiEBgXKOCy0p76jk5HHs2aXJZ7O
         4qtUTBuUJ/GFAag63qhSmE2vKmT/bqjandHnAnEifyy/pT5jwTx2nP7r2VwCS7sJF15R
         GdwgPX98PkufG/Y+6E2K0NxpCiK6WoYkDXW1P7pUXMCZXY2QplU9N46I22VAbJ1vuN78
         x23w==
X-Gm-Message-State: AGi0PubydcEIIrFshZKpa4BQ66Da/93NBto6c6BV1sqw9yC8OkBPAk94
        ikPvvGejkJ5pRCQc0iJ6iiCzQOwb
X-Google-Smtp-Source: APiQypKQeq5CTQAI7fzpE5u6Z/ho8YrJPrFOJrx/0Zv0oBHCGZQHBuH6WIeYS2CbapVvNTMfg6kTng==
X-Received: by 2002:a1c:96c6:: with SMTP id y189mr11682288wmd.106.1588866204369;
        Thu, 07 May 2020 08:43:24 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b22sm16534632wmj.1.2020.05.07.08.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 08:43:23 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: Make iproc_mdio_resume static
To:     Zheng Zengkai <zhengzengkai@huawei.com>, andrew@lunn.ch,
        davem@davemloft.net, rjui@broadcom.com
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200507080326.111896-1-zhengzengkai@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5c4526bc-f405-7c88-d4fb-53a5eb518934@gmail.com>
Date:   Thu, 7 May 2020 08:43:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507080326.111896-1-zhengzengkai@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2020 1:03 AM, Zheng Zengkai wrote:
> Fix sparse warnings:
> 
> drivers/net/phy/mdio-bcm-iproc.c:182:5: warning:
>  symbol 'iproc_mdio_resume' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
