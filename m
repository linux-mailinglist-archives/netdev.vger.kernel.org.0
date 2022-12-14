Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4102964CEB7
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 18:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239226AbiLNROi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 12:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbiLNROH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 12:14:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038E8264BD
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 09:13:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9428B61B53
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 17:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2E2C433EF;
        Wed, 14 Dec 2022 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671038023;
        bh=qg/73Ojuom3Ee1LL7utBPVK4FsKE/+1X2srb0p26zvI=;
        h=Date:From:To:Cc:Subject:From;
        b=QvoYtI28I9gfUhijJElB3EmMNug6MVg6bA/5FIb+3QfwhQaZgdsvZuMyPmfDGAWAZ
         LvxhExhcQp7GRDxMTWAsT0XuBeZIJFgc/HLg4YEu2AahP4umQwnL41tzfW6X00CD/+
         T4UtXnXMdtjsRFkW/g5Y84fhumMlCP4LDw67yuvGxXcRDYO4rGNLIix5zRakLg8zrj
         5OmdFrsEzYZyVXzLP3dNYauqkvGGzAisfy/dmMnS4MhFpRdkVNVJEExG0J+Z1UJSxk
         m20wAteCasdF4uwcvezUmcfSkGfhnYrpW6G9cfDKX5ztTFZdxuFo7N9IZbmRBiRU/8
         hXdwYtzed8zAA==
Date:   Wed, 14 Dec 2022 09:13:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>
Subject: [ANN]  net-next remains closed until January
Message-ID: <20221214091341.6a6a381b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

The merge window is coinciding with the end-of-year festivities 
for many. Some of the experts and reviewers we depend on day-to-day 
to get patches reviewed may be away all the way until New Year.

It seems to us that keeping net-next closed until January 1st/2nd
may be a good idea, so that people can take time off and relax.

Thoughts, concerns?

Here's a poll to express your opinion without typing:

https://poll-maker.com/poll4630178x899a594D-145
