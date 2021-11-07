Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5B7447332
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 15:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbhKGOLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 09:11:31 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:44169 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbhKGOLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 09:11:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id BFDE0580870;
        Sun,  7 Nov 2021 09:08:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Nov 2021 09:08:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=LPXxBZ9hcKFsIAG6Gh0OKT3ko6pm8TaBuYfdcJ5X5
        eY=; b=cp9wxbFACt6kl6FJUezJwPTN6VfQwO8PU1xNaWhgh1o3d1T5TYslJchq4
        HzzSx+NEKk7a64V8D3Z0tPKGR4Q7CNMrYtFczQn7ysuCJcP3T6bMmKgmGf62xWvs
        Rdcjd8gXx91X+vDk9OJDv+0Ai5FonJM9/FwSpMKD8UcqEnl3FtqZ2TRicxAV0in5
        79kvVkbCwm2Mo9sxaepsqSjYXG1RJOlrxKoMvCV4RHZiqW36JMBJ9YSxr6gRJYRB
        etZXCsy4/hNrYTDK2F5EAkjz9cRq3IRaB66J8ULvTHu8JP03bd/pqxTfyt2tW/Rr
        l7zbX8aoIuoolZzT6uvAvdD4b0p9A==
X-ME-Sender: <xms:792HYXl2hKbk2AAteLcXf16AXazh7FalS3YinUwZ0eCOAuC0sgeHWw>
    <xme:792HYa1DWVZ_hSyjWDeu_AAicJCOimXrP6BMpIRfK1wrMfkccUWA9qO0pZd8IEiYD
    g1bt2CyDUdrZC8>
X-ME-Received: <xmr:792HYdqWq1ca-d0tBvdQe6Knu4FS5ArbsXN9eunr6nTXlBxMqrV-FDlrc-98>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeugfejfeeviedvkedtgfeghfegvedugeevgfetudfgteevveeutdfghfekgfeg
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:792HYfmCct8Si5lLS7pgXiKTnv0c6VZy6YjnNcocJG1gIFwiTkTYdg>
    <xmx:792HYV0-Pe0BR919C3pojr7m73QPXVcsBtBAXom6aTZg6xoq2iRGtA>
    <xmx:792HYeu3va0dvHylOGh1Mq-qlRXeANfguIsvEF1akjm4j-_tiJmchQ>
    <xmx:792HYfxTAncxmaimRXKiLOyTqaYm3yd2fQCuydeJMeGfJ2D4giUu4A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 7 Nov 2021 09:08:46 -0500 (EST)
Date:   Sun, 7 Nov 2021 16:08:44 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, mkubecek@suse.cz,
        saeed@kernel.org, michael.chan@broadcom.com
Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Message-ID: <YYfd7DCFFtj/x+zQ@shredder>
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
 <20211105205331.2024623-7-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211105205331.2024623-7-maciej.machnikowski@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 09:53:31PM +0100, Maciej Machnikowski wrote:
> Add Documentation/networking/synce.rst describing new RTNL messages
> and respective NDO ops supporting SyncE (Synchronous Ethernet).
> 
> Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
> ---
>  Documentation/networking/synce.rst | 117 +++++++++++++++++++++++++++++
>  1 file changed, 117 insertions(+)
>  create mode 100644 Documentation/networking/synce.rst
> 
> diff --git a/Documentation/networking/synce.rst b/Documentation/networking/synce.rst
> new file mode 100644
> index 000000000000..4ca41fb9a481
> --- /dev/null
> +++ b/Documentation/networking/synce.rst
> @@ -0,0 +1,117 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +====================
> +Synchronous Ethernet
> +====================
> +
> +Synchronous Ethernet networks use a physical layer clock to syntonize
> +the frequency across different network elements.
> +
> +Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> +Equipment Clock (EEC) and a PHY that has dedicated outputs of recovered clocks
> +and a dedicated TX clock input that is used as to transmit data to other nodes.
> +
> +The SyncE capable PHY is able to recover the incomning frequency of the data
> +stream on RX lanes and redirect it (sometimes dividing it) to recovered
> +clock outputs. In SyncE PHY the TX frequency is directly dependent on the
> +input frequency - either on the PHY CLK input, or on a dedicated
> +TX clock input.
> +
> +      ┌───────────┬──────────┐
> +      │ RX        │ TX       │
> +  1   │ lanes     │ lanes    │ 1
> +  ───►├──────┐    │          ├─────►
> +  2   │      │    │          │ 2
> +  ───►├──┐   │    │          ├─────►
> +  3   │  │   │    │          │ 3
> +  ───►├─▼▼   ▼    │          ├─────►
> +      │ ──────    │          │
> +      │ \____/    │          │
> +      └──┼──┼─────┴──────────┘
> +        1│ 2│        ▲
> + RCLK out│  │        │ TX CLK in
> +         ▼  ▼        │
> +       ┌─────────────┴───┐
> +       │                 │
> +       │       EEC       │
> +       │                 │
> +       └─────────────────┘
> +
> +The EEC can synchronize its frequency to one of the synchronization inputs
> +either clocks recovered on traffic interfaces or (in advanced deployments)
> +external frequency sources.
> +
> +Some EEC implementations can select synchronization source through
> +priority tables and synchronization status messaging and provide necessary
> +filtering and holdover capabilities.
> +
> +The following interface can be applicable to diffferent packet network types
> +following ITU-T G.8261/G.8262 recommendations.
> +
> +Interface
> +=========
> +
> +The following RTNL messages are used to read/configure SyncE recovered
> +clocks.
> +
> +RTM_GETRCLKRANGE
> +-----------------
> +Reads the allowed pin index range for the recovered clock outputs.
> +This can be aligned to PHY outputs or to EEC inputs, whichever is
> +better for a given application.

Can you explain the difference between PHY outputs and EEC inputs? It is
no clear to me from the diagram.

How would the diagram look in a multi-port adapter where you have a
single EEC?

> +Will call the ndo_get_rclk_range function to read the allowed range
> +of output pin indexes.
> +Will call ndo_get_rclk_range to determine the allowed recovered clock
> +range and return them in the IFLA_RCLK_RANGE_MIN_PIN and the
> +IFLA_RCLK_RANGE_MAX_PIN attributes

The first sentence seems to be redundant

> +
> +RTM_GETRCLKSTATE
> +-----------------
> +Read the state of recovered pins that output recovered clock from
> +a given port. The message will contain the number of assigned clocks
> +(IFLA_RCLK_STATE_COUNT) and an N pin indexes in IFLA_RCLK_STATE_OUT_IDX
> +To support multiple recovered clock outputs from the same port, this message
> +will return the IFLA_RCLK_STATE_COUNT attribute containing the number of
> +active recovered clock outputs (N) and N IFLA_RCLK_STATE_OUT_IDX attributes
> +listing the active output indexes.
> +This message will call the ndo_get_rclk_range to determine the allowed
> +recovered clock indexes and then will loop through them, calling
> +the ndo_get_rclk_state for each of them.

Why do you need both RTM_GETRCLKRANGE and RTM_GETRCLKSTATE? Isn't
RTM_GETRCLKSTATE enough? Instead of skipping over "disabled" pins in the
range IFLA_RCLK_RANGE_MIN_PIN..IFLA_RCLK_RANGE_MAX_PIN, just report the
state (enabled / disable) for all

> +
> +RTM_SETRCLKSTATE
> +-----------------
> +Sets the redirection of the recovered clock for a given pin. This message
> +expects one attribute:
> +struct if_set_rclk_msg {
> +	__u32 ifindex; /* interface index */
> +	__u32 out_idx; /* output index (from a valid range)
> +	__u32 flags; /* configuration flags */
> +};
> +
> +Supported flags are:
> +SET_RCLK_FLAGS_ENA - if set in flags - the given output will be enabled,
> +		     if clear - the output will be disabled.

In the diagram you have two recovered clock outputs going into the EEC.
According to which the EEC is synchronized?

How does user space know which pins to enable?

> +
> +RTM_GETEECSTATE
> +----------------
> +Reads the state of the EEC or equivalent physical clock synchronizer.
> +This message returns the following attributes:
> +IFLA_EEC_STATE - current state of the EEC or equivalent clock generator.
> +		 The states returned in this attribute are aligned to the
> +		 ITU-T G.781 and are:
> +		  IF_EEC_STATE_INVALID - state is not valid
> +		  IF_EEC_STATE_FREERUN - clock is free-running
> +		  IF_EEC_STATE_LOCKED - clock is locked to the reference,
> +		                        but the holdover memory is not valid
> +		  IF_EEC_STATE_LOCKED_HO_ACQ - clock is locked to the reference
> +		                               and holdover memory is valid
> +		  IF_EEC_STATE_HOLDOVER - clock is in holdover mode
> +State is read from the netdev calling the:
> +int (*ndo_get_eec_state)(struct net_device *dev, enum if_eec_state *state,
> +			 u32 *src_idx, struct netlink_ext_ack *extack);
> +
> +IFLA_EEC_SRC_IDX - optional attribute returning the index of the reference that
> +		   is used for the current IFLA_EEC_STATE, i.e., the index of
> +		   the pin that the EEC is locked to.
> +
> +Will be returned only if the ndo_get_eec_src is implemented.
> \ No newline at end of file
> -- 
> 2.26.3
> 
