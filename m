Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762EC644C25
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiLFTCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLFTCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:02:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8A632BBB
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 11:02:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4845C617A4
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 19:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96381C433D6
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 19:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670353328;
        bh=KrWCMFMlFry21qiMyBEc6ykC19tkyELdyS7fqhpUUYo=;
        h=Date:From:To:Subject:From;
        b=alFEDuTSmwVybb2kCIPbG3Yge/gGZDvpL7SjGPooDcD/Ni5/s721FFacb/ky9YeN8
         sQGL6H/c1x56ofhF4fWUB7q2Dte8tbCUtnOT0PmnmbV+4qgSuscvVulJ9gat8abcBM
         3vFUH63FKujAXhi4Ft1kFFhwOKDgkKT1CnTajTeL14Jz5mF9q0kBcU1Gvj1VEcI1Fa
         UTnO3Cxz4UR3WUyIsok1s7dTcKqqRgo3kNohqv6IdQa2MrXCbN31zdl7gcoVxyfstV
         NjJrpvjZjhNPxVJCQg0ULwFdkIAer9/s5LhoAnQIPk0ejNO5mXqwWcxNESHc47YNH5
         1snWPXq0IKNRQ==
Date:   Tue, 6 Dec 2022 11:02:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: driver reviewer rotation
Message-ID: <20221206110207.303de16f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_20,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

As some of you may have noticed we have restarted a structured reviewer
rotation. There should be an uptick in the number of reviews when you
post patches.

Here is some details, and background info.

The majority of submissions we get are for drivers. We have tried 
to create a driver review rotation a while back, to increase the
review coverage, but it fizzled out. We're taking a second go at it.

The new rotation is limited in length (4 weeks) and focused on
involving NIC teams (nVidia, Intel, Broadcom, plus Meta/FB to make 
it 4), rather than particular individuals. I picked the NIC vendors 
for multiple reasons - with small exceptions they send more patches 
than they review. Secondly they have rather large teams, which makes 
it easier to create a stable rotation - employees from the same org 
can load balance and cover for each other. Last but not least, I have 
a possibly unfounded belief, that in a vendor setting the additional
structure of a review rotation is doubly beneficial as "organized
efforts" are usually easier to justify to corporate overlords.

Please feel free to reach out if you'd like to also be a part of 
a review rotation. We can start a second circle or double up one of 
the shifts... we'll figure something out. Also please reach out with 
any comments / concerns / feedback.

FWIW any "corporate involvement" in the community makes me feel uneasy
(and I hope that other community members share this feeling).
So please don't view this as any form of corporate collusion or giving
companies themselves influence. This is also not an indictment against
the community members who are already investing their time in reviewing
code, and making this project work...

HTH
