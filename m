Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEA2433A28
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhJSPXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:23:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233680AbhJSPXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Lp6ro8uTR1sPkKxnmENA4j6VSdZ6TN9ht8xh5ZFZnjg=; b=Kv02nsYVHVc69P0oe7XmcD2J6g
        yJGR8F7hy51rFq0/s44KCmhovdVjb8+xy9GW4sp3pUu1nBSEat3M1d41U4SrVi5E+o8fl3iFldkx4
        J31YB0Np+SpBGe0hwJHc41pLuwWLYMtusOSVj5WaRIZJZMReVRQr/OuzKKd/SC4676cA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcqvc-00B5Zx-MH; Tue, 19 Oct 2021 17:21:24 +0200
Date:   Tue, 19 Oct 2021 17:21:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Erik Ekman <erik@kryo.se>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: Fix reading non-legacy supported link modes
Message-ID: <YW7idC0/+zq6dDNv@lunn.ch>
References: <20211017171657.85724-1-erik@kryo.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211017171657.85724-1-erik@kryo.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 17, 2021 at 07:16:57PM +0200, Erik Ekman wrote:
> Everything except the first 32 bits was lost when the pause flags were
> added. This makes the 50000baseCR2 mode flag (bit 34) not appear.
> 
> I have tested this with a 10G card (SFN5122F-R7) by modifying it to
> return a non-legacy link mode (10000baseCR).

Does this need a Fixes: tag? Should it be added to stable?

     Andrew
