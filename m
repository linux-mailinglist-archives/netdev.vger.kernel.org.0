Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3EA5974EE
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237957AbiHQRTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238406AbiHQRTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5389C1D9;
        Wed, 17 Aug 2022 10:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BC97B81E7D;
        Wed, 17 Aug 2022 17:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2961C433D6;
        Wed, 17 Aug 2022 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660756757;
        bh=qRzfysH3XWV3JWKS2lY8gaQtm+4fH/BNnQZ2uKVaPM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tF6QnQ4VaE3A+ew8gQFAD1alxXAakzEZ7i0Ltl/wUNiSI2kcZgmOO++5PO0vsTR1E
         5KvmWlit0MFCO4U35HEcuvE8rZ4aionYQJfrV7GtNmRGCwijr5D6h2WsIg89BzVSQ8
         H7ytJvEg+axdGXVupU5h9aq1mya3zq2L13YzUN0iagekv3RLI5BJqzT50CqlhNbQXc
         rPaPpM6ZoE56tkUaQPWMmOurCvGCNGyz534GMWGXN5x3ireYZyciqXSfLybe7XqS8F
         JvEGKAo4GssOrEm2jJqPs0eYNyS+YhCB3a/8jLiIoCdInRrbCxmM0ph7TY6CzLBu2m
         FKGXy5krJu+JA==
Date:   Wed, 17 Aug 2022 10:19:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Beniamin Sandu <beniaminsandu@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfp: use simplified HWMON_CHANNEL_INFO macro
Message-ID: <20220817101916.10dec387@kernel.org>
In-Reply-To: <Yv0TaF+So0euV0DR@shell.armlinux.org.uk>
References: <20220813204658.848372-1-beniaminsandu@gmail.com>
        <20220817085429.4f7e4aac@kernel.org>
        <Yv0TaF+So0euV0DR@shell.armlinux.org.uk>
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

On Wed, 17 Aug 2022 17:12:24 +0100 Russell King (Oracle) wrote:
> On Wed, Aug 17, 2022 at 08:54:29AM -0700, Jakub Kicinski wrote:
> > On Sat, 13 Aug 2022 23:46:58 +0300 Beniamin Sandu wrote:  
> > > This makes the code look cleaner and easier to read.  
> > 
> > Last call for reviews..  
> 
> I had a quick look and couldn't see anything obviously wrong, but then
> I'm no expert with the hwmon code.

That makes two of us, good enough! :) Thanks for taking a look.

> I build-tested it, and I'm not likely to any time soon. I think
> Andrew added the hwmon code for this PHY originally.
