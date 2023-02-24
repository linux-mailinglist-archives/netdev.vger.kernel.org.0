Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAD86A227F
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjBXTrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBXTrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:47:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D40826A0;
        Fri, 24 Feb 2023 11:47:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3385B6191D;
        Fri, 24 Feb 2023 19:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2CFC433EF;
        Fri, 24 Feb 2023 19:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677268068;
        bh=7x7RMyBrMNxdXIjOI2FHc5R5kRG/pAzM/Nkr5aIWNis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YLpW74gF4EhGKpezuhdJIzq2mhQ3ca48V/ZCrDN2tq57T0VwWQD8//Ob8b5mcIPTf
         GM3fD/zvKqZunKFbVetQiwh9kgTYlF3cKvTx1Lzsg6lwytBlvHQA41LFuy8L4H4OB7
         pD1omW7iQSuDn+4u75a3KK4iTs83PFCm/oqpQl3euWdONXMXuhqFFhJHAhLntUlTc9
         Bj+KQwa8zTVHRjuRyrC019eWPUV/gWYZMlT4pVUjdmEijQarxMizBzmz8mC9WWJki1
         voRD8yqeVU7nHACrea2mhUPiwrbEQ+gJrTCrSS1Y9t2+xiqldcDfdYCYs5CLOhJi9Y
         E4LR+aZD3qcTg==
Date:   Fri, 24 Feb 2023 11:47:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH] wifi: wext: warn about usage only once
Message-ID: <20230224114747.1b676862@kernel.org>
In-Reply-To: <87lekn2jhx.fsf@kernel.org>
References: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
        <87lekn2jhx.fsf@kernel.org>
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

On Fri, 24 Feb 2023 17:03:38 +0200 Kalle Valo wrote:
> Linus, do you want to apply this directly or should we send this
> normally via the wireless tree? For the latter I would assume you would
> get it sometime next week.

FWIW the net PR will likely be on Monday afternoon, pending this fix
and the Kconfig fix from Intel.
