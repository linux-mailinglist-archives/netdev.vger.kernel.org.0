Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11F36CB2DB
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 02:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjC1Anv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 20:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjC1Anu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 20:43:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B07C4
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 17:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C09DC6155C
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 00:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A56C433D2;
        Tue, 28 Mar 2023 00:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679964229;
        bh=m3iB3u6yC+TQMuePIAhi5EPLJEEzw5mlbM7jKK7eEPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PlyJchQxqJ912tRU+5QodAnjgkyY9rZ09fEzckI1+9Mo3+Pyx6MccIKvyWn70NFJA
         4O8bX+bi/NnSB4GCEp+ER/4jmMLZL9gBEvVYqHT+YhOP0YPPIcAVw7H3WehUab1qJ6
         dczBkkBXvo1jBlL0Xj8QJHUwrWAFoqPxLua1PEw6hr2vra/iXPD/FMCarMFqn+pmYA
         H53PXvcIsylM0/9s+LeDqyNJfGH9eaFo8x2VR6jCPjmyu7VuarPPCA58MsTppx8nBP
         Yp19S4OAARkGtC1waLbA7X0W+dr8NHTKKD7zrBirANz6Z9OIxVE4HUv5f96JzCllV3
         CKDVVmlTNqxnQ==
Date:   Mon, 27 Mar 2023 17:43:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
Subject: Re: [PATCH v6 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Message-ID: <20230327174347.0246ff3d@kernel.org>
In-Reply-To: <0e4411a3-a25c-4369-3528-5757b42108e1@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
        <20230324190243.27722-2-shannon.nelson@amd.com>
        <20230325163952.0eb18d3b@kernel.org>
        <0e4411a3-a25c-4369-3528-5757b42108e1@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Mar 2023 21:07:22 -0700 Shannon Nelson wrote:
> > Don't put core devlink functionality in a separate file.
> > You're not wrapping all pci_* calls in your own wrappers, why are you
> > wrapping delvink? And use explicit locking, please. devl_* APIs.  
> 
> Wrapping the devlink_register gives me the ability to abstract out the 
> bit of additional logic that gets added in a later patch, and now the 
> locking logic you mention, and is much like how other relatively current 
> drivers have done it, such as in ionic, ice, and mlx5.

What are you "abstracting away", exactly? Which "later patch"?
I'm not going to read the 5k LoC submission to figure out what 
you're trying to say :(
