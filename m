Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3258944731A
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 14:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhKGNrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 08:47:40 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37591 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230128AbhKGNrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 08:47:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 623235800BC;
        Sun,  7 Nov 2021 08:44:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 07 Nov 2021 08:44:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YYBzFB
        LaqRjypaCTOnoGZ+5BHWOftMjIYoQeVeLxb5Y=; b=HjB4hVxvEaAvjjqDPcyJIa
        5QrURh0Fua3tVbL77gFzPYJl4pH6s2U9GliabrhOxkp2y5J0FEA96r5VVEdFpkaf
        ppoJszTvIXgG10O9nBRM5JzZ27P6eouEoZ6eVs894PRykt9mK31nyHiKjP3jknEd
        rtyHdpVsSsw7MK7o0CnTXABl1uMKr4BLBbn3FT30z1RyOPGvMKUsuyWP05KHyYc7
        x94o8mGy0cZ81sVR4UnLv+QjieF/7d318HgJ3EmhqNub5gNR6EvBCY5iDbL3PPIo
        UG3hWa1Byc7EveD7+mWJhR+tCUXgQRptRkppbXn0RhP09Tjoe6ottP9H9nFByMUw
        ==
X-ME-Sender: <xms:V9iHYUdibIJ2ADw6i8_Krih-i-rH9sBz0OpmEkwYPmXGh8Y7NatbXA>
    <xme:V9iHYWO-21u9fdmFgxBoPiiV6hDBnnXbHrhNG6il_i0-lyde3qhSvhVDGSI18hDw9
    VBtVeaHuxwYKJM>
X-ME-Received: <xmr:V9iHYVhaQd5tc2v7b1gHBLlFeHTGfcrdGUBAiJObYAwp79vxXu4gj-di9Ulh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfgkeev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:V9iHYZ_zATfsMXtbU-0UbyfQjXVVhOK0OlldF78Ji3cG4fcU5VUW7A>
    <xmx:V9iHYQtZjeHSIB1h7H-jr3STB8LFdTRYTE150ZcBhVsm8b89gu-7bA>
    <xmx:V9iHYQFoOShoIwWFpJAMmPI4tPgmjtD2OhUW6accm2Nb_n32O5eHHw>
    <xmx:WNiHYSI6hxzOeY5nEuAMckML32XXM5t8J2vCk0UYOHbpRPqppjH9Ww>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 7 Nov 2021 08:44:55 -0500 (EST)
Date:   Sun, 7 Nov 2021 15:44:52 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, mkubecek@suse.cz,
        saeed@kernel.org, michael.chan@broadcom.com
Subject: Re: [PATCH v2 net-next 2/6] rtnetlink: Add new RTM_GETEECSTATE
 message to get SyncE status
Message-ID: <YYfYVA9j6Dk2rkDD@shredder>
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
 <20211105205331.2024623-3-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105205331.2024623-3-maciej.machnikowski@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 09:53:27PM +0100, Maciej Machnikowski wrote:
> +/* SyncE section */
> +
> +enum if_eec_state {
> +	IF_EEC_STATE_INVALID = 0,	/* state is not valid */
> +	IF_EEC_STATE_FREERUN,		/* clock is free-running */
> +	IF_EEC_STATE_LOCKED,		/* clock is locked to the reference,
> +					 * but the holdover memory is not valid
> +					 */
> +	IF_EEC_STATE_LOCKED_HO_ACQ,	/* clock is locked to the reference
> +					 * and holdover memory is valid
> +					 */
> +	IF_EEC_STATE_HOLDOVER,		/* clock is in holdover mode */
> +};
> +
> +#define EEC_SRC_PORT		(1 << 0) /* recovered clock from the port is
> +					  * currently the source for the EEC
> +					  */

Where is this used?

Note that the merge window is open and that net-next is closed:

http://vger.kernel.org/~davem/net-next.html

> +
> +struct if_eec_state_msg {
> +	__u32 ifindex;
> +};
> +
> +enum {
> +	IFLA_EEC_UNSPEC,
> +	IFLA_EEC_STATE,
> +	IFLA_EEC_SRC_IDX,
> +	__IFLA_EEC_MAX,
> +};
> +
> +#define IFLA_EEC_MAX (__IFLA_EEC_MAX - 1)
