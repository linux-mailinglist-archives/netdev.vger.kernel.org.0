Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C70E3C482
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 08:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404125AbfFKGvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 02:51:40 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41709 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725766AbfFKGvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 02:51:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EEE32223AB;
        Tue, 11 Jun 2019 02:51:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 02:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JNGKLS
        zxgUIdG5wJkQvEnXIbykcjKGkYB8W4spYw9Io=; b=El1XBmf9WgOhXUGstG1+6x
        DFMDdDqK7w+RDKc4d+BP06qJnNpQ04Z9ggCSTQxrAY1tK4BgdKGJm8EAGz69aS55
        5tsNTlVRqcTlnN/1FX00lVIX3Y5xcIGcfFg0Gv9u8Lqwt8PoDr+kFbGWNzc0Po5x
        MSdGIaB+5SIn31QP2FhbChfl/FWjWnVGquDKQDi6gF+Yuy8cHK4rd+hKkEK7Hm3Q
        xhbj1cWnfOZPAWgeZWILr4brx+hhJ3X9qYnsXtaSg5oHTveTajijwLheWeZVY25j
        N4X+Y7FLAvIXEJnY7Zrb/HCy2oKdMLxkOEzFYGee+6CFPbrdjtnWh+xl8JjUooVw
        ==
X-ME-Sender: <xms:eU__XHJsOmRawMvZEiOvI5GsIQTwPbvMZQtfKJOpYPSvKrfraJnYRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehfedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:eU__XANnaOz9QzEg3w0L-o-eVwMsGUZGZauH6IdELqNvsXoHV1_XYA>
    <xmx:eU__XMvT6vBO0SfccXlqhISRKOgFeGbFKi5mLkV12aSmbTxSIKzb9A>
    <xmx:eU__XOEwl0wiJqnO87RKWPxMLF0kGp4HCTcMVR_gYdeqJMjI-2WLhQ>
    <xmx:ek__XMr-6gpEkPK4JnPXzH85KKTJCzwUjj5nwIIREmSbKMoWOFWSRw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23D588005C;
        Tue, 11 Jun 2019 02:51:37 -0400 (EDT)
Date:   Tue, 11 Jun 2019 09:51:35 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        netdev@vger.kernel.org, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/3] selftests: mlxsw: Add ethtool_lib.sh
Message-ID: <20190611065135.GB6167@splinter>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-2-idosch@idosch.org>
 <20190610133538.GF8247@lunn.ch>
 <20190610135651.GA19495@splinter>
 <bfd47cd0-2998-d2b9-7478-fb8cc6fee87c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfd47cd0-2998-d2b9-7478-fb8cc6fee87c@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 08:29:54AM -0700, Florian Fainelli wrote:
> On 6/10/2019 6:56 AM, Ido Schimmel wrote:
> > On Mon, Jun 10, 2019 at 03:35:38PM +0200, Andrew Lunn wrote:
> >> On Mon, Jun 10, 2019 at 11:40:43AM +0300, Ido Schimmel wrote:
> >>> From: Amit Cohen <amitc@mellanox.com>
> >>> +declare -A speed_values
> >>> +
> >>> +speed_values=(	[10baseT/Half]=0x001
> >>> +		[10baseT/Full]=0x002
> >>> +		[100baseT/Half]=0x004
> >>> +		[100baseT/Full]=0x008
> >>> +		[1000baseT/Half]=0x010
> >>> +		[1000baseT/Full]=0x020
> >>
> >> Hi Ido, Amit
> >>
> >> 100BaseT1 and 1000BaseT1 were added recently.
> > 
> > Hi Andrew,
> > 
> > Didn't see them in the man page, so didn't include them. I now see your
> > patches are in the queue. Will add these speeds in v2.
> 
> Could we extract the values from include/uapi/linux/ethtool.h, that way
> we would not have to have to update the selftest speed_values() array here?

Hi Florian,

Sounds reasonable. Will try this out.
