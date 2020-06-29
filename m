Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE05020E266
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390137AbgF2VEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731106AbgF2TMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:44 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8579C00E3EC
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:08:46 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so15887395wmh.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=68BNwhrvCD89eE+cp4wiVMJAGjlUssBHliBw0yeTncY=;
        b=IdgTjlbUeXAflc75EIxsNdwIaYTkdpBR1e0ABbhEtcFT6se9ayn3CRIw5AgjMCyty+
         t1copcc5AWHQ+spbmtU7MN1oUUZNYyIRgg/viQ+yr8woWJI/9urJNVYmSYIDHu5qA1zp
         6Nt6i+1nEHX7g3moqDr2jjkQxoYiZqU2aRmel1UxU9PFQHkZ4ulEBKZIMUxJk4gRPiw6
         Mnp1YtIiwjKLeWUHyHwrwZWDT6qGnxZspNOLBDpI78OHXeOUu7jVM+3C8RFrAGCjmaOs
         Y8VmUfEPwPUhtPXjrABEMb3VFGENgBJCkvVDD5y61tbrBs23SvZwCgQua26J3lRfNGeS
         lPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=68BNwhrvCD89eE+cp4wiVMJAGjlUssBHliBw0yeTncY=;
        b=tDbK4+3cYJMc0/lpeExDYa9fFixmbxYuQHZp8wW1Tk7PACE7dlfiop3aucMLJUf88w
         EA7gtPYD0LodcJyOdzhHeUHLEeN906R1v4D3lX7vhmNj/d2knI3GcgZYhUAve/NJnQB8
         wCylUkAAQCiL2FCtBz/fylaA0pAsEepDsPWCYOM6frfiZkOyXYJZ0FhRofXqGv6Ckpu0
         bGqysgZ2OYiBiAFmwe+JnuQFDiRWlv4F68z85RUZF8QKQOz4l+c0nAZAbRr3VmvjZprq
         51Ag8y3fm2UnFC1i52LUN8/SrU4qfSd3SkJxwSYvLYUtY33z10FXhkApFT6LZzi5SR+O
         A5qQ==
X-Gm-Message-State: AOAM532yRtooHfDDKVAQGW7Hk3PMGytcJY8fJOVQ3B2tWB8l4RmIJkDB
        sCKnaPHLJq2T3m0FlsgL8k2Y3A==
X-Google-Smtp-Source: ABdhPJwy03g4x3aV2XQQGgmeV08Ic9EdB03Rjh42PiyDcmKqRhbp8rvEOqtPqrbM2yk/voBeySrtHQ==
X-Received: by 2002:a1c:4408:: with SMTP id r8mr16435045wma.100.1593432525398;
        Mon, 29 Jun 2020 05:08:45 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:a5b5:45c4:c00e:7063? ([2a01:e34:ed2f:f020:a5b5:45c4:c00e:7063])
        by smtp.googlemail.com with ESMTPSA id 65sm30057812wma.48.2020.06.29.05.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 05:08:43 -0700 (PDT)
Subject: Re: [PATCH v6 06/11] thermal: Add mode helpers
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        kernel@collabora.com, kernel test robot <lkp@intel.com>
References: <CAHLCerO2XOOX9akEwaTu_cjSqRycFpNmoVxkSe36L8B4ALWidA@mail.gmail.com>
 <20200629111615.18131-1-andrzej.p@collabora.com>
 <20200629111615.18131-7-andrzej.p@collabora.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <23060170-b78b-5717-1215-826488c04981@linaro.org>
Date:   Mon, 29 Jun 2020 14:08:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629111615.18131-7-andrzej.p@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/06/2020 13:16, Andrzej Pietrasiewicz wrote:
> Prepare for making the drivers not access tzd's private members.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> [EXPORT_SYMBOL -> EXPORT_SYMBOL_GPL]
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> [staticize thermal_zone_device_set_mode()]
> Signed-off-by: kernel test robot <lkp@intel.com>

Duplicate signed-off line.

Please resend a V7 without a reply-to, so the series will be correctly
handled by patchwork and that will make my life easier.

Thanks



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
