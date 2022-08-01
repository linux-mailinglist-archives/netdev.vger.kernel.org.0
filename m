Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E464958634A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 06:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbiHAEWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 00:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiHAEWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 00:22:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E5DA45B
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F63460AB1
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 04:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0751C433C1
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 04:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659327736;
        bh=NhtZelALnywnD3sXc1m8QTWDN8L27GESJsQZ8x7PYcY=;
        h=Date:From:To:Subject:From;
        b=Rm0ervYu0i3KtcChtySWTl0iCmZi89epWrh+yUwekGGmpSmSTgLmvTnPip3HZPBru
         Gr9KCcvEffs5ivaR6knmwXijFYKDMG25U4rKVC2hDbHi1Dwr5J2dNiL5GgekqEC84a
         1HWnGSToXFawjk4ZIZ9EGlR/TEWSouH0KPPzT2mBXLL+0vZdGfQFspTTTxeNTOn/RK
         hurJIRJETSRymvuKd/DORGvo7NzXrkadMk1dgujnSpkt6fu2nTAzsNCWrYHuZ/XhF4
         yDSbrNOXQTwrk/MmStWhR69afBlRZ01fwQOfB+cECUIxlOHeToZzw/MdZ0JXpgmRwt
         86VzRLzFSVVPw==
Date:   Sun, 31 Jul 2022 21:22:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: net-next is closed
Message-ID: <20220731212214.1c733186@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone!

Linus has cut the 5.19 release. We'll look thru what's already in 
the patchwork queue and take upstream PRs but please hold off on
(non-RFC) net-next patches until the merge window is over.

Thanks!
