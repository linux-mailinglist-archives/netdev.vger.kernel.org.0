Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B53F6E03C2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDMBgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDMBgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:36:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D1A4234
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 18:36:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DEFF60FCB
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828FFC433D2;
        Thu, 13 Apr 2023 01:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681349761;
        bh=dG7L24gjPyepYKLRLywC2XfMh8q294m8CP/z9r8BzmA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SvJ63/wSB6EI2rvpXpHm6Z667UhCTjrWWTjPu25TVohS9eOKahD8IAuCVh+rGqcqs
         iX9B63qbxnspyyizB3Bovy1MBvjHzQG1cd6HdU6BKEKlnzrnosCjzFr8C/qB9c3Ru1
         TqBJ6gq+Un9jzBFEcGDmIJTa0FARDDbtHROWr2g9955fdHBDitlo+k18JUdz1gfO7+
         Has1MKAKlfklU/havF7XQNnIB+p+hmBcAix+fKeEOnAcWWL6iJykF4fSViRpxuK/1m
         k1lR1rOGRgF6BVTCgf4dGK1jYzo4ZdguQ+PBQImJX+bgKeEFlk5ho4NZEzFTFzoaj4
         wsJJo0iLPQO+A==
Date:   Wed, 12 Apr 2023 18:36:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: Re: [RFC PATCH v2 net-next 1/7] net: move ethtool-related netdev
 state into its own struct
Message-ID: <20230412183600.084dbea9@kernel.org>
In-Reply-To: <7437d841fe416119199104ec334bf07cd285c9b5.1681236653.git.ecree.xilinx@gmail.com>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
        <7437d841fe416119199104ec334bf07cd285c9b5.1681236653.git.ecree.xilinx@gmail.com>
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

On Tue, 11 Apr 2023 19:26:09 +0100 edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> net_dev->ethtool is a pointer to new struct ethtool_netdev_state, which
>  currently contains only the wol_enabled field.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
