Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1571F6E2E91
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 04:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjDOCUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 22:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjDOCUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 22:20:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734705B93
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 19:20:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 014A0615C0
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 02:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F73C433D2;
        Sat, 15 Apr 2023 02:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681525235;
        bh=wIuSI+Gl4pTuMyeyoLztHB1G5Mys8aVIlDm7sC2IU7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iEf/EEgTXDehqWOKyG8xorYnnAfN8p2YGkOAz3ogjTGoxBFyI2ePy+a7v2Pboux9l
         8o9vC8yzt9Ejg639jlrLvw6/oqrzS9A89q3hAJq0xEdqEyAUSVevhqP05tX4CAowTD
         BqGLvLcdBhrmC9XVvzoNP2c4K2nXiNbzZNpq3ARTpfulBS+jjA9zV0iaQ42x4mmSAi
         k0gKtXdZsbV3ms5pzLxOjekUeeM09EPouOuSuoqNp2CK1SvUqQupxCLr2aWBCRu6SQ
         uXzsgbxAjS1Z0mijaH0b0FeWL7Heb6pZ13Q+vpKDXjj4k0ePWW5RcenZ+lW3ex2WRP
         UPY0U3cnIGT6Q==
Date:   Fri, 14 Apr 2023 19:20:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH next-next v3 0/3] extend drop reasons
Message-ID: <20230414192034.23d40371@kernel.org>
In-Reply-To: <20230414182219.7d0dd0bd@kernel.org>
References: <20230414151227.348725-1-johannes@sipsolutions.net>
        <20230414182219.7d0dd0bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 18:22:19 -0700 Jakub Kicinski wrote:
> FWIW:
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

I take that back :)

This:

> +	/** @SKB_DROP_REASON_SUBSYS_MASK: subsystem mask in drop reasons,
> +	 * see &enum skb_drop_reason_subsys
> +	 */

is not valid kdoc, confusingly.
If it's longer than one line, the /** has to be on an otherwise empty line.

Run the new files thru ./scripts/kernel-doc -none, perhaps.
