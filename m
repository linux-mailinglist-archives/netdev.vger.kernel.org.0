Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69F2573CCB
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 20:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiGMSxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 14:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGMSxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 14:53:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660F911C20;
        Wed, 13 Jul 2022 11:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ABD9B82113;
        Wed, 13 Jul 2022 18:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893EBC34114;
        Wed, 13 Jul 2022 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657738430;
        bh=sS66LRml9V4Ro5GV8zLe754VnCTJTPUq7aRvJU1titc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cGVNsl3/zmxcyg1KHex92WYXHN35LO7OI6nMoZD+GgDkaeQxdgFiXoWZC52BFLj9i
         W/ZG+v4XglE3tHTIzJxKLtkB2FHXeLzdj48TZakGlcQIc/FnOot/73xTkkmDIK1UE4
         ckYn/biGWKuwW/lpWsXRrvcdGTeRHd6sAHY1SmjYmLK4XUZpbMfXc7QAV/3d0eLqJF
         8zsFk/S+ahRwRx6rVrGfIRgLTYt/WwW/TQKCr6HMeVlDX6wAEB76UaidBuoDMux8rg
         Fdu+KZ/lx9UNprU7WdvcHMYgGcK+I8quEteWEAgY9SUzyL3LpkXqgfRa0o5WkyLGOe
         rLTRJED1Hr2iw==
Date:   Wed, 13 Jul 2022 11:53:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-07-13
Message-ID: <20220713115349.1703bb92@kernel.org>
In-Reply-To: <20220713071932.20538-1-johannes@sipsolutions.net>
References: <20220713071932.20538-1-johannes@sipsolutions.net>
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

On Wed, 13 Jul 2022 09:19:31 +0200 Johannes Berg wrote:
> Hi,
> 
> And another one, for next! This one's big, due to the first
> parts of multi-link operation (MLO) support - though that's
> not nearly done yet (have probably about as many patches as
> here already in the pipeline again).
> 
> Please pull and let me know if there's any problem.

Dave already pulled (I haven't seen the pw-bot reply, let's see whether
it will reply if I just flip the state back to "Under review" now).

Please take a gander at the new warnings in:
https://patchwork.kernel.org/project/netdevbpf/patch/20220713071932.20538-1-johannes@sipsolutions.net/
to make sure they are expected.
