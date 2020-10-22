Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C25C2955E3
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 03:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894545AbgJVBCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 21:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395096AbgJVBCQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 21:02:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 071762237B;
        Thu, 22 Oct 2020 01:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603328536;
        bh=BVzSrhzukE9WeMRdwBb2+cKMwIqLMzMxm3fLDkAo7aI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K0CBh1s7dcIwez0WZDx63iZGIs2NCuGmAf2+HENukbufkxuJ+IgEvRdQj1CqqyTQi
         vNb06JIa66PwGWRRuX1RhAGsxmaU5REM79N79OYATYFlRg2KlxLXJraGavPFSfg9Oa
         9qMNqFlsE24mzLk/zTR36fQ6rp4O6hsLjNW8MajU=
Date:   Wed, 21 Oct 2020 18:01:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net] net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING
 flag after calling ether_setup
Message-ID: <20201021180114.4b478b06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020063420.187497-1-xie.he.0141@gmail.com>
References: <20201020063420.187497-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 23:34:20 -0700 Xie He wrote:
> This driver calls ether_setup to set up the network device.
> The ether_setup function would add the IFF_TX_SKB_SHARING flag to the
> device. This flag indicates that it is safe to transmit shared skbs to
> the device.
> 
> However, this is not true. This driver may pad the frame (in eth_tx)
> before transmission, so the skb may be modified.
> 
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you. 

In the future please try to provide a Fixes: tag.
