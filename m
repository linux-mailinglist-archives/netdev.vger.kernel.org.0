Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F363C62B0
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 20:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhGLSfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 14:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhGLSfd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 14:35:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BA1161166;
        Mon, 12 Jul 2021 18:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626114764;
        bh=ntZygdRkAoIVp1u8D8Ekhns+8iQ1KpIhHjnJDhcFDAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J+M2E1yjZzxlPztIbCcY6/rblq4Z2a31QOVl+t7AJFMt5Tkiu7qu/0Mo3aAwGC8GH
         UCeBFkJrZ/h3v55M0i6dWwJUi/Kt8p6Bj0Qy2yOQrRGaUCC+nl24QW4Xe3/5qgMpLH
         jMTXPySuuFqrk81gPqBNPhs13ZStS/w5/C+AYrFYdxjQuwBomSEVIUNpBmbY4gRaUo
         LJpW8AIU14S2v7qmqAccoFARs6crsayGBzIuR4mEpwvJZVE/JUDZtobE4gBW1pkp5J
         fm2X496AXjIXC05xSAMKXv6WIrJ+qXRDW68dSnV96ej3i2SxgtLja9CSB1wcZBJuMl
         F1hRRBj7ZRdOw==
Date:   Mon, 12 Jul 2021 11:32:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next 1/9] devlink: add documentation for hns3 driver
Message-ID: <20210712113243.2d786fe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1626053698-46849-2-git-send-email-huangguangbin2@huawei.com>
References: <1626053698-46849-1-git-send-email-huangguangbin2@huawei.com>
        <1626053698-46849-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Jul 2021 09:34:50 +0800 Guangbin Huang wrote:
> +Parameters
> +==========
> +
> +The ``hns3`` driver implements the following driver-specific
> +parameters.
> +
> +.. list-table:: Driver-specific parameters implemented
> +   :widths: 10 10 10 70
> +
> +   * - Name
> +     - Type
> +     - Mode
> +     - Description
> +   * - ``rx_buf_len``
> +     - U32
> +     - driverinit
> +     - Set rx BD buffer size.
> +       * Now only support setting 2048 and 4096.

Can you elaborate further? If I was a user reading this I'd still have
little confidence what this does. Does it change the size of each
buffer put on the Rx ring between 2k and 4k? Why is that a devlink
feature, we configure rings via ethtool.

> +   * - ``tx_buf_size``
> +     - U32
> +     - driverinit
> +     - Set tx spare buf size.
> +
> +       * The size is setted for tx bounce feature.

... and what is the tx bounce feature?
