Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB053B690
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390490AbfFJN45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:56:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52457 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389373AbfFJN45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 09:56:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B64422278;
        Mon, 10 Jun 2019 09:56:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 10 Jun 2019 09:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dJqGOG
        rwhoBDuk+rIWA13GuokbBPEtHUQKNNaCKH5tA=; b=j7RgQTJpJL+P+ghqKJBRKV
        fg/eUkgGt6YiriMzxKqgGxsNAa81oz7xpryjOVEMzJmjBKIYvJG5LDLSygv9wmpM
        FcCR8wKMc3cRpBJFsbRJI+31X9sWUxxXLayFuFxgaxXsH/Mn6rFaybGhsFzw7Pqm
        ggUrhemaw89IxFYJ8YUOp2jrxqYnMZU1zDjaB2o3bHnWCBXBFgV3kqBHflcXReKu
        lLmXqOtbc4R4+KuxDIJz/cWfgPyN1LCjayObq9Cj+dsepXFDkHRFNJOTsdTHI6s8
        Z1IrbcHbuJnvKUOdo4iiZnYj3RsUJJiXVudL/ueygczF0g2ULt6J+ewHTgYPYcUQ
        ==
X-ME-Sender: <xms:pmH-XLjocFsZar9RubZc5fRMeb1nU2w0uqVu95_k521_l9u1lToQuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehvddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:pmH-XIf8Zr8MDn_ZSBaYzfuqI0o3TjKB3wX3WELVMizYD958kwwWiA>
    <xmx:pmH-XB8SAb_B2xD0D_NGx5QDXd4Xnn_tA5AccZG_shy0yrfO41hpmg>
    <xmx:pmH-XOgAZDe9b7l8503hfGMh-gPNuojh3l6Q_yqH6-sthYmXQVvBwg>
    <xmx:qGH-XEzsNnTELZ9CAIzK46MiBtdCQQQuERKfSjHt6g1biWMmIfVOCw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B5049380089;
        Mon, 10 Jun 2019 09:56:53 -0400 (EDT)
Date:   Mon, 10 Jun 2019 16:56:51 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/3] selftests: mlxsw: Add ethtool_lib.sh
Message-ID: <20190610135651.GA19495@splinter>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-2-idosch@idosch.org>
 <20190610133538.GF8247@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610133538.GF8247@lunn.ch>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 03:35:38PM +0200, Andrew Lunn wrote:
> On Mon, Jun 10, 2019 at 11:40:43AM +0300, Ido Schimmel wrote:
> > From: Amit Cohen <amitc@mellanox.com>
> > +declare -A speed_values
> > +
> > +speed_values=(	[10baseT/Half]=0x001
> > +		[10baseT/Full]=0x002
> > +		[100baseT/Half]=0x004
> > +		[100baseT/Full]=0x008
> > +		[1000baseT/Half]=0x010
> > +		[1000baseT/Full]=0x020
> 
> Hi Ido, Amit
> 
> 100BaseT1 and 1000BaseT1 were added recently.

Hi Andrew,

Didn't see them in the man page, so didn't include them. I now see your
patches are in the queue. Will add these speeds in v2.

Thanks
