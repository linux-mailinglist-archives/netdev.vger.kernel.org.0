Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D1B4D37B6
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbiCIRCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbiCIRBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:01:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496A81B0C6B;
        Wed,  9 Mar 2022 08:48:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D9861B2F;
        Wed,  9 Mar 2022 16:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B792C340E8;
        Wed,  9 Mar 2022 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646844538;
        bh=u9TUmMvvL84wKfbpZHbTOVyvCleOTrddQFMEnYbsAs8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jBynXJ68PShWE60lgCRPnxtDdL0QpsfWA+C7u1WG1wJjW8LrrJfvXom9p+tjTWpN7
         fIpxXfp/pQGo1gfhGIaMjJAePhFrH8sEsy3Dti0ITK0+M6ktTszoiBd+Yik2E+MKXF
         6na0oE42RmNyFoWjJLsD4f/HF6Am9erTz7nNXEsqPp0WXIgNouHVqvWzL0cMVJ3ead
         LVXkcDMFpNMlLw51beQjAydvJzuJD6ju9SXCTxgixzcgNeDiBz0u/gpIhSCENqCUb0
         +GOtMRy99BsG+4k/mMn88GPxDr7bQX+DJYwDveqgnL3qm5gflkysAWhcX5WZWQFBcI
         YCqJRrmuHjPcw==
Date:   Wed, 9 Mar 2022 08:48:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>, 3chas3@gmail.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 17/27] atm: firestream: check the return
 value of ioremap() in fs_init()
Message-ID: <20220309084856.4e6ca9e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309161711.135679-17-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
        <20220309161711.135679-17-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Mar 2022 11:16:54 -0500 Sasha Levin wrote:
> From: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> [ Upstream commit d4e26aaea7f82ba884dcb4acfe689406bc092dc3 ]
> 
> The function ioremap() in fs_init() can fail, so its return value should
> be checked.

I'd hold off on backporting the bot fixes. They break more than they
fix.
