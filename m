Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7879B4AF6C2
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbiBIQbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiBIQbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:31:33 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0A9C061355
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 08:31:36 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7A90D32019B4;
        Wed,  9 Feb 2022 11:31:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 09 Feb 2022 11:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vOpDOd/uTd20qU2+b
        Gi8k7jdiUBphhXMiWCoPwaW5vY=; b=WOBZ2PFXWZiE/dgnEvLiXnO1ipv/pmp9q
        dovtEU6w3N8QajS8dK44SQAK/7qp0X5ugCAMCOAC5tT0yo6YVPYFLsYQrxzVBeB3
        GUTMRbSOoz5+Umslle1ll3DN7Vj2vOdHCqZRM8uUojKY5HJvOnP10DpdmpyRhm2P
        Yr/v2Q/XJfUeo3e3lpCMqVedUJxuo09l4XJ/d140Kg9xvWlFUje8QsAJtTkK5d7q
        o4Yqlv0+BSHl9mJtCqBUJIGOIQtvvKUNHz08i+hGIoPboBhVXBVdI6IxbiG9nAe9
        dXH7KF4wFlP4IKCPrsaS2RSOjv1/2Inzyy+8RAYF1LSWDqKryAfDQ==
X-ME-Sender: <xms:ZuwDYgLeYw6NXbrRbwIEQpGDD6pnpvjfwWYZUuujbKZ0SXyifRRtIg>
    <xme:ZuwDYgJvyYdhY7qhyrNS6OwSkKebRqGpMy5lQZpdbkk8c00uQighbBKbzirJJPtWG
    HfWjOutz9ZHOvc>
X-ME-Received: <xmr:ZuwDYgtouNPEJWspU7NqYZbEwc1KlqTEyIajsW7duZe6lJvj9ZQkmIlCMsOR1_Qh09rbmByWoI2EviRIQRwU8ei18wU7jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheelgdekkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZuwDYtaaBYxUeMm5xfSDIUpHoOIMTwPzjyPZLKhdAf5i3k1ZdB6IXg>
    <xmx:ZuwDYnb1CjURwaAnHzD4nXmj4OgsEF15PseWo7hmBJN93iAQdVdstg>
    <xmx:ZuwDYpAj4Yt8Zm8uMMFBIp3p5KaqeLn2ZJPzoTuMO0ITwvUbPEK2zg>
    <xmx:Z-wDYmn7tiWeyP2m-niLEbnIH10G0ySYODz1M36hoGnco6cDUaZmag>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Feb 2022 11:31:33 -0500 (EST)
Date:   Wed, 9 Feb 2022 18:31:31 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>
Subject: Re: [PATCH net-next v2 0/5] Add support for locked bridge ports (for
 802.1X)
Message-ID: <YgPsY6KrbDo2QHgX@shredder>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 02:05:32PM +0100, Hans Schultz wrote:
> This series starts by adding support for SA filtering to the bridge,
> which is then allowed to be offloaded to switchdev devices. Furthermore
> an offloading implementation is supplied for the mv88e6xxx driver.

[...]

> Hans Schultz (5):
>   net: bridge: Add support for bridge port in locked mode
>   net: bridge: Add support for offloading of locked port flag
>   net: dsa: Add support for offloaded locked port flag
>   net: dsa: mv88e6xxx: Add support for bridge port locked mode
>   net: bridge: Refactor bridge port in locked mode to use jump labels

I think it is a bit weird to add a static key for this option when other
options (e.g., learning) don't use one. If you have data that proves
it's critical, then at least add it in patch #1 where the new option is
introduced.

Please add a selftest under tools/testing/selftests/net/forwarding/. It
should allow you to test both the SW data path with veth pairs and the
offloaded data path with loopbacks. See tools/testing/selftests/net/forwarding/README
