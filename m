Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A455B688635
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjBBSRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjBBSRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:17:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFBD1CAF5;
        Thu,  2 Feb 2023 10:17:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6684361AFB;
        Thu,  2 Feb 2023 18:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D194C433EF;
        Thu,  2 Feb 2023 18:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675361833;
        bh=5YkmJrXYVkNqt2vA/VvnKqVoH5W4bKpdyc2sw2XOyoU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YdVxYmR9J3ZxhkYSqfPvZHo8R97hPIGMBlxgdaJYrkh5mcPzsDwcdw43VHpVIC76G
         W/qycts1rcehcLxZmtRsp1jeqnbknxE+crHCsA9XJ5dNDBSy2NqFjsVLKJPx32IVfs
         L5+dA6C11PwHTh5h+6wwubv+K+uSZe5qaK/cDqVZCswi9hPQu4S+yGmiQtZntkWscJ
         AbauW0Aq1Q7ydyhlRv0tV5pspdAJUEZCm4zLbN+gJs2bNqb4DCWWHhEGJreM/m1q6S
         EPpjb6vGuRgHd5VNapSBkGk4mo5jZrgJ13Yjpnsf2nv9+UVZQGdYETbGToRYDjOhfn
         S5qUcVzXfd6RQ==
Date:   Thu, 2 Feb 2023 10:17:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 7/7] devlink: Move devlink dev selftest code to
 dev
Message-ID: <20230202101712.15a0169d@kernel.org>
In-Reply-To: <1675349226-284034-8-git-send-email-moshe@nvidia.com>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
        <1675349226-284034-8-git-send-email-moshe@nvidia.com>
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

On Thu, 2 Feb 2023 16:47:06 +0200 Moshe Shemesh wrote:
> Move devlink dev selftest callbacks and related code from leftover.c to
> file dev.c. No functional change in this patch.

selftest I'd put in its own file. We don't want every command which
doesn't have a specific sub-object to end up in dev.c, right?
At least that was my initial thinking. I don't see any dependencies
between the selftest code and the rest of the dev code either.
WDYT?
