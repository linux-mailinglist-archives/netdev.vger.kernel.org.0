Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95332B990E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgKSRKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:10:00 -0500
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:45286 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728461AbgKSRKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:10:00 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id B61D8837F24A;
        Thu, 19 Nov 2020 17:09:58 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2610:2692:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:4250:4321:5007:6119:6120:6742:7901:8531:9010:10004:10400:10848:10967:11232:11658:11783:11914:12297:12663:12740:12895:13069:13172:13229:13255:13311:13357:13439:13894:14181:14659:14721:21080:21212:21627:21740:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: honey44_0e0784727344
X-Filterd-Recvd-Size: 2491
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Thu, 19 Nov 2020 17:09:55 +0000 (UTC)
Message-ID: <088057533a9feb330964bdab0b1b8d2f69b7a22c.camel@perches.com>
Subject: Re: XDP maintainer match (Was  [PATCH v2 0/2] hwmon: (max127) Add
 Maxim MAX127 hardware monitoring)
From:   Joe Perches <joe@perches.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Tao Ren <rentao.bupt@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Date:   Thu, 19 Nov 2020 09:09:53 -0800
In-Reply-To: <20201119173535.1474743d@carbon>
References: <20201118230929.18147-1-rentao.bupt@gmail.com>
         <20201118232719.GI1853236@lunn.ch>
         <20201118234252.GA18681@taoren-ubuntu-R90MNF91>
         <20201119010119.GA248686@roeck-us.net>
         <20201119012653.GA249502@roeck-us.net>
         <20201119074634.2e9cb21b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <20201119173535.1474743d@carbon>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-19 at 17:35 +0100, Jesper Dangaard Brouer wrote:
> On Thu, 19 Nov 2020 07:46:34 -0800 Jakub Kicinski <kuba@kernel.org> wrote:

> I think it is a good idea to change the keyword (K:), but I'm not sure
> this catch what we want, maybe it does.  The pattern match are meant to
> catch drivers containing XDP related bits.
> 
> Previously Joe Perches <joe@perches.com> suggested this pattern match,
> which I don't fully understand... could you explain Joe?
> 
>   (?:\b|_)xdp(?:\b|_)

This regex matches only:

	xdp
	xdp_<anything>
	<anything>_xdp_<anything>
	<anything>_xdp

> For the filename (N:) regex match, I'm considering if we should remove
> it and list more files explicitly.  I think normal glob * pattern
> works, which should be sufficient.

Lists are generally more specific than regex globs.


