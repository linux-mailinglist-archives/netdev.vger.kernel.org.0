Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D223668B5E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 06:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbjAMFba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 00:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjAMFai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 00:30:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90A662186
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 21:30:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 835F562227
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66439C433D2;
        Fri, 13 Jan 2023 05:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673587835;
        bh=I4ZWCkWGx6w+x32XTE7THsjWliICRg8bV22gXl60nNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FAb+/E3c5GKZNX9e7jyPISGc/+DrGhFnTEQDolJM8n0psXBp8GX/ml4M/WBQzxHgg
         pKRvGFFAPnZQgyaZs8y9KHGzOb4gGClq0ZUN9dlWqoqfoiouSmehjy+oRui1OOHLn6
         0Xa8R2pJhAGB24tXWn5DoqjBiJZWqo2cIZlEe9BkH6nJgBgJK/cwlUOLuqb1MmoAnl
         f/furj53cRTJsdrZHT8pz5bkz6/kBPzvh782lkALIDENmXbJ50c5dbF1scNKWw1+n7
         RN9+odABZdD5KdzAeOW1s0PJXs4vmK50d7Hchbf5iwHFYjomrJp9K6jbkTEH6f7L5m
         d3rwWHxOWIQEg==
Date:   Thu, 12 Jan 2023 21:30:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <linux@armlinux.org.uk>,
        <hmehrtens@maxlinear.com>, <tmohren@maxlinear.com>,
        <mohammad.athari.ismail@intel.com>, <edumazet@google.com>,
        <michael@walle.cc>, <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3] net: phy: mxl-gpy: fix delay time required
 by loopback disable function
Message-ID: <20230112213034.074ff77e@kernel.org>
In-Reply-To: <20230111082201.15181-1-lxu@maxlinear.com>
References: <20230111082201.15181-1-lxu@maxlinear.com>
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

On Wed, 11 Jan 2023 16:22:01 +0800 Xu Liang wrote:
> GPY2xx devices need 3 seconds to fully switch out of loopback mode
> before it can safely re-enter loopback mode.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>

Looks like a fix, it needs a Fixes tag and needs to go to net.

Michael already asked you for the Fixes tag on v2, why did you decide
to switch to net-next instead?

We don't route fixes to net-next when they are targeting less
important features, in case that's your reason. Either something 
is a fix or it's not. If you think this is not a fix - you need to
explain in the commit message why.
