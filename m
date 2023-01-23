Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D47678AA4
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjAWWSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjAWWSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:18:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DED13DD0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:18:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6464A61138
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 22:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAE0C4339B;
        Mon, 23 Jan 2023 22:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674512317;
        bh=wJBFnapb44nkwv4HmdOwEheezqdJLMDz4DPm88z5UCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QaqRjDKpzSdOa/ASZ30OeP0l4BcYBjaGcpZ0Rl7Y6aLQJCa5a7tUX937WEHWwsQPW
         c+yF5V/41NxTITCUmlKRqj2duZRashdhcDa+7QSoXpvNhWFNsSoos40g4O587WZ6yw
         vcMFwLAF9G4lriRkv72qOpiwo8b/wSWIL+eAxuEeEftwxyHiOIo7SDVUrmHjAWWXmO
         ss6ARbsZ7niDP044CxnQt3/g+v0tRioVNixILI6nuyA1sALEnVXToYrBeWdgmTElAs
         QJOs/Vgf1gcgyUkvNAeygGMhwLbhChr27gU7uhOxVRZsmBfMdoaUHsgOUR2huoo1XC
         NmaAimSMnGIwQ==
Date:   Mon, 23 Jan 2023 14:18:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, jiri@resnulli.us,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 05/15] netlink: add macro for checking dump
 ctx size
Message-ID: <20230123141836.3a266ae3@kernel.org>
In-Reply-To: <Y86XpbLnEpiNZzTL@shredder>
References: <20230105040531.353563-1-kuba@kernel.org>
        <20230105040531.353563-6-kuba@kernel.org>
        <Y86XpbLnEpiNZzTL@shredder>
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

On Mon, 23 Jan 2023 16:20:21 +0200 Ido Schimmel wrote:
> > +#define NL_ASSET_DUMP_CTX_FITS(type_name)				\  
> 
> Wanted to use this macro, but the name doesn't make sense to me. Should
> it be NL_ASSERT_DUMP_CTX_FITS() ?

Yes :(
