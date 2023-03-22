Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2F96C3F52
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 01:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCVAuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 20:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCVAuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 20:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFD9136C1;
        Tue, 21 Mar 2023 17:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E807761EF1;
        Wed, 22 Mar 2023 00:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B1BC433EF;
        Wed, 22 Mar 2023 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679446221;
        bh=8tWAk7Yv3dFxMlGP2RalHOgdUgUBkr/QGWokLJitdl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OwdADc+8oXZ2cczwJlFGh+81UFViuZyzBDSZtDJeq2qSR2wKCTGv4IEypLgILKj9Y
         Q2S0DH8fdE81byz2J9HPlzmCswCgdWnq1vdRLvuo3oVKFZh+Kr5KPc6DZ+KFmq8Ue7
         7zgJUO0BYpOQV6NUMTYWj3NwV+5G6VWFyfCAETq8ocOiLaWNuc84/UTee9GzycePXR
         NEDJ+anvIwiiy66um9qVebjutI3VDL2G4ruGEx5/rJD7vgJFLBpQp5ncpT2csSWpGg
         P36UGjTOJpyZ6+l4nSrHgAKKkG9G10OyDd/w3OQ+8CeTKIOUPGgmsYP0L6puH6E0A7
         RCZNJ1p/IRaHw==
Date:   Tue, 21 Mar 2023 17:50:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Bagas Sanjaya <bagasdotme@gmail.com>,
        Toke HHHiland-JJJrgensen <toke@redhat.com>, corbet@lwn.net,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        pisa@cmp.felk.cvut.cz, mkl@pengutronix.de,
        linux-doc@vger.kernel.org, f.fainelli@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] docs: networking: document NAPI
Message-ID: <20230321175019.3b6a525a@kernel.org>
In-Reply-To: <20230322001338.GA452632@electric-eye.fr.zoreil.com>
References: <20230321050334.1036870-1-kuba@kernel.org>
        <20230322001338.GA452632@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 01:13:38 +0100 Francois Romieu wrote:
> NAPI processing also happens in the unusual context of netpoll.
> 
> I can't tell if it's better to be completely silent about it or to
> explicitely state that it is beyond the scope of the document.

I stayed away from it, because from the perspective of driver
developers and users the calling contexts should not be depended on.
So I tried to stay vague on that, and explain what they should do
rather than what the core does.
