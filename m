Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B2E30AEBB
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhBASHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:07:18 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36619 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231296AbhBASHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:07:15 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 875C15C018B;
        Mon,  1 Feb 2021 13:06:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 01 Feb 2021 13:06:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=p0iHBr
        6yfIhyKsVlr04os37w4o0GimFYpnEcPMYiCkw=; b=KvfbO703v4/NwxrLjP0sQM
        sBwVcQqxunIIelbJxj6x376bWOfqbY57BNxFaERRjwU35LvCGJvZa72QcunZFJWf
        uLecuhi91xrPlWgoTbwwmhOQsQ39yfeA01TNY93vMVrV1XpjS5aMymU0LtjeaWxs
        VGaoeYTnAMfg4Atb5thTXw9NQ4Uzc6rr1xqI9J1to5gwqeAz2CJ6/twqipwP8YKA
        zzOTD7yqKSuB/Zp77bRJS2KWY3yE9QSRbeC9ektA5caYvMr7X08JYTwZBD8FhqYw
        jKu0z09bi1DAC5H9vWS4LcmzMmsUVtJ3xFAyWa3FtnfoORENSWjwYgndyOTPzsJA
        ==
X-ME-Sender: <xms:EUMYYLBvIlWfr3PSPncXCWJojzEVU4szOgopLjt-Cjj5c7X6dfucmQ>
    <xme:EUMYYGdjztM1NObaAk4nc71PEzM7YtlEGqFe4DpWYbniGNeGoGmNF1MDPPqW1Rl1F
    GV6_pYatUrrzWo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:EUMYYK0MoxKTjkMdX2cDuHdVundGF58wyfXpNWRdqpkRIDI9ss5i-Q>
    <xmx:EUMYYNiJ7TOK4B_z5H5oP6EJqrQdhmz4RPDfMozRyGr33lWDfY24yA>
    <xmx:EUMYYDm9IrI9P2PkcR4tZP1lFli7EjNovqXzOrmM57SyjRY45BRs1Q>
    <xmx:EUMYYDQLaiWKCnZLriu8LxtYVQwNOlRhxOAPa7ujfKAThkevikMk8A>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id E128F1080066;
        Mon,  1 Feb 2021 13:06:08 -0500 (EST)
Date:   Mon, 1 Feb 2021 20:06:06 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        saeedm@nvidia.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v5] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210201180606.GA3456040@shredder.lan>
References: <20210130023319.32560-1-cmi@nvidia.com>
 <20210130145227.GB3329243@shredder.lan>
 <c62ee575-49e0-c5d6-f855-ead5775af141@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c62ee575-49e0-c5d6-f855-ead5775af141@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 10:00:48AM +0800, Chris Mi wrote:
> On 1/30/2021 10:52 PM, Ido Schimmel wrote:
> > On Sat, Jan 30, 2021 at 10:33:19AM +0800, Chris Mi wrote:
> > > In order to send sampled packets to userspace, NIC driver calls
> > > psample api directly. But it creates a hard dependency on module
> > > psample. Introduce psample_ops to remove the hard dependency.
> > > It is initialized when psample module is loaded and set to NULL
> > > when the module is unloaded.
> > > 
> > > Reported-by: kernel test robot <lkp@intel.com>
> > This belongs in the changelog (that should be part of the commit
> > message). Something like "Fix xxx reported by kernel test robot".
> But I see existing commits have it.

It is used by commits whose sole purpose is to fix an issue that was
reported by the kernel test robot. In this case the robot merely
reported an issue with your v1. If you want to give credit, use the form
I suggested above. It is misleading otherwise.
