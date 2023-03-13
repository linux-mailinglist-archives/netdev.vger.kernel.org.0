Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7220F6B7F8A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCMRcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjCMRcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:32:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB5B57D0B;
        Mon, 13 Mar 2023 10:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75B5DB810D8;
        Mon, 13 Mar 2023 17:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A73C433EF;
        Mon, 13 Mar 2023 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678728733;
        bh=kBQZvQiMvjYP0fV8jZIRyQPB0R50gjhQHozclZYgHkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DY7V2U5794W9jheF7gv83qOgdkRXSLf8STzbPpdFef3YpGjdkybpYbql8etye+vXh
         mC/2f3kyA1+QOrCxlCcmgkbsasPe1q+WnLTzmua5gBmmieK1gBWCSTkQ3iOLc3ktER
         R5Bm3Chzhk6htBSchssjVa9lLWasWKAOzS87I1N+4ZwwKGG/UrRMp2as+Wrqnsb74d
         B/YBUpZnT3XYhn0hdYtxFlMhdQ4lp+596v6cc/dPWTGIiAwQS4NBPG4qYVdEZ+429C
         hiiL0DxpfYwH5NdyZmHkzjIN89GQQkuUynwJpNNEU89+4fuEhVDbFwADKXiimDl3kI
         7b83qkP+wRQdw==
Date:   Mon, 13 Mar 2023 10:32:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: pull-request: wireless-2023-03-10: manual merge
Message-ID: <20230313103212.2340fbd4@kernel.org>
In-Reply-To: <7b08d514-1cfa-4674-2b2a-cffd1f8994a5@tessares.net>
References: <20230310114647.35422-1-johannes@sipsolutions.net>
        <be8f3f53-e1aa-1983-e8fb-9eb55c929da5@tessares.net>
        <27fdfff6029bc3b8c9ee822a16596e2bac658359.camel@sipsolutions.net>
        <7b08d514-1cfa-4674-2b2a-cffd1f8994a5@tessares.net>
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

On Mon, 13 Mar 2023 14:03:12 +0100 Matthieu Baerts wrote:
> I don't think there is anything else you can do apart from confirming
> the merge resolution looks good to you :)

Yup, don't do anything special, we'll resolve based on what Stephen 
and Matthieu suggest and feed the resolution back to you after your
next PR.
