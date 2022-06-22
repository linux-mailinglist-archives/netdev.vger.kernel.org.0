Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240F2554203
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356400AbiFVFJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347664AbiFVFJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:09:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D1035879
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6C3361977
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB421C34114;
        Wed, 22 Jun 2022 05:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655874597;
        bh=+1in/MPKviwhy0mCQPh86vDrJSdJKiMdmjEoto5/HEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k4a6HWhJtMie+lTcdXHlON6dlPHXHlU75Jc076C0WbPNXgWdjZA9VjFdciFGi7hbQ
         K5Fkh+VawHAM3geaWAHaSKSYKe9v7QzTzIIvbYdgnGC2mZ+8pUUPqw0wCORNmfqSab
         TPK69d2Ua7Q/+3i3zXJJV6CDfMK17Kt+JUCaI2TIh2SXudjqIMjilDgFV6TFjK+LTT
         QD7Xte9eleHkHOViQ1GoE+BkKqoxGcdbqAHLRWAkWoU0qL4Sikq/64hmhskL1qNVKV
         RGDvy9tZ5ROZUqWBZlW8dU7zKh/3FUQtoQBz8V0dj4FBTn69UX0qzdDTGlygscZzqS
         gCj3Q/HLw0Llg==
Date:   Tue, 21 Jun 2022 22:09:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     jonathan.s.cooper@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 8/8] sfc: Separate netdev probe/remove from PCI
 probe/remove
Message-ID: <20220621220955.73e4e1fc@kernel.org>
In-Reply-To: <165573359154.2982.3558513705929382829.stgit@palantir17.mph.net>
References: <165573340676.2982.8456666672406894221.stgit@palantir17.mph.net>
        <165573359154.2982.3558513705929382829.stgit@palantir17.mph.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jun 2022 14:59:51 +0100 Martin Habets wrote:
> From: Jonathan Cooper <jonathan.s.cooper@amd.com>
> 
> The netdev probe will be used when moving from the vDPA to EF100 BAR config.
> The netdev remove will be used when moving from the EF100 to vDPA BAR config.
> 
> In the process, change several log messages to pci_ instead of netif_
> to remove the "(unregistered net_device)" text.

The patches LGTM, but this one needs to get checkpatch'ed. 
Whitespace is off. Sorry for not catching this earlier.
Consider switching from the non-standard Co-authored-by 
to Co-developed-by for extra points.
