Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C393772C7
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhEHPuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhEHPuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:50:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC63C061574;
        Sat,  8 May 2021 08:49:12 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id z6-20020a17090a1706b0290155e8a752d8so7088304pjd.4;
        Sat, 08 May 2021 08:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IA4EzbXaystL8oiN9dVTxZFl4xqaWjmVZ9III5L2Y+M=;
        b=afZeetQzRDXRS25dGNXEGeCZhu8aTnD6de5SXTNmyoZbNqDkgtj0g+o6Wxty8hGtnE
         PSu50BJSLtYa+VE/9QtKy55qQEkDj6fxavabCfNXwTcPsThvvPsYbOn0badNV0Fitgwn
         AQKz2VG0JwqmP/a+3GOz4Bnn0lWRggRzJNHJ+0FaJBSq5O8ywzWwiB+XeSCq8u0lwjZf
         pWRKidVPHQjKbaVYq0bG7AXDyeLNO5+ZIvLOB/1by7mdoaY82hc/BW4VnhFCtATCaQX7
         hty16lacXVsI/J1GiRfre46aChIH7UyCI2oreqd2bl/yAeGM/Q0SLh4vt6n/kGD97In4
         899Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IA4EzbXaystL8oiN9dVTxZFl4xqaWjmVZ9III5L2Y+M=;
        b=KatkbQxLJHX2IX2uGY1Wo2zC+WWWfqkoeGM21qS3FrYA6TMcv9/8diVBgxTzC54VRL
         IrPAspJMkX9fDMqHluDZzuX/Aa8mLycHVpv9W0rbzoEJN2vCbwjUdSf2LXJl2mwIabRB
         3U6Ujq73UtvFyfrT94EbPpSItJeyQVFQ+fUkr/mPefzms7375vTicxu0re+siwTKvDAo
         8BD0K6CXYVWVpdTM3NU4H5ES/UnoXCse33eafBUDLpZZgGKGpcYqb2WMJ41DIeIY73k8
         U5NnAoFGy/2/vYF7otEazIYUemzEWHhiZc9LKii2mFKh3YzUIMwcCdrAXbNiAMF3HcAd
         iFsA==
X-Gm-Message-State: AOAM530Sf4TJ1BvWY33kyLTUM0ws9fGGqJ+BN5bo0ZeWct6qgrkiwgxW
        xvua7eNvS3Fof8nq+EvXlkXsMRGnRzc=
X-Google-Smtp-Source: ABdhPJwvOFdOlEeVc5X2qZZSAYc3sSBFr9Eq/PWpVF+RRnu5rxdWYMo3waD6Nez0fAP1hUzzyOVVSQ==
X-Received: by 2002:a17:90a:aa14:: with SMTP id k20mr24314319pjq.88.1620488951903;
        Sat, 08 May 2021 08:49:11 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id j16sm7683517pgh.69.2021.05.08.08.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:49:11 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 27/28] net: dsa: qca8k: pass
 switch_revision info to phy dev_flags
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-27-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0b24b27d-67df-ff7c-fd42-d4780535ed01@gmail.com>
Date:   Sat, 8 May 2021 08:49:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508002920.19945-27-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2021 5:29 PM, Ansuel Smith wrote:
> Define get_phy_flags to pass switch_Revision needed to tweak the
> internal PHY with debug values based on the revision.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
