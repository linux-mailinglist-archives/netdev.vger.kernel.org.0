Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EF23FBC67
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238578AbhH3S1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238280AbhH3S1t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 14:27:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9BA160E98;
        Mon, 30 Aug 2021 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630348015;
        bh=8tUSjnr7H3PoBoLy0ZN0FF3bzIzyWoa6mO5HoG79dZc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aGysZSQSmRhXl9MzPNSZy5H4pIPbHZfQyvZiuDdc+QmanI7H9JYXKHko8cHFaD6GT
         MY8U8DYhC2r4LUCAzNySMWidPasMQIxU1ZNATOo4bXx060x9vO0r+kXEKnXTQZLeOh
         hNvkPlVMeDSgKohJzrV4o+Ni5Ylon2DSr1QaU/k3Kf6UFhLxTXq8BXGmyqifcOY45u
         WNrXARu2Gqn0ySve1D3aoYy3pRJQxvb6o+5M9HUhl2Xfi2wDgKQzc5Tp0SUa7qfWeC
         e+zPXTbHWb8nY0948rvn59Y5LcIgIFhGNEObAIc7hlrMzW6jf6vPOQjR6HiEQ7ZQCo
         oJplxMt8qESww==
Date:   Mon, 30 Aug 2021 11:26:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     zhaoxiao <zhaoxiao@uniontech.com>
Cc:     davem@davemloft.net, mcoquelin.stm32@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] stmmac: dwmac-loongson: change the pr_info() to
 dev_err() in loongson_dwmac_probe()
Message-ID: <20210830112653.450eab49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830012417.14872-1-zhaoxiao@uniontech.com>
References: <20210830012417.14872-1-zhaoxiao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 09:24:17 +0800 zhaoxiao wrote:
> @@ -69,6 +68,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
>  	if (!plat)
>  		return -ENOMEM;
>  
> +
>  	if (plat->mdio_node) {
>  		dev_err(&pdev->dev, "Found MDIO subnode\n");
>  		mdio = true;
> @@ -111,6 +111,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
>  	phy_mode = device_get_phy_mode(&pdev->dev);
>  	if (phy_mode < 0)
>  		dev_err(&pdev->dev, "phy_mode not found\n");
> +	
>  
>  	plat->phy_interface = phy_mode;
>  	plat->interface = PHY_INTERFACE_MODE_GMII;

Please remove these changes from the patch.
