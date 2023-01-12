Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F19666B64
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 08:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbjALHJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 02:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbjALHJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 02:09:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F921C90D;
        Wed, 11 Jan 2023 23:09:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65B0BB81D79;
        Thu, 12 Jan 2023 07:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107B3C433D2;
        Thu, 12 Jan 2023 07:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673507378;
        bh=Oqydj0oJ7lWgc8KOd0cdULCtOKRcsaepxFT40526GeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZI1IE3CfJnmRKlQxUvFKU4HC2yLudSu10piwKyFxLs2wpnk2yv5JAtH2ZoEsg/r5Y
         nNdZ+MEEoVi2ivlYrIckNxC7b5QAiRZNEi+QVwdCdJAxbZpzPNwahSelwwKmhkH+8m
         CE5IVFBk9cL5JPxxk49qdqaLpQrFj4QxiHPCORdGym/voqAYBMyIEnRor1Q7LpuFcb
         zfrQsB+Esn8uhsuWMuAto+4Ukeu362Nug+cyGC4z06w+M94Q8Tus325z4sXeSrBlQo
         0hb78fq7QCXRebgc81y0w3CWoCfnUB51VGYMkXPSbx9u7PWLihAvGrtiiusrQZpV6+
         Hra6G/rhgXpWA==
Date:   Thu, 12 Jan 2023 09:09:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Esina Ekaterina <eesina@astralinux.ru>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v4] net: wan: Add checks for NULL for utdm in
 undo_uhdlc_init and unmap_si_regs
Message-ID: <Y7+yLgGr1GO/rXun@unreal>
References: <20230111102848.44863b9c@kernel.org>
 <20230111195533.82519-1-eesina@astralinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111195533.82519-1-eesina@astralinux.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 10:55:33PM +0300, Esina Ekaterina wrote:
> If uhdlc_priv_tsa != 1 then utdm is not initialized.
> And if ret != NULL then goto undo_uhdlc_init, where
> utdm is dereferenced. Same if dev == NULL.
> 
> Found by Astra Linux on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Esina Ekaterina <eesina@astralinux.ru>
>   ---
> v4: Fix style
> v3: Remove braces
> v2: Add check for NULL for unmap_si_regs
> ---
>  drivers/net/wan/fsl_ucc_hdlc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

In addition to what Jakub said, please don't send patches as reply-to.
Please sent them as new threads.

Thanks
