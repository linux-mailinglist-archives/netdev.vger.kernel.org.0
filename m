Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F6D72991
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 10:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfGXIKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 04:10:47 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:46781 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbfGXIKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 04:10:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2FCB52038;
        Wed, 24 Jul 2019 04:10:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 24 Jul 2019 04:10:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=YQgodIuz3FH/EvWX8gPqzd/YXYWhKR9FGARlFyLtZ
        Ms=; b=MyuRsQtBEQ/Zj/LdIU7JZD/35oLrZR7zGZsGYo9sPPnOwAsbOL+9ELbR+
        Je6U0ocM/+ILzO8kUasY96MhxCADhj29hJwYzO5mawEsUSWfq0t7eAINj1nFmx2y
        IrMBhoenL03H7p7b47nCvHeFzlRazffr+zpjec6lEjWwonvqOFLv+wcFSYlWvnlH
        iege10TVcEOEAdWg579KPhpFYy7x71Kx9xrqJV1EiHR1pjKPngQc6cw1MGHHW2SM
        QxF3jFHiMMRljonTWkGr1uIAmWX9zTpFYVkMpgLvcHVq6SUVbpZ93x80KhAIli/F
        n8zeNLVlDWUMJPv4BJXCvwwnjIHFg==
X-ME-Sender: <xms:hBI4XQuQKzgUGs45kwCXZnNCbBh6sPfMUku7zwQb_oNUQTwCa6LmKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeelgdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtredunecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:hBI4XS05fbNaqooY27ctWodDm1tjnMECYGSs9rF7p6NXloziXZsjHw>
    <xmx:hBI4Xe1ddkjKkIbDnKdqpWT6-Mf_AReFTwifPybDaUMDuHxMzAM5FA>
    <xmx:hBI4XX3fFuVNWP9CU0cIEkcBBB7yh9VfTyqhIyRcOoPEdv5wlZSeYw>
    <xmx:hhI4XXwVF2FsZ5_72HHBq5W_ORJXL2EqJZOK2yvHraQ2euis9_ZHUA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 20634380079;
        Wed, 24 Jul 2019 04:10:43 -0400 (EDT)
Date:   Wed, 24 Jul 2019 11:10:42 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets
 and metadata
Message-ID: <20190724081042.GB15878@splinter>
References: <20190722183134.14516-1-idosch@idosch.org>
 <87imrt4zzg.fsf@toke.dk>
 <20190723064659.GA16069@splinter>
 <875znt3pxu.fsf@toke.dk>
 <20190723151423.GA10342@splinter>
 <87ftmw3f9m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ftmw3f9m.fsf@toke.dk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 06:08:21PM +0200, Toke Høiland-Jørgensen wrote:
> Also, presumably the queue will have to change from a struct
> sk_buff_head to something that can hold XDP frames and whatever devlink
> puts there as well, right?

Good point!

For HW drops we get an SKB and relevant metadata from devlink about why
the packet was dropped etc. I plan to store a pointer to this metadata
in the SKB control block.

Let me see how the implementation goes. Even if use sk_buff_head for
now, I will make sure that converting to a more generalized data
structure is straightforward.
