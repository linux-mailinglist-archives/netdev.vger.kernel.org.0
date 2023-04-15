Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7AC6E2E27
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 03:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjDOBWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 21:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDOBWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 21:22:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC08030F7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 18:22:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40DE06133F
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 01:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B2CC433EF;
        Sat, 15 Apr 2023 01:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681521740;
        bh=cGq8qDNSNBJZ8KckJ/96K4bgVgHXsaHCk6f2+8kH0yg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cXV5OnMaHyiLF0xeXSMHxGRw2vro4XoOxfx3X2nF6t+dZLCcWvqYVlxyaNnEA5vJx
         aHiRH51C0T7fGtaxAxA5q57/dhmkLIiK/RIydnf7TarAfpc35M2iDgsxV8AflCGVrO
         NBxrqjv1LEayfNT16Tn4YV4WgHmAfLsavackzfbciBn0rsNQpOvycJ1zZt03Einx+l
         NRC1cWkHMNAZ7Wl639YL76AMzBYdPU8og/ctrtHA80yuw0+VJ3HpLfHecEdY1P3a6E
         rCiudyFXuPb9TLdLmatevu0vn4g8xghDybEHAQnHDynBs4bZGuDtxdnkUa9AkUzFa7
         wLqLxxC0M39yw==
Date:   Fri, 14 Apr 2023 18:22:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH next-next v3 0/3] extend drop reasons
Message-ID: <20230414182219.7d0dd0bd@kernel.org>
In-Reply-To: <20230414151227.348725-1-johannes@sipsolutions.net>
References: <20230414151227.348725-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 17:12:24 +0200 Johannes Berg wrote:
> Here's v3 after the discussions. The first patch is new, to
> separate the reasons (needed in a lot of places) from the new
> infrastructure (needed only in skbuff.c, drop_monitor and in
> mac80211 in the last patch).

FWIW:

Acked-by: Jakub Kicinski <kuba@kernel.org>
