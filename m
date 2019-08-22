Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CEB98B7A
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 08:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbfHVGh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 02:37:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60723 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728480AbfHVGh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 02:37:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2BC5D221B2;
        Thu, 22 Aug 2019 02:37:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 22 Aug 2019 02:37:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=L573PL
        BJrCaTdOA0EHZxJhccfPMl6Qk5YoLxHt5JUCg=; b=kpT4BmWB07a2rF5l9cd5XT
        sMYD/M8twpbWFSxsbDEpWRckjkK+kNKceEaoqsEj5EHz2icHI1INE7L0rhHiU1Mn
        /NiBrAFvxGBPekKrZYIfhTqCBLh0BKdQGTLmiC4xs6ZgigoW3gX+m4elZnZS0SAq
        4MmwTG76zYVSNIzytkkrA07LN3o10AvZPA1toXxUyPNKUzaVpnCqWfckkSh6grXB
        JGPjykUg12ClpdgQdzlh9yPuq12Ax/y1JbZ5V8A0GSdDhHWGbAPQFOaiORRxR7ow
        Z8EfsbKaLKQk6f2dRowJFpJBuSWIEu4sh0Kr6qAJr+VC2waEXqGfnWjZYgvBVVKw
        ==
X-ME-Sender: <xms:QzheXVu2lcDGLgwyAQmixsDkUrQ0QwPn3Q_oVkfcoi-QhS2nY2ikFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeggedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:QzheXaEs-hiJSw2DOKzjkDKFE0GRWYJ4YhDwQ8gF4IqwzRkxLmyKQg>
    <xmx:QzheXa49sciRvzEgKEWCalWnSN7iC7cxP-o3-SQuJksc5IUO7TaqAw>
    <xmx:QzheXannySBE254_nhT5F7KrxhvMi22HynDOx2UYPGNo-HYGAGYmVQ>
    <xmx:RDheXTVyfXhL8HytX33Dk5TgoUfoXlBuVh-AczMyYgBMG5eTAsbtCw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 55C95D6005A;
        Thu, 22 Aug 2019 02:37:55 -0400 (EDT)
Date:   Thu, 22 Aug 2019 09:37:52 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/7] mlxsw: Add devlink-trap support
Message-ID: <20190822063752.GA13207@splinter>
References: <20190821071937.13622-1-idosch@idosch.org>
 <20190821.125910.2301425172924175320.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821.125910.2301425172924175320.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 12:59:10PM -0700, David Miller wrote:
> Series applied, although that rate should really be configurable somehow.
> 10Kpps seems quite arbitrary...

Yes, agreed. We plan to extend the devlink-trap API to expose these trap
policers and make them configurable.

Thanks for the review and for shepherding the entire submission towards
a more unified solution.
