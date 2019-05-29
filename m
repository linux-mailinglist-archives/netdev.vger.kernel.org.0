Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D242DAA8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfE2K2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:28:49 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:42222 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbfE2K2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:28:49 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5E999C0B4F;
        Wed, 29 May 2019 10:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559125737; bh=l3Ry4dJcHNnCIlaMLKaBRH28TBvJqRSfyTN6AhOAOps=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=AUkzjL2sJ/RHTPWV0YyfM+WfRjwl0vRQaMLM4EfQtnSszrhAkAiGlVC3mRg0l3x/H
         DGkB/9Nqv8CEXr6Y3vSdEyQto50HfjC+Y3vZ51CvMerBAGkEJ6skUcxVBgzA0ExMTj
         1AtQrZAuSuJP8K4shfKdF0gT//z19Y8cCEHNi1a0RFtRlCPDIAVZNPuEM6IgbqCNb0
         RnRQJPgFMPxnNOqvkN+9B/5F4WXu8OKor6MdEBJa79ja3sIDemh+qVUnXx8g9q9lfl
         8WXo41jBI6KlM4qqHbRs6IHMxGaTsQrAIILFJCgEdnT3mZPXc/c7Z1sfFUATXf45ND
         z5Ej+ZB783DSA==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 0BA77A0067;
        Wed, 29 May 2019 10:28:47 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 29 May 2019 03:28:46 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 29 May 2019 12:28:45 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: RE: [PATCH net-next v4 5/5] net: stmmac: add EHL SGMII 1Gbps PCI
 info and PCI ID
Thread-Topic: [PATCH net-next v4 5/5] net: stmmac: add EHL SGMII 1Gbps PCI
 info and PCI ID
Thread-Index: AQHVFfypuDuCTZxVpkmcX+fHfGINwqaB5e4g
Date:   Wed, 29 May 2019 10:28:44 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B933497@DE02WEMBXB.internal.synopsys.com>
References: <1559149107-14631-1-git-send-email-weifeng.voon@intel.com>
 <1559149107-14631-6-git-send-email-weifeng.voon@intel.com>
In-Reply-To: <1559149107-14631-6-git-send-email-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Wed, May 29, 2019 at 17:58:27

> +	plat->axi =3D devm_kzalloc(&pdev->dev, sizeof(*plat->axi),
> +				 GFP_KERNEL);
> +	if (!plat->axi)
> +		return -ENOMEM;

Missing line break here.

> +	plat->axi->axi_lpi_en =3D 0;
> +	plat->axi->axi_xit_frm =3D 0;
> +	plat->axi->axi_wr_osr_lmt =3D 0;

This is not a valid value.

> +	plat->axi->axi_rd_osr_lmt =3D 2;
> +	plat->axi->axi_blen[0] =3D 4;
> +	plat->axi->axi_blen[1] =3D 8;
> +	plat->axi->axi_blen[2] =3D 16;
> +
> +	/* Set default value for multicast hash bins */
> +	plat->multicast_filter_bins =3D HASH_TABLE_SIZE;
> +
> +	/* Set default value for unicast filter entries */
> +	plat->unicast_filter_entries =3D 1;
> +
> +	/* Set the maxmtu to a default of JUMBO_LEN */
> +	plat->maxmtu =3D JUMBO_LEN;
> +
> +	/* Set 32KB fifo size as the advertised fifo size in
> +	 * the HW features is not the same as the HW implementation
> +	 */

Hmm ? I'm curious, can you explain ?

> +	plat->tx_fifo_size =3D 32768;
> +	plat->rx_fifo_size =3D 32768;
> +
> +	return 0;
> +}
> +
> +static int ehl_sgmii1g_data(struct pci_dev *pdev,
> +			    struct plat_stmmacenet_data *plat)
> +{
> +	int ret;
> +
> +	/* Set common default data first */
> +	ret =3D ehl_common_data(pdev, plat);
> +

Remove the extra line break please.

> +	if (ret)
> +		return ret;
> +

