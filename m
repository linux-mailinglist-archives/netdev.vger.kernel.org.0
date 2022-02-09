Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123AA4AF675
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbiBIQWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiBIQWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:22:15 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F616C0613C9;
        Wed,  9 Feb 2022 08:22:18 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0F3E23201ECF;
        Wed,  9 Feb 2022 11:22:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Feb 2022 11:22:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AyPVdM+Px9t0COZXk
        bffbEcG7jUs+g3bmwqXA+leG10=; b=RSpuffbPXoR40AZ9ceUtgeB07rV769Ft8
        eHwplwAELAmGPI15+xH8oXg872HcUkZdopoCy2IQ8baGRf69RivslgmlNforS3L6
        B3n2jpYNmpHgrxK/4eZ9wBObzLS8h8o+6V2+00WAv/lmKEXoX/5w/NQwgA2tYdn8
        M4kIn4FSiH7iEYnq0RkW7Von6lrqxTOjbpS/I4t9UE4hG/Zh8K9Qaq6FUept3goZ
        jAJ14d7C8VFOJl4vQ9oNvogbGJ8lcE31SXR8y9Za/TFvu5CJb3wt7GtSFRdSk4Ex
        iJlIBkdfs3NLgNcaEXynXA5cVgMu1eO0WCWadlCjuTrfHg5w6Ms5g==
X-ME-Sender: <xms:OOoDYqzZM_z5xmPGTflqWjqlekVYHSwJMdTqkO3tXfEuKIylbV1W4g>
    <xme:OOoDYmRSKhJC4L8of_iHkgrIfMOJj4FRGqYvrb6-ySblUI1t2zlMrcQL5BJ_-SgSe
    rtEHFYBt0Aq0tw>
X-ME-Received: <xmr:OOoDYsVEm2W8jivujWQChCTM6AbYvRQ2j8hgaoe2-Vq6_vMta_LdLeDtbAyljbDJVqe4rlaOUx6jtoRXUBVnOSM6vEgclw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheelgdekiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OOoDYgiyZEP5DXZAvv6IctTCf1j8vnyPZXzEYN3P2iYjEj4H57POQg>
    <xmx:OOoDYsDBdnXgFUvc7bHk_u-1PBl2vGjDBGMKRLL8WKNy1B2B_xbhzg>
    <xmx:OOoDYhKbiVPgxqc4mZH7LgdLb560mxDdeh7zkkaiq8aEyWJTptYrsQ>
    <xmx:OOoDYu0BOz6YJnd58Pgxahnk9QrOMzQkW-RhrYTBfzmdZ-Wsa36p-w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Feb 2022 11:22:15 -0500 (EST)
Date:   Wed, 9 Feb 2022 18:22:11 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     menglong8.dong@gmail.com
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, dsahern@kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH v8 net-next] net: drop_monitor: support drop reason
Message-ID: <YgPqM3PgIThH7iZy@shredder>
References: <20220209060838.55513-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209060838.55513-1-imagedong@tencent.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 02:08:38PM +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
> drop reason is introduced to the tracepoint of kfree_skb. Therefore,
> drop_monitor is able to report the drop reason to users by netlink.
> 
> The drop reasons are reported as string to users, which is exactly
> the same as what we do when reporting it to ftrace.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
