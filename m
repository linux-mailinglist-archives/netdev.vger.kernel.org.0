Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8ABE23AE22
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgHCU3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgHCU3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:29:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2BEC22B45;
        Mon,  3 Aug 2020 20:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596486592;
        bh=VNXrJoDu2nVwvK5pv8XXLArHar+98PGv944XMa5VqRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NshCfN2Ba0b2nhmggzG3c76IhGP7zrRQp2Gn+JAqkTnw/o4d1QyNLZbSTu95u+iLa
         h0eK2KyrS9nt5ONx4JXrbmac/+dsXhcUcyt44OfyAwIiZDl8GJ5sUoE/Lt/pN2WfuT
         +1r+PeYuxJbTX4fECjsAasPf3/Hldbi+UGG1m75w=
Date:   Mon, 3 Aug 2020 13:29:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     pisa@cmp.felk.cvut.cz
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        mkl@pengutronix.de, socketcan@hartkopp.net, wg@grandegger.com,
        davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        c.emde@osadl.org, armbru@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com
Subject: Re: [PATCH v4 0/6] CTU CAN FD open-source IP core SocketCAN driver,
 PCI, platform integration and documentation
Message-ID: <20200803132949.64884ff1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1596408856.git.pisa@cmp.felk.cvut.cz>
References: <cover.1596408856.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Aug 2020 20:34:48 +0200 pisa@cmp.felk.cvut.cz wrote:
> From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> 
> This driver adds support for the CTU CAN FD open-source IP core.
> More documentation and core sources at project page
> (https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
> The core integration to Xilinx Zynq system as platform driver
> is available (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top).
> Implementation on Intel FPGA based PCI Express board is available
> from project (https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd).
> The CTU CAN FD core emulation send for review for QEMU mainline.
> Development repository for QEMU emulation - ctu-canfd branch of
>   https://gitlab.fel.cvut.cz/canbus/qemu-canbus
> 
> More about CAN related projects used and developed at the Faculty
> of the Electrical Engineering (http://www.fel.cvut.cz/en/)
> of Czech Technical University (https://www.cvut.cz/en)
> in Prague at http://canbus.pages.fel.cvut.cz/ .

Patches 3 and 4 have warnings when built with W=1 C=1 flags.

Please also remove the uses of static inline in C sources.
Those are rarely necessary and hide unused code warnings.
