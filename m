Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E832BA703
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 11:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgKTKFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 05:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgKTKFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 05:05:33 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04581C0613CF;
        Fri, 20 Nov 2020 02:05:33 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id y16so9470873ljh.0;
        Fri, 20 Nov 2020 02:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ALC5B9tIQTF680xeFUEICLS4/+UBA8Xb/cTnIHd0DHQ=;
        b=iv8wJjtJSuqTL/WITf79BDKYpsj3uFnq3hkW6EV+B8Lz68zsE/5lvAC++PPsNSLvZN
         CXCBSrGIkyQeXKnZGyxnv4xHC/7Y63qCUXK+eWi9QMZJBl884TqSwcozpDdKhPeG7D12
         scJAXg+P5k8D9xHDU6wLUDPiRheU71/1yFhUD+VSkF7welAMJxD8PjFh4WdDtR23T1de
         iohw7JuyMFJRfGURNCl1an1QrcWk4vQ3ghN3k9bWtC5Q2ekybiuioGGJJo72x29JP+x0
         rtTitbq4nCVgmVc0bkuIr3OwgvU96iQ2LNQC2MvoHdLk7F5/+phdm6oacSgC4SQJjpiJ
         7+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ALC5B9tIQTF680xeFUEICLS4/+UBA8Xb/cTnIHd0DHQ=;
        b=JZKa2YoMlfwWljW5TBc60zGpJEag/OGcPb/zub31X67gzJ29/iHS1OOgljezZvgGuN
         y3a/2F1lDTSmz50XMhepEeL36C/+3ZqFJvMtZyUXDK1VnMvMGdqbvVjLx/ZIWSjklq41
         qZt3cXi3k8es+44eaF0TQU/DUpcwGp+r2U3h4pd4QZ7835q+JGlc9rrVOfYFmBR7YdG+
         vcKcLpXRyVIuyvYq2aJfyxVL8X+yKYTxr/WhjF5BjAOPvWW3NiPMF8QKRtOlC32VbqHG
         g8mmmopaEXgwNDIclR/7S+CFMWTaKeZWTiTc245EHQiI2pLGvRMCwUOmlkOo/m3+z/Tb
         K0XA==
X-Gm-Message-State: AOAM532FVpj47/JboxDPrfxK9T69iXiZsobgqSMeXY4UWRsCkNcHAGJ1
        iqLt4MkQ7T0m199J8BisLTM=
X-Google-Smtp-Source: ABdhPJyhHCSYwZt9lLDpv6+qOXWrxg/urk2JAKWI4lhfby6z1wtDZbj7vQykvECtPgUh2T/NV/yZJA==
X-Received: by 2002:a2e:7306:: with SMTP id o6mr7255145ljc.306.1605866731494;
        Fri, 20 Nov 2020 02:05:31 -0800 (PST)
Received: from [192.168.2.145] (109-252-193-159.dynamic.spd-mgts.ru. [109.252.193.159])
        by smtp.googlemail.com with ESMTPSA id b12sm241145ljk.117.2020.11.20.02.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 02:05:30 -0800 (PST)
Subject: Re: [PATCH v2] brcmfmac: expose firmware config files through modinfo
To:     matthias.bgg@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>, hdegoede@redhat.com
Cc:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Double Lo <double.lo@cypress.com>,
        Frank Kao <frank.kao@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Saravanan Shanmugham <saravanan.shanmugham@cypress.com>,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Amar Shankar <amsr@cypress.com>
References: <20201120095233.19953-1-matthias.bgg@kernel.org>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <2ff4dcc3-6f99-a068-8989-4293d2013627@gmail.com>
Date:   Fri, 20 Nov 2020 13:05:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201120095233.19953-1-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

20.11.2020 12:52, matthias.bgg@kernel.org пишет:
> From: Matthias Brugger <mbrugger@suse.com>
> 
> Apart from a firmware binary the chip needs a config file used by the
> FW. Add the config files to modinfo so that they can be read by
> userspace.
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> 
> ---
> 
> Changes in v2:
> In comparison to first version [0] we use wildcards to enumerate the
> firmware configuration files. Wildcard support was added to dracut
> recently [1].
> [0] https://lore.kernel.org/linux-wireless/20200701153123.25602-1-matthias.bgg@kernel.org/
> [1] https://github.com/dracutdevs/dracut/pull/860
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 99987a789e7e..dd6d287b1b00 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -625,6 +625,15 @@ BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
>  BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>  BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>  
> +/* firmware config files */
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac4330-sdio.*.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43340-sdio.*.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43362-sdio.*.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430a0-sdio.*.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43430-sdio.*.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac43455-sdio.*.txt");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac4356-pcie.*.txt");

This doesn't cover all hardware models. Note that the upstream
linux-firmware has files only for a few hardware models.

I suppose that the correct mask should be "brcm/brcmfmac*-sdio.*.txt".
