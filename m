Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97BF187A95
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406943AbfHIMyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:54:31 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:40375 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406934AbfHIMya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:54:30 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9C1021425;
        Fri,  9 Aug 2019 08:54:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 09 Aug 2019 08:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=PGm6a7n2P2Lq732ozHzBOVkiNbmpy9g56pJ5QpmXH
        Uo=; b=A5G+njDjOR6hCGV4m3+caXJHUtrMw4vrnZUV4Gm9NjaLumeYSsOUsoUDx
        tbjNUBM9IrEe9IxmOru0wUh9joF8g98H72qyk1aLbZsT7VzgJURjNPHdFFbbAaiW
        e4Wtx3da2+1xCiROXUnlMt9Q1dTYM62CwO8Pllj1n9vUfR+/CplQPQ7y/Z6nyqIA
        fJ2XHaxckypl8JSRZW4pLyjxU37tlDzFO9PIncjfJBTPPfZxiwqnScesGnNDRKGz
        Tt3v1kSz1i5jT8CwCzIhD6e6PoCMholLrqCgMogjXWwuFQjXo+UfkylLV3pX8eG2
        C9sFKO4ahlKxxZEo8y/oewkAEhCjA==
X-ME-Sender: <xms:A21NXTD9CIZvhAshlxFjWKAjwSoXv1VW2cGjlQKPEwoFAo-khHGvxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddujedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtredunecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepje
    elrddujeelrdekhedrvddtleenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:A21NXehXovrFklOf1SNd_GkKnpWWdKy8CAvf5GCU3Cxf8bvYVOcQjw>
    <xmx:A21NXWcr0AiYjrw585nbAwCF9LtED7tQhnTSOqzCZFSP0qHYxuVGHw>
    <xmx:A21NXTlZmKmgRmRnoBMATwgsV0noHDB3RuA0k8iKGfuVkEWwr6G7gw>
    <xmx:BW1NXfVBiNv1ZKxEHHQvyY7rbD9MZbgqQbpNmQ5itXy-lNGR2dORFw>
Received: from localhost (bzq-79-179-85-209.red.bezeqint.net [79.179.85.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0140C8005B;
        Fri,  9 Aug 2019 08:54:26 -0400 (EDT)
Date:   Fri, 9 Aug 2019 15:54:18 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jiri@mellanox.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/10] drop_monitor: Capture dropped packets and
 metadata
Message-ID: <20190809125418.GB2931@splinter>
References: <20190807103059.15270-1-idosch@idosch.org>
 <87o90yrar8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o90yrar8.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 10:41:47AM +0200, Toke Høiland-Jørgensen wrote:
> This is great. Are you planning to add the XDP integration as well? :)

Thanks, Toke. From one of your previous replies I got the impression
that another hook needs to be added in order to catch 'XDP_DROP' as it
is not covered by the 'xdp_exception' tracepoint which only covers
'XDP_ABORTED'. If you can take care of that, I can look into the
integration with drop monitor.

I kept the XDP case in mind while working on the hardware originated
drops and I think that extending drop monitor for this use case should
be relatively straightforward. I will Cc you on the patchset that adds
monitoring of hardware drops and comment with how I think XDP
integration should look like.
