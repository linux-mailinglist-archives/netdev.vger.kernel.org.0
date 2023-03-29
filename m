Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F11E6CCFC5
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjC2CEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjC2CEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:04:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582D72683;
        Tue, 28 Mar 2023 19:04:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07C5FB81E11;
        Wed, 29 Mar 2023 02:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD8AC433D2;
        Wed, 29 Mar 2023 02:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680055481;
        bh=2n5WEJHReXc6qKCOp63iOvrUZb+NxK2umQnLKtjSfi0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HiPi7QHLiaz9nzbLRN9SyOi3JYZMgYiJvRavBa9xun7TrSek1MCxWpzJl6LQVkcyQ
         1FurcDdzCDRomaKs8pIKF34HxnlPBOQBfQZVNp9Jqi6x78P1hnC+FXRJGuOuGluEBV
         mGK6WDm2yVy5CPiL6psMbQxjiosI/V0au8v3Z72kU0Jqd675pQnJHVWL58HycblPUJ
         As7Jj9O7RuyNTMkyMxPGEMVq0ZG6MGE1GUK4y1TuqZ/goGWKnMaudYXgijUqV/Ith6
         reqVrNf4HHHLHf4YkcKfxCuJeaEOsHnLvPerJRH1DZQgGFd3ov8985Jvq9fSDlx/0s
         DKLuHnYx5+02g==
Date:   Tue, 28 Mar 2023 19:04:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: netdev: clarify the need to sending
 reverts as patches
Message-ID: <20230328190440.0f918125@kernel.org>
In-Reply-To: <7975a642-965b-81c7-d0e7-21e499b152ea@gmail.com>
References: <20230327172646.2622943-1-kuba@kernel.org>
        <7975a642-965b-81c7-d0e7-21e499b152ea@gmail.com>
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

On Mon, 27 Mar 2023 12:19:14 -0700 Florian Fainelli wrote:
> I would write immutable instead of stable here to convey the idea that 
> there are no history rewrites once the tree is pushed out.

I'll s/stable/immutable/ when applying, thanks!
