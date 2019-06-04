Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C72F33D41
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFDCjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:39:15 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42747 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfFDCjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 22:39:15 -0400
Received: by mail-pl1-f194.google.com with SMTP id go2so7705418plb.9
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 19:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YUyIv0vX9OhDgaJjeJwPkMdWjuC17vitRLoGMxR2Z3o=;
        b=p+dyBSZD7qb4ZPJpJIrcnxEf7/rC8/qqZlsh+RwE8+t+xlw4C4aOHnd5V7hCCzsNDV
         /j4prvQH/I1QvguMmhzN86nYO1emu96Hi617LYvFRMkkFyVBrIfMYF4mcL1ULquou/F0
         HkOvyZwzFPz7ksd3FNi1KyWqS+xmWfr0P794VwXpkwTSMEUsQ4wzhiKX5X09B3YjdAZO
         qJf1U/SXJfbQyzGJMITdGF+TLLjr4q7aoFXbjj6s2zl7wPyDQJRxrZFL9Akq5ANT2ap8
         UBbneetTj4/ZV6kT2L4WbBN+CpvwO8IINxf92SlpR/jTHNOtReGpT02mBIoOx+3//5FZ
         VIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YUyIv0vX9OhDgaJjeJwPkMdWjuC17vitRLoGMxR2Z3o=;
        b=sJIcwTqowDmBYvUwBOtVR/WxCDyUToNBYGJOg3yYzdhickw3BX3WvqXwVzqIY8mjor
         O5hwFYcOG+nm32DOmLCNRBKE/EARRjLxZJI/wR/j3MbolFidfzRqdrSIUXNRw7wThP9B
         yyWoZF4Tc+twiPq4grRG/FNWS19fCVe9wtEt4tBccQttXzNTZMPnxQRk6F+P8mg2crxS
         4kA0f4mMdKRv91f06nU6CRUL2xvLIUfDASIZxui8vLh1I/8xSdIsV7DaWiWXu883on6c
         qtESWTY9FbmorA2lzMhyWRnpe3B27sfzYT5fmPXexrmPBLAhmTu+ld43fx5mPjV/uUmv
         7o3Q==
X-Gm-Message-State: APjAAAV8e8jamEV20BrUIAEOAGsm0KkboFegbAi9/R5fOU/AQgPMAPg0
        wiP6oLH/pChcB5D4obTUjBZr5Mhu
X-Google-Smtp-Source: APXvYqzh41lbINz8Ofq4wT23Snr/+aFlrUuMNsjlLqrUsopUnTSiYIDtjq5DKe1Wd8+pZ+/WEqFCLA==
X-Received: by 2002:a17:902:b717:: with SMTP id d23mr18661124pls.53.1559615954759;
        Mon, 03 Jun 2019 19:39:14 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y10sm18594787pfm.68.2019.06.03.19.39.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 19:39:13 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: phy: xilinx: add Xilinx PHY driver
To:     Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <1559603524-18288-1-git-send-email-hancock@sedsystems.ca>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <6fe3ec68-3848-c648-6904-23c98165382d@gmail.com>
Date:   Mon, 3 Jun 2019 19:39:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1559603524-18288-1-git-send-email-hancock@sedsystems.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Heiner, Andrew,

On 6/3/2019 4:12 PM, Robert Hancock wrote:
> This adds a driver for the PHY device implemented in the Xilinx PCS/PMA
> Core logic. This is mostly a generic gigabit PHY, except that the
> features are explicitly set because the PHY wrongly indicates it has no
> extended status register when it actually does.
> 
> This version is a simplified version of the GPL 2+ version from the
> Xilinx kernel tree.

For future submission, please use scripts/get_maintainer.pl so the
appropriate maintainers can be copied and give a chance to review this.

> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
> 

[snip]

> +/* Mask used for ID comparisons */
> +#define XILINX_PHY_ID_MASK		0xfffffff0
> +
> +/* Known PHY IDs */
> +#define XILINX_PHY_ID			0x01740c00
> +
> +static struct phy_driver xilinx_drivers[] = {
> +{
> +	.phy_id		= XILINX_PHY_ID,
> +	.phy_id_mask	= XILINX_PHY_ID_MASK,

You can use PHY_ID_MATCH_MODEL to declare the first two fields here.

> +	.name		= "Xilinx PCS/PMA PHY",
> +	/* Xilinx PHY wrongly indicates BMSR_ESTATEN = 0 even though
> +	 * extended status registers are supported. So we force the PHY
> +	 * features to PHY_GBIT_FEATURES in order to allow gigabit support
> +	 * to be detected.
> +	 */
A PHY fixup might have worked too, but I suppose this is equally fine.
-- 
Florian
