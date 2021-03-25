Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFACE3493D9
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhCYOOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:14:39 -0400
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:59451 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230078AbhCYOOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:14:12 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.west.internal (Postfix) with ESMTP id 69337F63;
        Thu, 25 Mar 2021 10:14:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 25 Mar 2021 10:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:cc:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=KkT11HUqTYeekK/o5YdPaXG6g8
        jljOZ2mrwXvPkeXAE=; b=dQ4nZaKjvnp48a2uvqiivRJXmVcwkam7mlQyUPyZ1g
        BtOv8AwSOgocDMZ9HZGAd5kExHi9iw+rxbXp3nqdf4V+JYnfuhaph4zo0yvOwmyp
        3rBugGDnpUCJW/I21IOb4Rywq7yC0SER8yH9PZrdffyheuoHXUU39fIFnE5CkEvO
        9TUhUu9FPMS8ON/t+Spf1N1W9c1wZI0sFNsZfEXbiw7XTaDgjOIlZrm6aiostXqB
        sOo8bYgjTldR42Lu8+7T4yfk5olvsbuFrlVLcjituQsoE/e6QiQaATpuwve2QBSP
        lV/wz35iVO6Kyn4XkH85TE+YtvxrX26/+0n0YCPR/rMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KkT11H
        UqTYeekK/o5YdPaXG6g8jljOZ2mrwXvPkeXAE=; b=W2SOTziiF5KI5hWuNQtjxX
        kX1elsDm8jRPosj2+YZ6px2FeMtK/Dl4f6j72eD9LY0EA8zUhccTzEFJiBmTLcLC
        cKp8FkNIPsQCcpwhLbXBOIjzMeu/bO5mEzYgzOr5u7PB8KEnaj4O+cRcIIwo30AU
        /GdqtWZfs28OVg0bVEOcFG0L+nbPXrxjopsnZcsD1xWn/Tx7ZliF9idnY/QVK1mB
        qDyFCTSk8dbbyVtIRCr34qaDYd59VywsaWkSBLipJKuHiLiXRyDoIyBMnp/OO2aC
        gspTsYqHUMSFtSYEt680NcygrsK9gYM3VwWpZ52JnJ/DJcyCyc863Nfb25lXwvOg
        ==
X-ME-Sender: <xms:r5pcYJZJcx3IJXT1bXr_5ye5bmnKBiG2g88DjmWQRGg60_1coeFRug>
    <xme:r5pcYPYdtG3_OentIhSgv9f-z-iW0JA5RnORNuzWq9QUFJFsAYUIKmJJXYKnP6Bec
    kVWdjhazlQ4qS9YxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehtddgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgtfggggfesthejredttderjeenucfhrhhomhepvehhrhhishcu
    vfgrlhgsohhtuceotghhrhhishesthgrlhgsohhthhhomhgvrdgtohhmqeenucggtffrrg
    htthgvrhhnpeejvdduffdugeekudfgudehhffggfdvgefhuefhveelfeefledutedvkedv
    feekveenucffohhmrghinhepohhfohhnohdrohhrghenucfkphepuddvkedrvddrheeird
    duvdelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    tghhrhhishesthgrlhgsohhthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:r5pcYFm224Sh94gcdbP_j5ckJKFqTdxPCQpPjXZijvzjNxyAPAPCww>
    <xmx:r5pcYLaAm4GqNFP8rI1swRCWFjCoJSeV62TX5vBQkwZkYvvDa41ngQ>
    <xmx:r5pcYEqjqGb49ZL2u6HY1VAUS2UUYQysA48WaQHdPkXArhASy1ZPOw>
    <xmx:sZpcYAmPvPie6cQ9gOLD-vBnyzZQxMZk7_GTvvzGMbMMelDy3Yf9Tox_P4A>
Received: from CMU-974457.ANDREW.CMU.EDU (cmu-974457.andrew.cmu.edu [128.2.56.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6EBAA108006C;
        Thu, 25 Mar 2021 10:14:07 -0400 (EDT)
Message-ID: <76b036b7cc79c6d4b0236119d48c952622ebc27f.camel@talbothome.com>
Subject: Point of Contact to submit mmsd upstream patches, or is mmsd
 abandoned?
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Denis Kenzior <denkenz@gmail.com>,
        =?ISO-8859-1?Q?S=E9bastien?= Bianti 
        <sebastien.bianti@linux.intel.com>,
        Christophe Guiraud <christophe.guiraud@linux.intel.com>,
        Regis Merlino <regis.merlino@linux.intel.com>,
        Ronald Tessier <ronald.tessier@linux.intel.com>,
        Jens Rehsack <sno@NetBSD.org>,
        "debian-on-mobile-maintainers@alioth-lists.debian.net" 
        <debian-on-mobile-maintainers@alioth-lists.debian.net>,
        ankit.navik@gmail.com
Date:   Thu, 25 Mar 2021 10:14:07 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Apoligies if you get this email multiple times.

I have been working on the assumption that the ofono mailing list is
the correct avenue to submit patches for mmsd, and I have attempted to
submit patches on a couple of occasions:

https://lists.ofono.org/hyperkitty/list/ofono@ofono.org/thread/HFGZCER3I6G52SPSG44OC4KTHDO2ZEC6/

https://lists.ofono.org/hyperkitty/list/ofono@ofono.org/thread/CVOWCDC7H4G4F3N4RTUPPLOTJQ7LCHDY/

I have also attempted to contact the ofono group on the IRC mailing
list in February, January, and December in regards to submitting
patches. I have yet to recieve a reply.

At the suggestion of some other devs, I am casting a wider net to try
to get in contact with someone to see a) who do I contact about
submitting mmsd patches and b) is it abandoned?

Thank you!

-- 
Respectfully,
Chris Talbot

