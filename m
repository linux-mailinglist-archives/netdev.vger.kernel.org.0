Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D310EA4DE
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 21:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfJ3Ug7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 16:36:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbfJ3Ug7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 16:36:59 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4155120656;
        Wed, 30 Oct 2019 20:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572467818;
        bh=n7Ze7BhEelOv8ugr9r7umjLdJR7IBqczK+65iIUvgJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=KzAaoh6ewPvi/yE6NDchWzkojwjbdY2LSG9Jx+fw2yg6w3z0CsSQ9byQ375jd8Y9v
         U0/ZtrGHiWqt+JxkrcuDfKvjiC3fYDem9/1r18vTCbvzsMHNhhmLf8M1vedxCQFBIB
         5snoxIVw7hvHkHkB6kgjGA2gwTiTd1ZakvDC+PRg=
Date:   Wed, 30 Oct 2019 15:36:57 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-mips@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, axboe@kernel.dk,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/5] net: stmmac: pci: Add Loongson GMAC
Message-ID: <20191030203657.GA247440@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030135347.3636-4-jiaxun.yang@flygoat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 09:53:45PM +0800, Jiaxun Yang wrote:
> This device will be setup by parsing DeviceTree node
> of pci device.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

> +static int loongson_pci_of_setup(struct pci_dev *pdev,
> +			struct plat_stmmacenet_data *plat)
> +{
> +	struct device_node  *np;
> +	np = pci_device_to_OF_node(pdev);
> +
> +	if(!np) {

Please pay attention to the existing coding style in the file and
follow it.  In this and other cases below, add a space in "if (".

> +	if(!of_device_is_compatible(np, "loongson,pci-gmac")) {

> +	return  stmmac_parse_config_dt(np, plat);

Remove the double space here.

> +	if(info->of_irq) {

> +	STMMAC_DEVICE(LOONGSON,  PCI_DEVICE_ID_LOONGSON_GMAC, loongson_of_pci_info),

And here.
