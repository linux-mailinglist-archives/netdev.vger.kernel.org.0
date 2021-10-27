Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9643C43C342
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 08:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhJ0Gwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 02:52:41 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:57563 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235258AbhJ0Gwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 02:52:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1F1EF58048E;
        Wed, 27 Oct 2021 02:50:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 27 Oct 2021 02:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JT5dhv
        Qsj1ZgzOe2KBub+ojqlPebz5FPcr4vC4NIfAY=; b=TBJV8ulj4TT28/5kreAwvR
        50nG8iOhmAziOuVt0+DuK8LOX/4ZQ1eJ8AmciJR/wA1VzRNcrqatuMs2E+OjaMYI
        ttg9rPGDvdsbFCmuTQrg2czyUl2jJKvanPQiWBgu+i+DtBqnVF33U5Z4pd8pjv5R
        HTEJ1K/Ka3jDAdIB+9CQL+wSXMJbmhbTrDSyobcrUQ86ixryO13TsP6RqznAH2tZ
        kBFer6+1PhlkMl+sKNT379od5+k+6biMlABmHD6ZAk080svMdJVghGB/wc6/lqUw
        hZ/ZZOVX3Atj2Tkd3nNRZlm7bUACy83zyz5NaTU6UOAF4BKYmI7PnRKRWRoLyi5w
        ==
X-ME-Sender: <xms:pfZ4YRSOuxiYt-66fJ91WYpZ-ANvl-qjWF8rI3thMEjc9ifj3h_22A>
    <xme:pfZ4YayS56NUK1THWeeifO_lI6MSUexbiCDMb-g_ETgJNmavI1LJBRpHk2Kz9KQlT
    kRa8-aV0unUV_U>
X-ME-Received: <xmr:pfZ4YW1TUC0VanM4A-4KPi-qbXcVCekRRmhSjY3NaarvwXovj11e8-sfF5K7BJHd0Dp_9Ofis9HAmHEjy55f-VJoO-KBng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefledguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:pfZ4YZDfhikgCXmz9wNUVZYMYJoucnQduoH5oMMuQ_ONTUrj8-MukA>
    <xmx:pfZ4YahUTBB58HV4nRQwEYk2zWXAfRWcaNbP1qAu0DdoHbUjGP4SLQ>
    <xmx:pfZ4YdqXVcBjc8JISRZtDKGlNoT2mKcZknW1dmLgjoUzbvH9g3Tkbw>
    <xmx:p_Z4YVMEUwP2NtUniH6fCt5udI_tGAUhKYXyKf0lqkc20KVIlIc2mw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 02:50:12 -0400 (EDT)
Date:   Wed, 27 Oct 2021 09:50:08 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, mkubecek@suse.cz,
        saeed@kernel.org, michael.chan@broadcom.com
Subject: Re: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
Message-ID: <YXj2oKjjobd0ZgBi@shredder>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 07:31:41PM +0200, Maciej Machnikowski wrote:
> Synchronous Ethernet networks use a physical layer clock to syntonize
> the frequency across different network elements.
> 
> Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> Equipment Clock (EEC) and have the ability to recover synchronization
> from the synchronization inputs - either traffic interfaces or external
> frequency sources.
> The EEC can synchronize its frequency (syntonize) to any of those sources.
> It is also able to select synchronization source through priority tables
> and synchronization status messaging. It also provides neccessary
> filtering and holdover capabilities
> 
> This patch series introduces basic interface for reading the Ethernet
> Equipment Clock (EEC) state on a SyncE capable device. This state gives
> information about the source of the syntonization signal (ether my port,
> or any external one) and the state of EEC. This interface is required\
> to implement Synchronization Status Messaging on upper layers.
> 
> v2:
> - removed whitespace changes
> - fix issues reported by test robot
> v3:
> - Changed naming from SyncE to EEC
> - Clarify cover letter and commit message for patch 1
> v4:
> - Removed sync_source and pin_idx info
> - Changed one structure to attributes
> - Added EEC_SRC_PORT flag to indicate that the EEC is synchronized
>   to the recovered clock of a port that returns the state
> v5:
> - add EEC source as an optiona attribute
> - implement support for recovered clocks
> - align states returned by EEC to ITU-T G.781

Hi,

Thanks for continuing to work on this.

I was under the impression (might be wrong) that the consensus last time
was to add a new ethtool message to query the mapping between the port
and the EEC clock (similar to TSINFO_GET) and then use a new generic
netlink family to perform operations on the clock itself.

At least in the case of RTM_GETEECSTATE and a multi-port adapter, you
would actually query the same state via each netdev, but without
realizing it's the same clock.

I think another reason to move to ethtool was that this stuff is
completely specific to Ethernet and not applicable to all logical
netdevs.
