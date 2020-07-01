Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F79210AC8
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 14:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgGAMMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 08:12:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32647 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730190AbgGAMMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 08:12:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593605570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XaTa3j8pv7Vv7FPlkaiUQ9sgC3qOTtEDpxvgOBhKsTg=;
        b=g1IhNHcXbN5nQBCSYjdknycNKG0isAGvE70ctxi+6uNEB4S4HuIWIvMTTfe2Zig3FyWZsl
        a7v4wv2aE6rmrz7ehpUgr+JiXNBIxSlKXT5YKojIUUOG2ITowUxTnsqVrVbIT5UJkADJ5u
        AMdZNJyZLrc9d+6spxLRN2oR5CpR0f4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-kQzCYPkRM0CMU_Ayo6HYPA-1; Wed, 01 Jul 2020 08:12:48 -0400
X-MC-Unique: kQzCYPkRM0CMU_Ayo6HYPA-1
Received: by mail-ej1-f71.google.com with SMTP id yh3so8143611ejb.16
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 05:12:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XaTa3j8pv7Vv7FPlkaiUQ9sgC3qOTtEDpxvgOBhKsTg=;
        b=ZEQGxy4bB/W5Ja6VRZMlyNzbqAQoXqHTrP2Se2Sw6HW5gu2ny7DDFV8mh25Afv4Egy
         Vwd6RzQvpVaiVj0vpcdReXmpZ75ffDAZDhf56dEs+MZTvKeKGsSP10Tn69hBncasAfT6
         cTqrjRPy7/bzeMkHWwEsv8eQQvYPb0Jh7nL2R4cAgy3Ttr680vzIg3FDohHENOjFtlvZ
         PnaLJO/05x6tocBy+sTOHsES4unQszdx5xpHnc1Z81cEDFjnExu+qPnBrSme73cwoIrC
         ZH8m7vCLCIoUFOxHVU8bay4+a6Mf0HQNN2TbZoZ3omanDMvI+ghoyt5mTs2s9q0uPf7R
         NNcg==
X-Gm-Message-State: AOAM531Ue2kot1+uRIQPjf7m9DToJnfSgrSS62y6TRuwoAn48YkOb5fD
        D5+1RFswFI4DfoeZA0JjjewdmKAVC4k5Jy0sv1l57uZnfMYJKVw1xahfTD7QCWAcmFxBeQx/q6z
        JYTubg7CTUtWuucD0
X-Received: by 2002:aa7:d3c8:: with SMTP id o8mr21964630edr.294.1593605567573;
        Wed, 01 Jul 2020 05:12:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybKmn9TXwxpznNvmXkc/EDdW74VObauZauv68Wmlu4ixsBkY7JPtu25PXyzIRbA9DwPCxw9g==
X-Received: by 2002:aa7:d3c8:: with SMTP id o8mr21964601edr.294.1593605567361;
        Wed, 01 Jul 2020 05:12:47 -0700 (PDT)
Received: from x1.localdomain ([2a0e:5700:4:11:334c:7e36:8d57:40cb])
        by smtp.gmail.com with ESMTPSA id cz2sm5763973edb.82.2020.07.01.05.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 05:12:46 -0700 (PDT)
Subject: Re: [PATCH v3] brcmfmac: Transform compatible string for FW loading
To:     matthias.bgg@kernel.org, arend.vanspriel@broadcom.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     brcm80211-dev-list.pdl@broadcom.com, mbrugger@suse.com,
        netdev@vger.kernel.org, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, hante.meuleman@broadcom.com,
        linux-kernel@vger.kernel.org, wright.feng@cypress.com,
        brcm80211-dev-list@cypress.com, franky.lin@broadcom.com
References: <20200701112201.6449-1-matthias.bgg@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <eaf0f098-c73c-10b5-2d75-b35a5fc8dbb4@redhat.com>
Date:   Wed, 1 Jul 2020 14:12:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701112201.6449-1-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/1/20 1:22 PM, matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
> 
> The driver relies on the compatible string from DT to determine which
> FW configuration file it should load. The DTS spec allows for '/' as
> part of the compatible string. We change this to '-' so that we will
> still be able to load the config file, even when the compatible has a
> '/'. This fixes explicitly the firmware loading for
> "solidrun,cubox-i/q".
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> 
> ---
> 
> Changes in v3:
> - use len variable to store length of string (Hans de Goede)
> - fix for loop to stop on first NULL-byte (Hans de Goede)
> 
> Changes in v2:
> - use strscpy instead of strncpy (Hans de Goede)
> - use strlen(tmp) + 1 for allocation (Hans de Goede, kernel test robot)

v3 looks good to me:

Reviewed-by: Hans deGoede <hdegoede@redhat.com>

Regards,

Hans


> 
>   .../wireless/broadcom/brcm80211/brcmfmac/of.c | 19 ++++++++++++++++---
>   1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index b886b56a5e5a..a7554265f95f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -17,7 +17,6 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>   {
>   	struct brcmfmac_sdio_pd *sdio = &settings->bus.sdio;
>   	struct device_node *root, *np = dev->of_node;
> -	struct property *prop;
>   	int irq;
>   	u32 irqf;
>   	u32 val;
> @@ -25,8 +24,22 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>   	/* Set board-type to the first string of the machine compatible prop */
>   	root = of_find_node_by_path("/");
>   	if (root) {
> -		prop = of_find_property(root, "compatible", NULL);
> -		settings->board_type = of_prop_next_string(prop, NULL);
> +		int i, len;
> +		char *board_type;
> +		const char *tmp;
> +
> +		of_property_read_string_index(root, "compatible", 0, &tmp);
> +
> +		/* get rid of '/' in the compatible string to be able to find the FW */
> +		len = strlen(tmp) + 1;
> +		board_type = devm_kzalloc(dev, len, GFP_KERNEL);
> +		strscpy(board_type, tmp, len);
> +		for (i = 0; i < board_type[i]; i++) {
> +			if (board_type[i] == '/')
> +				board_type[i] = '-';
> +		}
> +		settings->board_type = board_type;
> +
>   		of_node_put(root);
>   	}
>   
> 

