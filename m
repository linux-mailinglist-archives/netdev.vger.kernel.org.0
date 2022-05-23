Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8C25306D0
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 02:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiEWAWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 20:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiEWAWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 20:22:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453DE2E68D
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 17:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9050B80E33
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 00:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E260C385AA
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 00:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653265327;
        bh=iQYWp6rpwFEpZbMdLWx05Me+onlyhG/C+OwLZhVUXxY=;
        h=Date:From:To:Subject:From;
        b=dyIDpu6trCgknHQUYlW/QJHMw/3qHcw5ZCmsHYnEONouBBitWQMdTdXKWVwtKuyrX
         UbMu9qSZwgg4LTc8/JtaeT5s/vcGTYpRFSDDhOL16CYgOca2ME2yC6XMrPRdRqns9g
         X5DDCRGcwejTGOt2f4rq4Df3xon8aTq8adhFadK0Ac/vhhL4aDQJHZXbXDBdVLkEDp
         W9gyD07GZu8m5R0UjkPjpRUkl7V4cgAbf0gT0KO5NhMGVpdVPgSMBpAFzFvYPVl5FC
         2OkvF5lc06YLXJMnFBVfxRsfiPVteWrZOMvIjceVasx9KKHF2CJwPN2pc3m5+UVFGn
         wVHaAov8nV6xA==
Date:   Sun, 22 May 2022 17:22:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: net-next is closed
Message-ID: <20220522172206.085845fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone!

Linus has cut the 5.18 release. We'll look thru what's already in
patchwork tomorrow and take remaining sub-tree PRs but any patches 
applied directly to the netdev trees should be fixes only from now
until the merge window is over.

Thanks!
