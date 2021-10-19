Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA0B433E61
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhJSS3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:29:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234401AbhJSS3V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 14:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JH1NNHk3HUm92urj2ZC3chPYUD7KfljyzeK+oKIUyqs=; b=YdE8TiQk1w1vx/jpL2VBww16OT
        hcvBxu9gJGs3ixjQfMlG4Sriy023sUu8YXo0/l3F0EG9gRpPIwX9K2nQ3MlJb0iH/pGaERbglVvN/
        mxnrHX0iXwiZTqplaTTx/7MYdTcxgnxmmC14Lwwi6p9C12JyJj/DkW3NAqIxuZOCtgQQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mctpF-00B74M-MY; Tue, 19 Oct 2021 20:27:01 +0200
Date:   Tue, 19 Oct 2021 20:27:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Erik Ekman <erik@kryo.se>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] sfc: Export fibre-specific link modes for 1/10G
Message-ID: <YW8N9RlRD8/15GLP@lunn.ch>
References: <20211018183709.124744-1-erik@kryo.se>
 <YW7k6JVh5LxMNP98@lunn.ch>
 <20211019155306.ibxzmsixwb5rd6wx@gmail.com>
 <CAGgu=sAUj4g3v7u4ibW53js5U3M+9rdjW+jfcDdF1_A4H8ytaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGgu=sAUj4g3v7u4ibW53js5U3M+9rdjW+jfcDdF1_A4H8ytaw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 07:34:16PM +0200, Erik Ekman wrote:
> On Tue, 19 Oct 2021 at 17:53, Martin Habets <habetsm.xilinx@gmail.com> wrote:
> >
> > On Tue, Oct 19, 2021 at 05:31:52PM +0200, Andrew Lunn wrote:
> > > On Mon, Oct 18, 2021 at 08:37:08PM +0200, Erik Ekman wrote:
> > > > These modes were added to ethtool.h in 5711a98221443 ("net: ethtool: add support
> > > > for 1000BaseX and missing 10G link modes") back in 2016.
> > > >
> > > > Only setting CR mode for 10G, similar to how 25/40/50/100G modes are set up.
> > > >
> > > > Tested using SFN5122F-R7 (with 2 SFP+ ports) and a 1000BASE-BX10 SFP module.
> > >
> > > Did you test with a Copper SFP modules?
> > >
> 
> I have tested it with a copper SFP PHY at 1G and that works fine.

Meaning ethtool returns 1000BaseT_FULL? Does the SFP also support
10/100? Does ethtool list 10BaseT_Half, 10BaseT_Full, etc.

	Andrew
