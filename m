Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BEE3245BC
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 22:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhBXVX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 16:23:57 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49117 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231950AbhBXVXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 16:23:53 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 458DA5C017E;
        Wed, 24 Feb 2021 16:22:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 24 Feb 2021 16:22:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenhack.net; h=
        message-id:from:date:subject:to; s=fm2; bh=1Ly9Z4FtSPcyVLmga9dAH
        QavLPBrs0tXE249C6PMA54=; b=ntoeuzBt5q2L/DXG56XqASvDa9nNk/wY9KPC1
        QwBZaTSs03Tp7+NdTr6kPiPMhOCPWa3L8UpGgobLGHtSdeeNQapwhgGlv/slIyX6
        SNW+6JzrLwkR2r/Ek4TwuFdbGS/1g6DTOLkCEBMNuKfs/TpA/KppuURuqT3/5Det
        f8EdGn21+RZOiLN1PwSsNMRBtv9RWQSVVlK5Qlt6U3qEM5yDZ//YE85bwjuPDqml
        sQNjyPkOvRExvRz7/hlNJE8LyG0g7hlrh/Fp9pDFLNitRpuDPgEwn2iKnkFErZdB
        N9LOVCYXDmeLQEmFAlrZ82/cGHeB++7VTGJDHDf8XiLIdrkhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=date:from:message-id:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=1Ly9Z4FtSPcyVLmga9dAHQavLPBrs0tXE249C6PMA54=; b=DybWK1r8
        Cjx7t3q64IgusaI7m6hdPjoVhI3aWvqczpHilWHSVsMC0cJT9LwapfRwwwv5pqgD
        iW4Q2f6q3lGqE6k8/XL8jKh2JOjiLJgmUHkLIIl9he9SP/ssb6VXJn7hN7ZOmoKF
        qOUZ03wLMxT228mB3vgbFCIPGB7aLYmC6/+G/seccFqU734zdhT5JDE2bfUXQS6h
        0gD8Emz7xuzMAd4IisLBpORjKynJ96fEB/VAJjmyTv6S+yz5IfbL6gHvtQbh7HAj
        vDskpRyJADiaL2iPjQchj/fcFz0ksowQdjcKQWJaCAVSoxjpDoYNPj4RltKzzKTU
        5hsKc9Wx+kwXxA==
X-ME-Sender: <xms:psM2YLdnaUilNlw_46eZRKr9RppdwZcJA_u2voQXuF0kg1AvWXdkpg>
    <xme:psM2YBOvuR5GxcrAHePBxppnx1qWJy27a1w9zfXNuH8y9JD-ATTHrMSzkoJa16glZ
    twIe7k7xV_tIsOTeFs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeejgddugeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkhfffuffvsedttdertddttddtne
    cuhfhrohhmpefkrghnucffvghnhhgrrhguthcuoehirghnseiivghnhhgrtghkrdhnvght
    qeenucggtffrrghtthgvrhhnpeffjedtveevhedvkedufedukeeikeeghfefudfhtefhge
    ejteeltdeiuefftdfffeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdgvrhhrohhr
    shdrthhoohhlshenucfkphepuddttddrtddrfeejrddvvddunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihgrnhesiigvnhhhrggtkhdrnhgv
    th
X-ME-Proxy: <xmx:psM2YEj1Pr-mHm4JwhR4D_7wzQIxpBS924BwOKmpqEi_67qBJKSlVg>
    <xmx:psM2YM-LcNG4EUntApIZSGihBuCDYdF6UWmeie80oY4b5rqyD-Ovfw>
    <xmx:psM2YHtFn-uCeCIET7HbMO5Ov-13zl6ajZzM5qMbMwnCux1-vVGO-g>
    <xmx:p8M2YAWimcceU3ivqioJyswvxeu4011hhTN1NA6Itr3P4l59dzIPLQ>
Received: from localhost (pool-100-0-37-221.bstnma.fios.verizon.net [100.0.37.221])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94E861080059;
        Wed, 24 Feb 2021 16:22:46 -0500 (EST)
X-Mailbox-Line: From b36c61004609b6499992ec08c8b69a255ab9a55d Mon Sep 17 00:00:00 2001
Message-Id: <cover.1614201303.git.ian@zenhack.net>
From:   Ian Denhardt <ian@zenhack.net>
Date:   Wed, 24 Feb 2021 16:15:03 -0500
Subject: [PATCH 0/2] More strict error checking in bpf_asm (v2).
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Second pass at the patches from:

https://lore.kernel.org/bpf/ef747c45-a68c-2a87-202c-5fd9faf70392@iogearbox.net/T/#t.

Patches are the same, this just addes the Signed-off-by: lines
as requested by Daniel Borkmann

Ian Denhardt (2):
  tools, bpf_asm: Hard error on out of range jumps.
  tools, bpf_asm: exit non-zero on errors.

 tools/bpf/bpf_exp.y | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--
2.30.1

