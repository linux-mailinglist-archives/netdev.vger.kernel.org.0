Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151B443C509
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbhJ0I2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:28:53 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:57641 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237179AbhJ0I2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:28:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6E9AB580462;
        Wed, 27 Oct 2021 04:26:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 27 Oct 2021 04:26:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NmruXQ
        RRLc+2MIbIwpuGjGuoiT09FBpgQByDBiKEc6s=; b=mfF2/b/ydMN27MYAZfL8gv
        F5vy0F96zZOekqfgli6xA2nXwl8g6P9i4gib+CgbBQvHR8dvszXeeoKgR6BSvYWf
        hywkg8UrrDm3YcvlJgcNb2Ndjdnly2mBpfXYkUkfVH/plrUKsHzpSb/XlgrI+Yzg
        JI+g37517kiGETNwQW9mm1OM7rG8k1VF3JpEdbefPYgOgVQIT7XEbnKVsrf2Vlj2
        kFJ89iSfZ9AfaUQ06zKJVatj4zdgtfyo51bw3TCsGOCxe52HgUCYrkTn0WyFDQDa
        G6HUNF9YEqG8sAQMwuIgiqLeZSEKn/ov3eI3iy+a6Fn+g8rCKVXUCBOO1XlAkeAw
        ==
X-ME-Sender: <xms:Mg15YQ5KOwod8V0e7aRKezamL8esca6UmiYquXQtAhn8heUgKDwp5A>
    <xme:Mg15YR44pVDApmb-4WOkF5LtjkXYdjRSxAdOg2z4uF8t00Gs2SDteOomgJldC00Fw
    XHVO4tyZZqIyiA>
X-ME-Received: <xmr:Mg15YfcwzH0uTrWQWAMbxsVJrUKxuKSsuA40xqA67aVJUFeVwFpvPjFBTTqq-Y8eaBHSOSDdTIfU65repGLJm8WysX2E4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Mg15YVIvhp7S7EHv0OPz1tkvqob2yeiFABsCLGdbPm9EuBzdBknVGQ>
    <xmx:Mg15YUKWgQWhRAewty_yrMBbdWNUfwMOD32YPfUBA9wV1GRtk7nzoQ>
    <xmx:Mg15YWzi6gYw2KVik7URqvJdGBF7avHrQacoNfsShRpl9Zgn0JKqRg>
    <xmx:Mw15YZXIrZoMkz93qrA0tp5z9JyHJOZB-8Gtf8faKXgrJ6CjnTDl4g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 04:26:26 -0400 (EDT)
Date:   Wed, 27 Oct 2021 11:26:23 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 7/8] net: bridge: create a common function for
 populating switchdev FDB entries
Message-ID: <YXkNL8TXkGFpZsjB@shredder>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-8-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026142743.1298877-8-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:27:42PM +0300, Vladimir Oltean wrote:
> There are two places where a switchdev FDB entry is constructed, one is
> br_switchdev_fdb_notify() and the other is br_fdb_replay(). One uses a
> struct initializer, and the other declares the structure as
> uninitialized and populates the elements one by one.
> 
> One problem when introducing new members of struct
> switchdev_notifier_fdb_info is that there is a risk for one of these
> functions to run with an uninitialized value.
> 
> So centralize the logic of populating such structure into a dedicated
> function. Being the primary location where these structures are created,
> using an uninitialized variable and populating the members one by one
> should be fine, since this one function is supposed to assign values to
> all its members.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
