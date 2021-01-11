Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CF62F0AC3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 02:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbhAKBZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 20:25:19 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47637 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727072AbhAKBZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 20:25:19 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id D05165C00A2;
        Sun, 10 Jan 2021 20:24:32 -0500 (EST)
Received: from imap2 ([10.202.2.52])
  by compute2.internal (MEProxy); Sun, 10 Jan 2021 20:24:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lIBYr6
        w8w/Ei7lFbgWQyvXoNE3+eNf7bR09eKjaiJDc=; b=HgPcadO6Esk8qcLmdtgBDZ
        FCmvZRVOOtD7wJJFpSGySDpPw/tVXtJKslhpSw5cDaUx+k3lAqMFEjfhUruLXHHh
        SIRsdeAc1NoJdGfA8fF3027LYj/qeoYk7CwkXR+LKAvlXwmsYqxhdMJG3MYim3d0
        R6VSJS4VIUBP6e5xLEZEJN2cZCUgXNPGnPCDfRcwiXCP0CO6Ev5Gph95lTB3oYws
        F1cpPiqf57Z8FonJpB7MJudDAC1dX5trmnAbiehh39gtIBToy2QYs7rPJJbPGRJI
        bLlgItJTSUolZ3l87nf5n4Y8LTWrPjfKS7tnaAKA8zbvsEoFzbljP+R66PF3IyhA
        ==
X-ME-Sender: <xms:0Kj7X_HV-IUi_A-AVtVdwl0lUjJGAGld05Myl94EuBr8-xiC9YwUfA>
    <xme:0Kj7X8W5Sxt1xDO8hp6OHw4cZfKweJyeFbVyh4uWUAPvhxKpegmTNcPRGgJkjBJDQ
    AQ8t56VHxJwHkIfAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreerjeenucfhrhhomhepfdevhhgr
    rhhlihgvucfuohhmvghrvhhilhhlvgdfuceotghhrghrlhhivgestghhrghrlhhivgdrsg
    iiqeenucggtffrrghtthgvrhhnpefftdffleeljeeiledukedutdffffeutdduudejudei
    tdeghfeigeejgfetkedtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegthhgrrhhlihgvsegthhgrrhhlihgvrdgsii
X-ME-Proxy: <xmx:0Kj7XxJvIbcjalJYQ-FxGENwhHb-J4vLu86Dw7-2FZkozUzwV3fY1g>
    <xmx:0Kj7X9HigUiL0cLjHU4x7KJlunbGULnC-Sd144bJCq2At_1xraBOag>
    <xmx:0Kj7X1UdBSRodE9YtZ16kY-to2daheQxu4ePZi-X87KY8vlwYc7gCQ>
    <xmx:0Kj7X4Qq63EMXzX6yplE0d2LmHMsC8XwKNvPOAulPiZ0d6eqOEOV-A>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id E3A1FE00BD; Sun, 10 Jan 2021 20:24:31 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-45-g4839256-fm-20210104.001-g48392560
Mime-Version: 1.0
Message-Id: <74a67121-99f6-4321-a54d-888ddf14ae2f@www.fastmail.com>
In-Reply-To: <pj41zlpn2cpukf.fsf@u68c7b5b1d2d758.ant.amazon.com>
References: <20210109024950.4043819-1-charlie@charlie.bz>
 <20210109024950.4043819-3-charlie@charlie.bz>
 <pj41zlpn2cpukf.fsf@u68c7b5b1d2d758.ant.amazon.com>
Date:   Mon, 11 Jan 2021 12:24:11 +1100
From:   "Charlie Somerville" <charlie@charlie.bz>
To:     "Shay Agroskin" <shayagr@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org
Subject: =?UTF-8?Q?Re:_[PATCH_net-next_2/2]_virtio=5Fnet:_Implement_XDP=5FFLAGS=5F?=
 =?UTF-8?Q?NO=5FTX_support?=
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021, at 04:31, Shay Agroskin wrote:

> Is this addition needed ? Seems like we don't set VIRTIO_XDP_TX 
> bit in case of virtnet_xdp_xmit() failure, so the surrounding 'if' 
> won't be taken.

Good catch, it looks like you're right. I'm happy to remove that extra branch although I would like to add a comment explaining that assumption:

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ed08998765e0..3ae7cd2f1e72 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1472,8 +1472,10 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
                xdp_do_flush();

        if (xdp_xmit & VIRTIO_XDP_TX) {
+               /* VIRTIO_XDP_TX only set on successful virtnet_xdp_xmit,
+                * implies sq != NULL */
                sq = virtnet_xdp_sq(vi);
-               if (sq && virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
+               if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
                        u64_stats_update_begin(&sq->stats.syncp);
                        sq->stats.kicks++;
                        u64_stats_update_end(&sq->stats.syncp);
