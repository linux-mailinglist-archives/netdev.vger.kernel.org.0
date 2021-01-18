Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8080B2FA812
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436755AbhARRzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:55:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407303AbhARRzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:55:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l1Yjo-001Jip-Lo; Mon, 18 Jan 2021 18:54:48 +0100
Date:   Mon, 18 Jan 2021 18:54:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Provide dummy
 implementations for trunk setters
Message-ID: <YAXLaAoNmFnJGL42@lunn.ch>
References: <20210115105834.559-1-tobias@waldekranz.com>
 <20210115105834.559-2-tobias@waldekranz.com>
 <YAGnBqB08wwWQul8@lunn.ch>
 <20210115143649.envmn2ncazcikdmc@skbuf>
 <YAGrRJYRpWg/4Yl5@lunn.ch>
 <87lfcuklig.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfcuklig.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hear, hear!
> 
> I took a quick look at the (stripped) object sizes (ppc32):
> 
> # du -ab
> 6116    ./global1_vtu.o
> 5904    ./devlink.o
> 11500   ./port.o
> 9640    ./global2.o
> 3016    ./phy.o
> 5368    ./global1.o
> 51784   ./chip.o
> 9892    ./serdes.o
> 5140    ./global1_atu.o
> 1916    ./global2_avb.o
> 2248    ./global2_scratch.o
> 948     ./port_hidden.o
> 1828    ./smi.o
> 119396  .

size, part of binutils, is the better tool to use.

$ size *.o
   text	   data	    bss	    dec	    hex	filename
  36055	   2692	      4	  38751	   975f	chip.o
   3821	    116	      4	   3941	    f65	devlink.o
   3229	     96	      0	   3325	    cfd	global1_atu.o
   4388	      0	      0	   4388	   1124	global1.o
   4449	     24	      0	   4473	   1179	global1_vtu.o
   1548	      0	      0	   1548	    60c	global2_avb.o
   6350	      0	      0	   6350	   18ce	global2.o
   1412	      0	      0	   1412	    584	global2_scratch.o
   1757	      0	      0	   1757	    6dd	phy.o
    284	      0	      0	    284	    11c	port_hidden.o
   7516	      0	      0	   7516	   1d5c	port.o
   6570	    188	      0	   6758	   1a66	serdes.o
    764	      0	      0	    764	    2fc	smi.o

> Andrew, do you want to do this? If not, I can look into it.

Yes, i will add it to my TODO list.

     Andrew
