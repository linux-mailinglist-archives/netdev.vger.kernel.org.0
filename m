Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A89213EDB
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 19:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGCRnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 13:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgGCRnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 13:43:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C37C8208C7;
        Fri,  3 Jul 2020 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593798200;
        bh=vIXBg2Hcbgy/4wkjM8lab3xFwtYmoqbKBErAG2gSDiY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ym69kWe3ySCQHpjN1H1dLNFhcNZI4B+AHi1B3rJykEweooG/6OEPKzsQng2G2zMKO
         bz6gZzPbWcRFGDN4ox4ZgIqKWTI82+tf4uB+C3fg/2MMr4W2v51i3lIs4JLkyNmvp3
         hLUONC7lOyyj4wTUt74IVGPXXHgqxUYB/CaTxkug=
Date:   Fri, 3 Jul 2020 10:43:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 03/15] sfc_ef100: skeleton EF100 PF driver
Message-ID: <20200703104319.4fcb6f9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b9ccfacc-93c8-5f60-d3a5-ecd87fcef5ee@solarflare.com>
References: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
        <b9ccfacc-93c8-5f60-d3a5-ecd87fcef5ee@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jul 2020 16:31:33 +0100 Edward Cree wrote:
> No TX or RX path, no MCDI, not even an ifup/down handler.
> Besides stubs, the bulk of the patch deals with reading the Xilinx
>  extended PCIe capability, which tells us where to find our BAR.
>=20
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Warnings:

drivers/net/ethernet/sfc/ef100_netdev.c:31:6: warning: symbol 'efx_separate=
_tx_channels' was not declared. Should it be static?
drivers/net/ethernet/sfc/ef100_netdev.c:45:13: warning: symbol 'ef100_hard_=
start_xmit' was not declared. Should it be static?
28a27,41
drivers/net/ethernet/sfc/ef100_rx.c:15:6: warning: symbol '__efx_rx_packet'=
 was not declared. Should it be static?
drivers/net/ethernet/sfc/ef100_tx.c:16:5: warning: symbol 'efx_enqueue_skb_=
tso' was not declared. Should it be static?
drivers/net/ethernet/sfc/ef100_netdev.c:45:13: warning: no previous prototy=
pe for =E2=80=98ef100_hard_start_xmit=E2=80=99 [-Wmissing-prototypes]
   45 | netdev_tx_t ef100_hard_start_xmit(struct sk_buff *skb,
      |             ^~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/sfc/ef100_rx.c:15:6: warning: no previous prototype fo=
r =E2=80=98__efx_rx_packet=E2=80=99 [-Wmissing-prototypes]
   15 | void __efx_rx_packet(struct efx_channel *channel)
      |      ^~~~~~~~~~~~~~~
drivers/net/ethernet/sfc/ef100_tx.c:16:5: warning: no previous prototype fo=
r =E2=80=98efx_enqueue_skb_tso=E2=80=99 [-Wmissing-prototypes]
   16 | int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_bu=
ff *skb,
      |     ^~~~~~~~~~~~~~~~~~~
