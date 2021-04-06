Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009B9355380
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343902AbhDFMTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:19:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60143 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239518AbhDFMTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:19:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ACD715C013E;
        Tue,  6 Apr 2021 08:19:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Apr 2021 08:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NrH+DJ
        MP++B6JxHpTs6OW2KhjsRKn5J2ISyaZoauhI8=; b=b/yLqllUI+DQnoDRTfEitP
        n7KUQVPIZdJuWElW/qUQDfS5Y6OT2r+rLAc1SdmW9JT7IBa43LbdpsrJEau0I1dQ
        jTS6krUf4jAe+3RqKnbluntkUcDJRAnpy8enbWvjH+d9gfbGv2fCPxHBmsstnqQQ
        80Diyf6t3ADt6aF6munVnOEIPQeO7iprbd0qmRNW8yTkiHetN5MPYXnCq5lH9PtG
        EumhcZd+47uouUrmMf6VkhzY9ex7ViUZ2w2x7ks3ywVSocX6ITueJ1UEvUlias2q
        2Z5szbFBL+EGQPmSzBC5or/Lsdr7gBYIJnD2+EMAZuQkSl9txlxiQkBu5g1I055g
        ==
X-ME-Sender: <xms:01FsYHSzyTVp8BMEV2BpscJe5EjXTP_LdTGSbmX79zY_oxw02ZR6IA>
    <xme:01FsYOCpCjQSgNjglYM_J3PCNnNyWzS7TYB2K_p8wkNk6hbKC4iEusMjkwFSg04Aa
    xiRoWkUIMd6tSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejgedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:01FsYOgzPXDOA8WdLpSpPCBUAJ3CPhEer2Ew0_hue3tR6S5mbaqR_w>
    <xmx:01FsYPN_2gToVLIpuHM_zCgKj3zJjmqB779cTdrsMLpS-Q6yb3RIQg>
    <xmx:01FsYH4V2zV_mYdyTtxIWZc5z9hiWgamLm683VDftXfID0PCZ0j23Q>
    <xmx:01FsYN__vl-izFj8YesF9nLW24vb-14nl6be5Qke8OJGxKzDrGZQPA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1731C24005C;
        Tue,  6 Apr 2021 08:19:30 -0400 (EDT)
Date:   Tue, 6 Apr 2021 15:19:28 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Chunmei Xu <xuchunmei@linux.alibaba.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3] ip-nexthop: support flush by id
Message-ID: <YGxR0Atr9XyoSZSF@shredder.lan>
References: <20210406013323.24618-1-xuchunmei@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406013323.24618-1-xuchunmei@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 09:33:23AM +0800, Chunmei Xu wrote:
> since id is unique for nexthop, it is heavy to dump all nexthops.
> use existing delete_nexthop to support flush by id
> 
> Signed-off-by: Chunmei Xu <xuchunmei@linux.alibaba.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks
