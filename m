Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD18460C29D
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 06:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJYE3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 00:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiJYE3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 00:29:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E4064FD
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CAE961716
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAAAC43140;
        Tue, 25 Oct 2022 04:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666672183;
        bh=yUmlHjDQGXXwSHkt/nLrLVQX7FlWjMT/JS7WuPxsa9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FaqVwcdAlf5ivUIUuKe14FNop08WO/qvNq1Y5Lc1UmZsP5l9rMgcv+tfiVTxRUi4c
         XN/aytg4LDjVMLtQOjzf5i2Y+te8f+y5YUL3sZHkReOl6ZwyfGbf3xxYJcRWZBJAXc
         YURomccYLJdEO3/Y2lquDJYx4LyBzATfrFEX3mghJwKyUv5Yohm6WwcJzUjbmyMkUx
         xSfpXh0xWwzRtxhEDr9pvsKif2pAE46+5+9L43g2kzxLGYgGkB9pETLmoHzCy5aJ0A
         oxlUp7tTZ7I0qzOsHJl6bo6IGf7fPacjLPm8b/kO38DiBF+YNh4JEVjRey6X1mYcX3
         KrJ42wZ7NPSBQ==
Date:   Mon, 24 Oct 2022 21:29:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Laba, SlawomirX" <slawomirx.laba@intel.com>,
        "Jaron, MichalX" <michalx.jaron@intel.com>,
        "Palczewski, Mateusz" <mateusz.palczewski@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH v2 1/3] i40e: Fix ethtool rx-flow-hash setting for X722
Message-ID: <20221024212942.1c6198ff@kernel.org>
In-Reply-To: <CO1PR11MB50892671BA9380FBA2D9EEB1D62E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221024100526.1874914-1-jacob.e.keller@intel.com>
        <CO1PR11MB50892671BA9380FBA2D9EEB1D62E9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 22:18:41 +0000 Keller, Jacob E wrote:
> Fix one thing, screw up another... I forgot to tag these as [net]..

FWIW no need to repost just for that, looks like i40e is identical 
in both trees.
