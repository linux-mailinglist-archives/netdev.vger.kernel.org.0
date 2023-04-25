Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F380E6EE959
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbjDYVGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjDYVGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:06:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B6516F2F;
        Tue, 25 Apr 2023 14:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FA6363052;
        Tue, 25 Apr 2023 21:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1419DC433D2;
        Tue, 25 Apr 2023 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682456776;
        bh=LYdfkmHjpUDIt4ybsiaAgtP+X8WmBhG5q7nBrjDacsA=;
        h=Date:From:To:Cc:Subject:From;
        b=OZAdvB4keL07ZwpDmoKq3hm9np2FuUW1Xi5+h2ZmQNbGFPZ7XGIvZjq6QSLPmcuv3
         7fP3a3yin5LSfsuKGxNjXvfDhS4Onwnh49Os91R0vhPfxsXnFrPdc+6IHRhbJ0iMIF
         D5MCPNZxGqM7DOJl28UeCTtpp8X+89tEytvqvfboXlQPt1NCY6LD5ml0nM8mnMV+vm
         thiSdLX1J94tHuh8LWQTanoMGhGrBaFohV21hX6Ueu9Lop9Iv9ZwIiBg5e6kKvvX/8
         Re9dT8bkhS0cCX1hmp4e39Aed7L5JA8IyzIpE91042HUM85z8dww+7L4nkvSYoCvFf
         w/pc90sFCbkAg==
Date:   Tue, 25 Apr 2023 14:06:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, netdev-driver-reviewers@vger.kernel.org
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: [ANN] Mailing list migration - Tue, May 2nd
Message-ID: <20230425140614.7cfe3854@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all!

We are planning to perform a migration of email distribution for 
the netdev@vger mailing list on Tue, May 2nd (4PM EDT / 1PM PDT).

There should be no impact to the workflow, the only expected change
will be a different set of Received: headers. The emails should start
to flow via the kernel.org servers.

Konstantin also points out that this is the first ("inaugural") time 
a live re-plumbing of an exiting vger mailing list will be performed so
minor bumps may occur. Hopefully given the very low ML traffic during
the merge window any potential disruption will be of no significance.

vger have served us well over the decades (let's defer the full "thank
yous" for after the migration ;)) but we're hoping that migrating to 
a more recent(?) stack will smooth out remaining occasional glitches.
And perhaps more importantly allow us to integrate better with existing
kernel.org infrastructure (lore).
