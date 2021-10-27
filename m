Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241A443C392
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240359AbhJ0HMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:12:48 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:49521 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240339AbhJ0HMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:12:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9D92A58048F;
        Wed, 27 Oct 2021 03:10:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 27 Oct 2021 03:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UtrQ+Y
        qYfceMRQX4JEoo3nTqoGmlLfcy9dcq+X2CORs=; b=Y0uSgWZnRHybBDtftnIbXu
        SnH0HYdj2Mfp1foEa7BUGaqcE46OcCGmDwoe+Vkr7eScc7WNDjh4JDMn6QtoD6Uk
        k49tEhIkP+cID8Sm0lKd3jLCHF7TIq3SiiKmz/kgNMwFH8TinDjbk/3QizQ+djzA
        C9NU/TT0cOV6wy4Qsgdo3q4ItfgIobt+7Da+kULJaxR1nFmIRsUBCkqekfyJ8W6I
        Eta1MoVmYFo7OZ989S84a0+NKac9RbM9NGOyDVmxk6a5cyfSKifkpUYagUfNT/TH
        I8rSm6P1RwZdd5QnthlPspr6VKND72fN/psFtV+CkXx8divSDkoBF672ze8e93Qg
        ==
X-ME-Sender: <xms:Xft4YYZo5iTxojNPjiWsQ07U0EpPC8yQ1PQRmW-AsiOJoephoSF7CA>
    <xme:Xft4YTYBgY9ExehpHjnMMBWGpi3ZlwmabvXzeDFjOwMv_-LWqU6iRyiiEsY-Y3VsB
    ZUfRi5adqHwxIE>
X-ME-Received: <xmr:Xft4YS9gLOqo5JTJLOgONxNl9_K3zfmqZJ1LyiAGsgshFtKxG4ZrOE42BYx04m8jFpOo4AwyIppRPXbvcSpNpRQ6jot-bQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefledguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Xft4YSqahkXu9pQGa64jgqUK0dPlLaAjnEsRP577gPN_xyeyR3Arlw>
    <xmx:Xft4YTokzU87Pvn8UohVePn7ao_2qQHT7uTu8ddKKbj0oGeg49VBDA>
    <xmx:Xft4YQQlQ3uJeT3mQU5BjoDMWuf4H0wnE7Sq12gEEKZ0F1J7swmCcg>
    <xmx:Xvt4YW2ZfmyGyYATFNv4IxHlYGzysVDekTRuX8aWxiGghEkAn69YcQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 03:10:21 -0400 (EDT)
Date:   Wed, 27 Oct 2021 10:10:18 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, mkubecek@suse.cz,
        saeed@kernel.org, michael.chan@broadcom.com
Subject: Re: [RFC v5 net-next 2/5] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <YXj7WkEb0PagWfSw@shredder>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
 <20211026173146.1031412-3-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026173146.1031412-3-maciej.machnikowski@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 07:31:43PM +0200, Maciej Machnikowski wrote:
> +/* SyncE section */
> +
> +enum if_eec_state {
> +	IF_EEC_STATE_INVALID = 0,
> +	IF_EEC_STATE_FREERUN,
> +	IF_EEC_STATE_LOCKED,
> +	IF_EEC_STATE_LOCKED_HO_ACQ,

Is this referring to "Locked mode, acquiring holdover: This is a
temporary mode, when coming from free-run, to acquire holdover memory."
?

It seems ice isn't using it, so maybe drop it? Can be added later in
case we have a driver that can report it

There is also "Locked mode, holdover acquired: This is a steady state
mode, entered when holdover memory is acquired." But I assume that's
"IF_EEC_STATE_LOCKED"

> +	IF_EEC_STATE_HOLDOVER,
> +};
