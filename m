Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C69513D56
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352152AbiD1VVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbiD1VVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:21:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55AA888E3
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6690E61F13
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A6AC385AD;
        Thu, 28 Apr 2022 21:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651180663;
        bh=8VOAJWFhL/TEhfeGz6PVd6G76Yp2RzJ9D6isaaVM240=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sHxQdFgeF+27K0qdDR3iP4iup3LmxUxawaroaPPsE8DgzWDuOAbCwK7EPZXgKJul8
         Po2bwPMnjPdHu05bwwLf486FJg/TKWuZlMW7v1MmwdmSJJWxuXWj8PWPIGMktWn+vp
         Ry6Zm6boo9Lz1JrR21l3wDAfJnOB7KU+6cAdFeOssskpttbzgmPnx5w7+0IJm7rMJO
         /BvrdPeROc4I03BDy5GFSaCpEkF7yI3MeUKOD1Zm3dTgsOYCma+VyK7/G1EiSbSHM4
         ZImvM3bMAJpq8QFsHNEOjwzGinM/SsiKziy0uc2zwi1bWMMmc9Jx6fqTPktnbXts+0
         rLqZ+X/QNX8oQ==
Date:   Thu, 28 Apr 2022 14:17:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     pabeni@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next v2 00/13]: Move Siena into a separate
 subdirectory
Message-ID: <20220428141742.24186939@kernel.org>
In-Reply-To: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
References: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 03:30:30 +0100 Martin Habets wrote:
> 	Testing
> 
> Various build tests were done such as allyesconfig, W=1 and sparse.
> The new sfc-siena.ko and sfc.ko modules were tested on a machine with both
> these NICs in them, and several tests were run on both drivers.

Does not build for the build bot, or when I try on my system. 
(Ignore the pw-bot reply, BTW, the patches were never merged.)
