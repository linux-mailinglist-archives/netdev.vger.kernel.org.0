Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C042E624D59
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiKJV5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKJV5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:57:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F365E1E3FC
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 13:57:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFBFBB823BA
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2D7C433B5;
        Thu, 10 Nov 2022 21:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668117426;
        bh=hfR33wqSBHXytv43bb9U44F8nLSoVKbm5qiB30kQ5a0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rtm3qcW9cTWjU7xxSPvxQh4vP+1l3Bt1scwFRGlMk0IMO9K1BmcH9czmcOW4uIEvh
         yUnUDp5nAgn9l5Q41AcRWsFGxGacSWO398jSBz+y9P7X4YyjA6mrz+v6zYVf1jLaSe
         IZmA+KaOqIpRoVkWFUverv3fJl+loX76qtB3nIrJz3zI/xOfnusVpkoUOE4DSLCy2S
         pkT1obZHC8yE6biXUql8rdCzDRoMuZd4aijW3UJD3XqWUHMh0rfJFT7lZeHGbaP35O
         0ppSJ2Mhd3RF8LEMTboxx1RHctVyrL820Ct4kEN9NuQtWpIHBbUv6pfvkbQe+eyuUF
         k8EtvGijXZeaw==
Date:   Thu, 10 Nov 2022 13:57:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Kupper <thomas.kupper@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/1] amd-xgbe: fix active cable determination
Message-ID: <20221110135705.684af895@kernel.org>
In-Reply-To: <8c3c6939-ec3d-012d-f686-ddcf5812c21b@gmail.com>
References: <8c3c6939-ec3d-012d-f686-ddcf5812c21b@gmail.com>
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

On Thu, 10 Nov 2022 22:03:32 +0100 Thomas Kupper wrote:
> When determine the type of SFP, active cables were not handled.
> 
> Add the check for active cables as an extension to the passive cable
> check.

Is this patch on top of net or net-next or... ? Reportedly it does not
apply to net. Could you rebase, add a Fixes tag and repost CCing Tom
and Raju?
