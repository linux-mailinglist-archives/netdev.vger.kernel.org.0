Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DA74472C7
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 12:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhKGLxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 06:53:23 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41687 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhKGLxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 06:53:23 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2DE0E5C0116;
        Sun,  7 Nov 2021 06:50:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Nov 2021 06:50:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cjaQpi
        C8L/nKngC+S34FB0yi++6ByFLxCSdUnxpdKGM=; b=ih0w24OVyj9w4ogYqVCvTZ
        3GgJ1TFnNVE8ovqxACdZTDMTfq/KyXxAG1Jej4+t3VRhWIu2hnrAPUoWoy2Xt+AD
        k/mnlPL4n3w2aZvw+sudS1FgDbB2sGFQKS7fRPoBpsyPXo6ND/omKMkxn0JokgW4
        DfYPQ7SIi5SwnUyVuYJ3T8GcB50T6VkhsdTZv0n75uPpdq2smUA+vQ9NMHA/axCW
        a2REbJp/0Q2x1qSJZ+pSyU90YGs3N0/AdxufGXkP2E+9fFi7a/O/2tTaNOBBRSK3
        NNSsr8dX8HQREh3/Y1BMmKz2r1rsRiyARqCgxxRbeibHC66mOKbX09FxDhz6FntQ
        ==
X-ME-Sender: <xms:j72HYXqAg4A6U0z9FeQhtiosMNmq0i8mVbdn7tQm8Q3FrTz6iVrejg>
    <xme:j72HYRps2WHnlOoavylfsHdvchQtiepYboKg02myJ9A9GRDOqzfSrWTSrdqez0kUa
    sgLL5OCoCq4UIs>
X-ME-Received: <xmr:j72HYUO7CiwVjHe_W4QO6m5cboc6BOtxzBJd8MFvjcmDXLMlyF54BPNRTvlb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:j72HYa5Zd2WGgqo-HFR9IuNiEnHxXHmN2wfmw3_kHlGj5ZvxVBxpPg>
    <xmx:j72HYW5HDztyXVGnTephIaYxND86qCqe1n2CiamSpzf0R-nXB7QfbA>
    <xmx:j72HYSja_J1tVM5gB7m0gN-gBAhGxp5-dnCDRkV45-04j6IBPD6Z1Q>
    <xmx:kL2HYYT7XAyXrFmHgcW9gMRheG5OaSNjIJMhXVG7qRITVfMtn5rbzQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 7 Nov 2021 06:50:38 -0500 (EST)
Date:   Sun, 7 Nov 2021 13:50:36 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Is it ok for switch TCAMs to depend on the bridge state?
Message-ID: <YYe9jLd5AAurVoLW@shredder>
References: <20211102110352.ac4kqrwqvk37wjg7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102110352.ac4kqrwqvk37wjg7@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 11:03:53AM +0000, Vladimir Oltean wrote:
> I've been reviewing a patch set which offloads to hardware some
> tc-flower filters with some TSN-specific actions (ingress policing).
> The keys of those offloaded tc-flower filters are not arbitrary, they
> are the destination MAC address and VLAN ID of the frames, which is
> relevant because these TSN policers are actually coupled with the
> bridging service in hardware. So the premise of that patch set was that
> the user would first need to add static FDB entries to the bridge with
> the same key as the tc-flower key, before the tc-flower filters would be
> accepted for offloading.

[...]

> I don't have a clear picture in my mind about what is wrong. An airplane
> viewer might argue that the TCAM should be completely separate from the
> bridging service, but I'm not completely sure that this can be achieved
> in the aforementioned case with VLAN rewriting on ingress and on egress,
> it would seem more natural for these features to operate on the
> classified VLAN (which again, depends on VLAN awareness being turned on).
> Alternatively, one might argue that the deletion of a bridge interface
> should be vetoed, and so should the removal of a port from a bridge.
> But that is quite complicated, and doesn't answer questions such as
> "what should you do when you reboot".
> Alternatively, one might say that letting the user remove TCAM
> dependencies from the bridging service is fine, but the driver should
> have a way to also unoffload the tc-flower keys as long as the
> requirements are not satisfied. I think this is also difficult to
> implement.

Regarding the question in the subject ("Is it ok for switch TCAMs to
depend on the bridge state?"), I believe the answer is yes because there
is no way to avoid it and effectively it is already happening.

To add to your examples and Jakub's, this is also how "ERSPAN" works in
mlxsw. User space installs some flower filter with a mirror action
towards a gretap netdev, but the HW does not do the forwarding towards
the destination. Instead, it relies on the SW to tell it which headers
(i.e., Eth, IP, GRE) to put on the mirrored packet and tell it from
which port the packet should egress. When we have a bridge in the
forwarding path, it means that the offload state of the filter is
affected by FDB updates. As was discussed in the past, we are missing
the ability to notify user space when the offload state of the filter
changes.

Regarding the particular example of TSN policers. I'm not familiar with
the subject, but from your mail I get the impression that the dependency
between them and the bridge is a quirk of the hardware you are working
with and that in general the two are not related. If so, in order to
make the user experience somewhat better, you might consider vetoing the
addition of the flower filter or at least emit a warning via extack when
the port is not enslaved to a bridge. Regarding the FDB entries, instead
of requiring user space to understand that it needs to install those
entries in order to make the filter work, you can notify them from the
driver to the bridge via SWITCHDEV_FDB_ADD_TO_BRIDGE.
