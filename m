Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6764D50CAD5
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 15:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbiDWNxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 09:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235847AbiDWNxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 09:53:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB261A824
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 06:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1FEDB808CE
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 13:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC8BC385A5;
        Sat, 23 Apr 2022 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650721809;
        bh=JqB7572Vympe3MogZNjEDP6BOmfupUS/JoXTfEPt5p0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ogoOs1EKIsyYL/tvtQ/DrqT0JkFE/LFiCafH+L3ixmFpRGxvjbURkVbZLmB7JaEoz
         0BYdmc+lghBwCvBnO9ZodWo6DNITX5q1lBWju39z4q4AybKWcG7b4ebR8WFzljwUtU
         Ci0Jq58gLWm61ynQ0czzqVcq5Orz0jFoauAQ2nlB5VUVuJopa9ZmpswjxYiI2rN3LN
         k3EJeVU2DBC/LX47HFxhTF2dJQhx7psQoRCbT27Z78lBiADjN+Y7u1rsh3TGKPmG5e
         zXs6w+R6ZGa2JltTkO8Ds0pyAx4hrM2SaTx4dF7nxvypVJg3tliP9wrETAtjjW3Nqo
         mUY0rC5GC/jSA==
Date:   Sat, 23 Apr 2022 06:50:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     pabeni@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
Subject: Re: [PATCH net-next 03/28] sfc: Copy shared files needed for Siena
Message-ID: <20220423065007.7a103878@kernel.org>
In-Reply-To: <165063946292.27138.5733728538967332821.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
        <165063946292.27138.5733728538967332821.stgit@palantir17.mph.net>
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

On Fri, 22 Apr 2022 15:57:43 +0100 Martin Habets wrote:
> From: Martin Habets <martinh@xilinx.com>
> 
> No changes are done, those will be done with subsequent commits.

This ginormous patch does not make it thru the mail systems.
I'm guessing there is a (perfectly reasonable) 1MB limit somewhere.

I think you can also rework the series and combine the pure rename
patches. Having the renames by header file does not substantially 
help review.

Try to stay under the 15 patch limit.
