Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8CC578F9B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbiGSBOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiGSBOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:14:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B891333E35
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 18:14:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51ECE61700
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 01:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F330C341C0;
        Tue, 19 Jul 2022 01:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658193272;
        bh=wWBV9PaheRgx2dXQwLgZabFmWtsUj3OJgIoNZtTTysI=;
        h=Date:From:To:Cc:Subject:From;
        b=Dxde9lv++DII+jJsRPJfumOyvjCE0FF6TNN621fXrbuCz81BWGmTvhB3ykNZBT6cX
         GsF6s6HDV45nhRoUiT3ruLk7Nv1K6FTnIQe328YlCP0TtU7vemuz/zMcArlJwoMMfS
         widhAfGqFlyTj/AQESlYegNSUrXjKaIU4KnYpeH2gXFkd8Ncq8+B2rRQQXgbPyfvm0
         CrfCKMFJuvVLaD4u51E0ztWOQK3F3p/Kle3u6EaiRVH+QhghpJDCNkTkaUZSUwns5U
         Z7tR/1+OqKalvbbSQyVI4BR3NRXH5rmqco68LU4LD75L1Cid98MNrfOx/HofnDTTvv
         pIViZ0kY3YJgA==
Date:   Mon, 18 Jul 2022 18:14:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>
Subject: main branches in netdev
Message-ID: <20220718181431.576754dc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

we added symlinks in the netdev repos main -> master.

I hope that the master branch will go away at some undefined 
point in the future so if you have hardcoded the name in your 
scripts please update.
