Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E157539E096
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFGPft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:35:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhFGPfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:35:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623080037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DankcACZXWslvex/hGCrRKXxxv4UiIym257Vx0lNYb4=;
        b=gY48wKg8HE7Ya3PBUad8Wz0enAHJYtlMEkF+40qIcDYrGe5qvyWk18gm/XK4laomlQtxPI
        VpLhCFELGifwJKttDnUi5DpcVwVGiyxu+0INlNdMSnik4qDtvJkP7oHVs2jXn7O33XTPL9
        sRlDPAaVKhl/dnguZc5eGReUR3bJehc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-z1hRM7OBMwuUiQmDlEorQQ-1; Mon, 07 Jun 2021 11:33:55 -0400
X-MC-Unique: z1hRM7OBMwuUiQmDlEorQQ-1
Received: by mail-ej1-f69.google.com with SMTP id n8-20020a1709067b48b02904171dc68f87so942129ejo.21
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 08:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DankcACZXWslvex/hGCrRKXxxv4UiIym257Vx0lNYb4=;
        b=jA4hag/zeNCkUM0xiR81KF8BcA4clnMPWVrYyZJVu0Q1UuQ1eOfN1vlj/x3LRjE5ZW
         FUMHivZ7poijYt8QKYhu+AB2AbFRRtlQoC4MyZuuvepmlP838G2MrvRXgfTqkycHtROf
         xLApvMIc6yBp3Zwat4NVviBlkyVi2/PyvEUB6cBQ54JusRdl8pITrk6VEV4N63YHaRHX
         1Z3LgAHOxxqY/slk0bIcd7r8k8iwH2SAc6U+jSFHy9D1kPiT9u0rH6P+Ot8GX7Ao2TNO
         +wmIThcV7U9criWK4/gf4I1k4PWGLfIf/uJgnbyYZtNMbSo2/+IW3oZRaIoKEelvFNPg
         izNw==
X-Gm-Message-State: AOAM531f8bpiaybze9pW0GrekbF9ZAlau7Th/03epeBsQfG5/tJiySEP
        uRxNz7vuCZAhYRbBXNJOiwl0iyUenmL5zEp4iesJGxv8dBHKcwRX7hZe1reR/x1eHYDzMR15NyV
        MbqNv2+M8CKf83O83
X-Received: by 2002:a17:907:20da:: with SMTP id qq26mr17820560ejb.42.1623080033902;
        Mon, 07 Jun 2021 08:33:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyI7KVwpREF18YgH/3bFCnlBjU/J/cfKvgYikWI+jCFkukPGJiLXyu+tjZ0OfcXFYMkBnvSKw==
X-Received: by 2002:a17:907:20da:: with SMTP id qq26mr17820533ejb.42.1623080033736;
        Mon, 07 Jun 2021 08:33:53 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id s2sm7949873edu.89.2021.06.07.08.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 08:33:53 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Add clm_blob firmware files to modinfo
To:     matthias.bgg@kernel.org, Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        Remi Depommier <rde@setrix.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        linux-wireless@vger.kernel.org, Amar Shankar <amsr@cypress.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        SHA-cyfmac-dev-list@infineon.com, rafal@milecki.pl,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Wright Feng <wright.feng@infineon.com>
References: <20210607103433.21022-1-matthias.bgg@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <b43c0fe0-0252-40f5-39f2-1c60905fd0ea@redhat.com>
Date:   Mon, 7 Jun 2021 17:33:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210607103433.21022-1-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 6/7/21 12:34 PM, matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
> 
> Cypress Wi-Fi chipsets include information regarding regulatory
> constraints. These are provided to the driver through "Country Local
> Matrix" (CLM) blobs. Files present in Linux firmware repository are
> on a generic world-wide safe version with conservative power
> settings which is designed to comply with regulatory but may not
> provide best performance on all boards. Never the less, a better
> functionality can be expected with the file present, so add it to the
> modinfo of the driver.
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> 
> ---
> 
>  .../wireless/broadcom/brcm80211/brcmfmac/firmware.h  |  7 +++++++
>  .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c  |  4 ++--
>  .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 12 ++++++------
>  3 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> index 46c66415b4a6..e290dec9c53d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> @@ -32,6 +32,13 @@ static const char BRCM_ ## fw_name ## _FIRMWARE_BASENAME[] = \
>  	BRCMF_FW_DEFAULT_PATH fw_base; \
>  MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH fw_base ".bin")
>  
> +/* Firmware and Country Local Matrix files */
> +#define BRCMF_FW_CLM_DEF(fw_name, fw_base) \
> +static const char BRCM_ ## fw_name ## _FIRMWARE_BASENAME[] = \
> +	BRCMF_FW_DEFAULT_PATH fw_base; \
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH fw_base ".bin"); \
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH fw_base ".clm_blob")
> +
>  #define BRCMF_FW_ENTRY(chipid, mask, name) \
>  	{ chipid, mask, BRCM_ ## name ## _FIRMWARE_BASENAME }
>  
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 143a705b5cb3..c49dd0c36ae4 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -48,8 +48,8 @@ enum brcmf_pcie_state {
>  BRCMF_FW_DEF(43602, "brcmfmac43602-pcie");
>  BRCMF_FW_DEF(4350, "brcmfmac4350-pcie");
>  BRCMF_FW_DEF(4350C, "brcmfmac4350c2-pcie");
> -BRCMF_FW_DEF(4356, "brcmfmac4356-pcie");
> -BRCMF_FW_DEF(43570, "brcmfmac43570-pcie");
> +BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-pcie");
> +BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
>  BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
>  BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
>  BRCMF_FW_DEF(4364, "brcmfmac4364-pcie");
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index b8788d7090a4..69cbe38f05ce 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -616,14 +616,14 @@ BRCMF_FW_DEF(43362, "brcmfmac43362-sdio");
>  BRCMF_FW_DEF(4339, "brcmfmac4339-sdio");
>  BRCMF_FW_DEF(43430A0, "brcmfmac43430a0-sdio");
>  /* Note the names are not postfixed with a1 for backward compatibility */
> -BRCMF_FW_DEF(43430A1, "brcmfmac43430-sdio");
> -BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
> +BRCMF_FW_CLM_DEF(43430A1, "brcmfmac43430-sdio");
> +BRCMF_FW_CLM_DEF(43455, "brcmfmac43455-sdio");
>  BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
> -BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
> -BRCMF_FW_DEF(4356, "brcmfmac4356-sdio");
> +BRCMF_FW_CLM_DEF(4354, "brcmfmac4354-sdio");
> +BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-sdio");
>  BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
> -BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
> -BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
> +BRCMF_FW_CLM_DEF(4373, "brcmfmac4373-sdio");
> +BRCMF_FW_CLM_DEF(43012, "brcmfmac43012-sdio");
>  
>  /* firmware config files */
>  MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.txt");
> 

