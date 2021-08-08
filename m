Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6753E3B01
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhHHPL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhHHPL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 11:11:59 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CB4C061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 08:11:39 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id n12so7846589wrr.2
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 08:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kLmtjfc9jbv7e5Z+43AnHmDCkXiD4eKYvYejrLrE3cA=;
        b=KuN41J2JgLHholts07NPh9pSHHpc6oLH0XBl9cfFigiW7QbDM8GYgOx/pDWULxjYLb
         Y96WZ3MaDisbNiqqNiBzTACR6gsIsaPEsVQJvY9unpxdoP0mev6Llfky18vUkRnGT76U
         nQlVMb2hwlnoWTzl/UwT9LjHlDbgZ9ROcl7xo0+HV8WSMsNwDfW88pC0JhiqFKD306Je
         m+8v1e0zL0gp/1441q7f77vMyvYNIxZcTKE1Pe/tZt69qihgF3RReEPMW8e9zrIopJWp
         +AZLMXSu1OTtuhseLyCva2NvIesmf9Mvj2uPxWefv8TyfRRLw+lPBDvkXUqqPBSnDibl
         aq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kLmtjfc9jbv7e5Z+43AnHmDCkXiD4eKYvYejrLrE3cA=;
        b=m6VqEX1y283x4EFBlUUKrnWjGmxC43hQreYWuE1IK69X75lu8qPtfnFILpIh/f9A5I
         lhOMRD7xZdtTRXljuTkM/OJ7iayyefemXHG+mAq5Qoj1rfnqkF7ACfw05sX0qoiO8aSX
         X6Yy0GB3gldg8fnE5ncxsTsEp4q4KdxFR5HSOsp4tLICwdeePl3RMcVU5rQmN1HnzHdj
         pT22XkcXATz4Q0gYOj9iNyihnSDVTxmGOw5MN2uLuDPb7n5TgwXO+QoMm6fwOs2rhyp4
         YomaPksZgaWoo75bKBqY1eqvYPZvv+He7dfvrjE8YQODAb/LNRzOte/PpG3PdBdYqv+T
         LrmQ==
X-Gm-Message-State: AOAM530tBCkGDBt3HAT+dnMueNrI+anM80ctxO1N0mG5MMgFmGj/PlV4
        SoE8Em5/vCyhL9BD8WoWQR1+0cTJhkS/+w==
X-Google-Smtp-Source: ABdhPJyk/q/jAfj7G4KDCZWp1DFVGK//W8G7zJKOO+ClMnrD1vzlUSeCNgfEDKFn4NH2hjUbdDxNaA==
X-Received: by 2002:a05:6000:227:: with SMTP id l7mr19697223wrz.289.1628435497709;
        Sun, 08 Aug 2021 08:11:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:7101:8b48:5eab:cb5f? (p200300ea8f10c20071018b485eabcb5f.dip0.t-ipconnect.de. [2003:ea:8f10:c200:7101:8b48:5eab:cb5f])
        by smtp.googlemail.com with ESMTPSA id q14sm16736993wrm.66.2021.08.08.08.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 08:11:37 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: rename rtl_csi_access_enable to
 rtl_set_aspm_entry_latency
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f25dc81e-7615-0b51-24cf-e1137f0f9969@gmail.com>
Message-ID: <b33fab87-3ef8-994b-4fc2-a624faf2dba8@gmail.com>
Date:   Sun, 8 Aug 2021 17:11:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <f25dc81e-7615-0b51-24cf-e1137f0f9969@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.08.2021 15:06, Heiner Kallweit wrote:
> Rename the function to reflect what it's doing. Also add a description
> of the register values as kindly provided by Realtek.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Just saw that the original patch was applied on net. Therefore this one
will apply only once net is merged to net-next. 

> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 2c643ec36..7a69b4685 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2598,7 +2598,7 @@ static u32 rtl_csi_read(struct rtl8169_private *tp, int addr)
>  		RTL_R32(tp, CSIDR) : ~0;
>  }
>  
> -static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
> +static void rtl_set_aspm_entry_latency(struct rtl8169_private *tp, u8 val)
>  {
>  	struct pci_dev *pdev = tp->pci_dev;
>  	u32 csi;
> @@ -2606,6 +2606,8 @@ static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
>  	/* According to Realtek the value at config space address 0x070f
>  	 * controls the L0s/L1 entrance latency. We try standard ECAM access
>  	 * first and if it fails fall back to CSI.
> +	 * bit 0..2: L0: 0 = 1us, 1 = 2us .. 6 = 7us, 7 = 7us (no typo)
> +	 * bit 3..5: L1: 0 = 1us, 1 = 2us .. 6 = 64us, 7 = 64us
>  	 */
>  	if (pdev->cfg_size > 0x070f &&
>  	    pci_write_config_byte(pdev, 0x070f, val) == PCIBIOS_SUCCESSFUL)
> @@ -2619,7 +2621,8 @@ static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
>  
>  static void rtl_set_def_aspm_entry_latency(struct rtl8169_private *tp)
>  {
> -	rtl_csi_access_enable(tp, 0x27);
> +	/* L0 7us, L1 16us */
> +	rtl_set_aspm_entry_latency(tp, 0x27);
>  }
>  
>  struct ephy_info {
> @@ -3502,8 +3505,8 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
>  	RTL_W8(tp, MCU, RTL_R8(tp, MCU) | EN_NDP | EN_OOB_RESET);
>  	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
>  
> -	/* The default value is 0x13. Change it to 0x2f */
> -	rtl_csi_access_enable(tp, 0x2f);
> +	/* L0 7us, L1 32us - needed to avoid issues with link-up detection */
> +	rtl_set_aspm_entry_latency(tp, 0x2f);
>  
>  	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
>  
> 

