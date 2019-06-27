Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36FAB5887E
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfF0Rfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:35:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56935 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726508AbfF0Rfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:35:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E60D720319;
        Thu, 27 Jun 2019 13:35:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 13:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=U7Xi4l
        7GU061T6yy148e90KFq6EohVTxXK0+0e0FdSA=; b=smU1y1h0A5AuO1/UPZ0stZ
        p/Dx/jdA6VDcWn0SlndJARzvsRvYEXLjtfcW6VrdmzLDmHZEPVHzUFkoNxAaF/FP
        hnPZm9d4DfF/fdKv+sd2Hjwe/CufKRS7Oxuf+g8pUTfG+6q9+Z/WOww45AGvh173
        H7MxkAlctoFqpB2Z2Sm2LcOVpkUDKrYE0bFFO9wJ0qvYRAVdioa2Ar0rznVP4IFU
        8yOnkYk/Rh/KLvkjswz+bMIcOw5XzsSNRQo3ml3t1N2777TkHLPSLXiFbqH1vov5
        5y67gitL2oabqsFgwCiIn2GvQ+xIuCnqhXIYUridzNq9jmz5dcgU/+GdL5UFd1Fg
        ==
X-ME-Sender: <xms:Yf4UXcOT7UqQeq5wN19cjNHotbj6SwWDak1rsvHH_TUzhQBN44zk0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedutd
    elrdeihedrieefrddutddunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Yf4UXeyG3mjCqH3gshL4Tjo03XYjEtpMshp5JNbkBipXr1x192toiw>
    <xmx:Yf4UXeqz2GUG26EF50i8BFL67XwkVfvtL4SsVp8H2-YEt4fld-cBfQ>
    <xmx:Yf4UXeMTTwnqqAY18IFEjaRDm3sS-Wy54lv22_uUwHLJKdEcLf-5wQ>
    <xmx:Yf4UXTXZgcCe9SusEBaszpkj1Kjzp06igwDwydkuckQsvOyMN5Zi-A>
Received: from localhost (bzq-109-65-63-101.red.bezeqint.net [109.65.63.101])
        by mail.messagingengine.com (Postfix) with ESMTPA id AE0F18006C;
        Thu, 27 Jun 2019 13:35:28 -0400 (EDT)
Date:   Thu, 27 Jun 2019 20:35:25 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/16] mlxsw: PTP timestamping support
Message-ID: <20190627173525.GA16859@splinter>
References: <20190627135259.7292-1-idosch@idosch.org>
 <20190627165134.zg7rdph2ct377bel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627165134.zg7rdph2ct377bel@localhost>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 09:51:34AM -0700, Richard Cochran wrote:
> On Thu, Jun 27, 2019 at 04:52:43PM +0300, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@mellanox.com>
> > 
> > This is the second patchset adding PTP support in mlxsw. Next patchset
> > will add PTP shapers which are required to maintain accuracy under rates
> > lower than 40Gb/s, while subsequent patchsets will add tracepoints and
> > selftests.
> 
> Please add the PTP maintainer onto CC for PTP patch submissions.

No problem. To be clear, I didn't Cc you since this is all internal to
mlxsw.

I see David made a style comment. We can wait with v2 to your comments,
if you plan to review this patchset.

Thanks
