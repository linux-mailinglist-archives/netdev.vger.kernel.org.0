Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF14F43CCF6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbhJ0PHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:07:34 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:49211 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235373AbhJ0PHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:07:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6E11B580615;
        Wed, 27 Oct 2021 11:05:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 27 Oct 2021 11:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hq6pi+
        m3tGTJ4s3XHUs6Y2MN1sZYG9iVHys0Kpw4DVM=; b=mLR4e7FbhsGItPTJRu+8dZ
        03uNLJrjcc8uEjecgCQNvb3MHPdGytumCqygPFIAe/TAfuN7hIyWwzMtbzIFVsy0
        adr/A8d54CfOmi4sfHCinzz3sJXUsIrW3qGb76Fpp15NgetbhkfnBDzspBQR705Z
        hHA002IEhtIGCI2koOIeJto9VBOmv0xVbebTbasEF0X/aDUpiLh9P2fu/tQZZXz2
        Xdu99BDffSc3g6g/riXbv5LmwZ435FDxDGruNabDWGvmFCktTTyjiAozjSTMB+Vi
        uR1vgbCbrBzxOCO50rQ+bRfMVPAZBg7EFmXqez6PHd6h6Szrskz9OuLLtXKGEV7w
        ==
X-ME-Sender: <xms:o2p5YSmtZI2knkQVqvceWeWbtAxhgNrLlWU8aEBUORP3sKwn0ISjRg>
    <xme:o2p5YZ2sMh8MyAJ0Epv8j4_HZH8vEA3BU-5U0k9058o-L4mn-Fw1ULVIn3r62ZlYo
    ZIX-gMuGPfeMG8>
X-ME-Received: <xmr:o2p5YQrlxA3HonDHC0XZXH1CUs-yw99SfH7Bcvmi5ddtaFqNLQiL2KVhz6eeXtqrOEMCTGddEP1kQuT2jruiUsHeduUMjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:o2p5YWntt9gUY8X4BkIIpmhkZSyUsYqr45jxB9rUDTo_RopLPWtv4A>
    <xmx:o2p5YQ0wrKwaa20uAjUgAa5SYBc3DxZ_HgmV5FC1OJ3E6dQZ3vRjMA>
    <xmx:o2p5Ydu_Xks3Bm_SBGVgWYS8r6yFM7zYq1b2lEAAhGMxW9MPaBZaTQ>
    <xmx:pGp5YWw6N4essO1oEXwSwlXw1wIc7AOfdKpVOpV3w35nI71n0r-Qrw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 11:05:06 -0400 (EDT)
Date:   Wed, 27 Oct 2021 18:05:01 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
Message-ID: <YXlqnXRw2iL7bGrh@shredder>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
 <YXj2oKjjobd0ZgBi@shredder>
 <PH0PR11MB4951A17040D860D8AC6975C1EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB4951A17040D860D8AC6975C1EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 01:21:58PM +0000, Machnikowski, Maciej wrote:
> 
> 
> > -----Original Message-----
> > From: Ido Schimmel <idosch@idosch.org>
> > Sent: Wednesday, October 27, 2021 8:50 AM
> > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> > Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> > richardcochran@gmail.com; abyagowi@fb.com; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
> > linux-kselftest@vger.kernel.org; mkubecek@suse.cz; saeed@kernel.org;
> > michael.chan@broadcom.com
> > Subject: Re: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
> > 
> > On Tue, Oct 26, 2021 at 07:31:41PM +0200, Maciej Machnikowski wrote:
> > > Synchronous Ethernet networks use a physical layer clock to syntonize
> > > the frequency across different network elements.
> > >
> > > Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> > > Equipment Clock (EEC) and have the ability to recover synchronization
> > > from the synchronization inputs - either traffic interfaces or external
> > > frequency sources.
> > > The EEC can synchronize its frequency (syntonize) to any of those sources.
> > > It is also able to select synchronization source through priority tables
> > > and synchronization status messaging. It also provides neccessary
> > > filtering and holdover capabilities
> > >
> > > This patch series introduces basic interface for reading the Ethernet
> > > Equipment Clock (EEC) state on a SyncE capable device. This state gives
> > > information about the source of the syntonization signal (ether my port,
> > > or any external one) and the state of EEC. This interface is required\
> > > to implement Synchronization Status Messaging on upper layers.
> > >
> > > v2:
> > > - removed whitespace changes
> > > - fix issues reported by test robot
> > > v3:
> > > - Changed naming from SyncE to EEC
> > > - Clarify cover letter and commit message for patch 1
> > > v4:
> > > - Removed sync_source and pin_idx info
> > > - Changed one structure to attributes
> > > - Added EEC_SRC_PORT flag to indicate that the EEC is synchronized
> > >   to the recovered clock of a port that returns the state
> > > v5:
> > > - add EEC source as an optiona attribute
> > > - implement support for recovered clocks
> > > - align states returned by EEC to ITU-T G.781
> > 
> > Hi,
> > 
> > Thanks for continuing to work on this.
> > 
> > I was under the impression (might be wrong) that the consensus last time
> > was to add a new ethtool message to query the mapping between the port
> > and the EEC clock (similar to TSINFO_GET) and then use a new generic
> > netlink family to perform operations on the clock itself.
> 
> Hi!
> 
> I believe we finally agreed to continue with this implementations (for a
> simplified devices) and when the DPLL subsystem is ready, plug it into this
> API as well using the discovery mechanism. As there may be some simplified
> solutions that would not use the controllable DPLL and only provide the
> status (i.e. using physical signals)

By "simplified solutions" you are referring to simple NEs that only
synchronize their frequency according to what they extract from the
physical layer as opposed to an external source such as in the PRC case?

> 
> > At least in the case of RTM_GETEECSTATE and a multi-port adapter, you
> > would actually query the same state via each netdev, but without
> > realizing it's the same clock.
> 
> True, yet for a given port we need info whether we are locked or not,
> so the interdependency wouldn't break anything.

But if two ports are using the same EEC, then it's not possible for them
to report a different EEC state, right? The only difference is that one
port can be the source and the other isn't, but this is also an
attribute of the EEC.

Basically, I'm saying that it seems that we report attributes of a
single object (the EEC) via multiple objects using it (the netdevs)
without making the relation clear to user space.

I'm not strictly against it, but rather wondering why.

>  
> > I think another reason to move to ethtool was that this stuff is
> > completely specific to Ethernet and not applicable to all logical
> > netdevs.
> 
> That was an open in previous discussion. Wanted to first show the
> full API to discuss where it fits. I believe all other networks (like SONET)
> may also benefit from having it in the netdev, but am open for discussion.

OK, didn't think about SONET. There is include/uapi/linux/sonet.h with a
few SONET specific ioctls and a couple of drivers implementing them. The
whole thing looks quite dead...

ethtool still seems like a better option for something that has
"Ethernet" in its name :)
