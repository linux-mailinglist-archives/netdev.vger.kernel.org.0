Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC493E53C8
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 08:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbhHJGrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 02:47:06 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58903 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237004AbhHJGrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 02:47:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 09F125C00DA;
        Tue, 10 Aug 2021 02:46:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 10 Aug 2021 02:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JN+veN
        zxNu2yCry5BzS6GnnIFcdXcsuA3+5PUKwFlcc=; b=BoZoRpgnt+WDl8BD71cTnt
        7+BSt/lBzqXPG6bIDKHYFpMCqZjm66hBSO2UH09b53Th92wtPMTdJmf5VXOzw729
        vH5+g08CY/1HNoP1WJnQuZ8MH1q6gjJTP60B6R7DPaT6ZtRQqSpUTVDlYA7i8fR2
        fFFals9tLuBpY1kl8yoypuOM9LmqTNiNh/A/27YM5iEQltPcsj7T3HVu61cLltVF
        GFYB9cwoC0z/W0+EEHdWWhS70blb532RycTUfV2O8i2Tk/3TFbWL/k7Q6tgRDUpi
        GQdv0Itn4ZTYaZu0nnPgH4XYW1jpNvzjomNX/9tVX9FQnceVuZqO2s6/NF1An+YQ
        ==
X-ME-Sender: <xms:ziASYcBB5dSltBqSmw_JDrrgwpsv7-mYJWfx-mfFNAbIsOpK-2FJWQ>
    <xme:ziASYeiapQMMWSX8etxmjqs8jfDW8ynFazw9cERJ1un0j2wVhpTcPA1QrMUwCHt0r
    _LtHf6n-wabWSo>
X-ME-Received: <xmr:ziASYfm870syRJiw3-TmmqSN0pIppJ9vF7FmNwBzs2dGhJeRC9FqYOATTYE6uVKKxSKJ1TzoL5Kd7nrxutfsotsiq6-Sww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeekgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ziASYSyYSiGjB0dkA6JrRzz24bQUqi6HoIZrJ6esfI8Q9lc6_E16Tg>
    <xmx:ziASYRQXTt5Zh_pRcpSyfS4pAkqTAosvO-ryyv_fQo0gHPmmhcr5PA>
    <xmx:ziASYdZnUu-GxAcf8APzExRiW4ZoyIOZXmUCOosyZuF_Pg7mwCf4wQ>
    <xmx:zyASYSSvy1uQ3lBNBE9HnWlc7dlx6H51DryCBzxkK9zO0DBAIGw6eA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Aug 2021 02:46:37 -0400 (EDT)
Date:   Tue, 10 Aug 2021 09:46:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com" 
        <syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com>
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
Message-ID: <YRIgynudgTsOpe5q@shredder>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <YREcqAdU+6IpT0+w@shredder>
 <20210809160521.audhnv7o2tugwtmp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809160521.audhnv7o2tugwtmp@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 04:05:22PM +0000, Vladimir Oltean wrote:
> On Mon, Aug 09, 2021 at 03:16:40PM +0300, Ido Schimmel wrote:
> > I have at least once selftest where I forgot the 'static' keyword:
> >
> > bridge fdb add de:ad:be:ef:13:37 dev $swp1 master extern_learn vlan 1
> >
> > This patch breaks the test when run against both the kernel and hardware
> > data paths. I don't mind patching these tests, but we might get more
> > reports in the future.
> 
> Is it the 'static' keyword that you forgot, or 'dynamic'? The
> tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh selftest
> looks to me like it's testing the behavior of an FDB entry which should
> roam, and which without the extern_learn flag would be ageable.

static - no aging, no roaming
dynamic - aging, roaming
extern_learn - no aging, roaming

So these combinations do not make any sense and the kernel will ignore
static/dynamic when extern_learn is specified. It's needed to work
around iproute2 behavior of "assume permanent"
