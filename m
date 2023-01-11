Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472B966649D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbjAKULa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239598AbjAKUK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:10:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2C528E;
        Wed, 11 Jan 2023 12:10:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A01861E00;
        Wed, 11 Jan 2023 20:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F925C433D2;
        Wed, 11 Jan 2023 20:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673467853;
        bh=lbWbDcWNv/5XwINtvzpcEaKEhpxedFtZSa176XyNSec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a7V/64ys7rleGBVzl7y60dq39WgoyIUoHXkq3nasxaJEPu0s65AJ7gWKTtfs2Vezi
         S/GvhMkFtdOkZ/oJfrZpr+gLOF0tELnQ6b8kRYLrDrdsE36nbvfmqD0m1v05K3maxM
         s3flhFjBd04ZKIoB2DlFXmKufh4PkR9UnZFk9AuTy3t1fVd2LbAwcvdKZPeGcNhC0W
         RL2j5vJLs5POVlCq3oW5pDRdcpqd1ydEyHSFPB9tcpgCdiRIcuB+qrOYsRZwqJhHFX
         OWGs2xu6eZ8fKfBW+wYoNhvGUFcKk4F6YOjMgDsweQjg1AJ0/f2Tqc6D2/0l44nkZh
         IZsM36Hs6AHKQ==
Date:   Wed, 11 Jan 2023 12:10:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Esina Ekaterina <eesina@astralinux.ru>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v4] net: wan: Add checks for NULL for utdm in 
 undo_uhdlc_init and unmap_si_regs
Message-ID: <20230111121052.54fa65e6@kernel.org>
In-Reply-To: <20230111195533.82519-1-eesina@astralinux.ru>
References: <20230111102848.44863b9c@kernel.org>
        <20230111195533.82519-1-eesina@astralinux.ru>
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

On Wed, 11 Jan 2023 22:55:33 +0300 Esina Ekaterina wrote:
> Signed-off-by: Esina Ekaterina <eesina@astralinux.ru>
>   ---

This --- is still indented.

On top of that please tag the patch for the tree to which networking
maintainers apply fixes (by specifying [PATCH net v5] instead just
[PATCH v5] in the subject).

And add a Fixes tag. If the bug dates all the way back to the start of
the git era add:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

otherwise use the commit which added the buggy code.
