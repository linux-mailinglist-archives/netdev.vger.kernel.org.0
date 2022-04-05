Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBAA4F4356
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359856AbiDEUEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573702AbiDEToo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 15:44:44 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C241B208;
        Tue,  5 Apr 2022 12:42:45 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6A68F1EC0374;
        Tue,  5 Apr 2022 21:42:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1649187760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+jNgULdAOXZHcIwnWjX0HhbktEzQNobbDf4ezYO1g3s=;
        b=goAye7/wfIaVWKWP88HPh6LmR+HDF7GkhhnBszM664QzBrtsf/r2sSDBhRyDw/Ay16MYLd
        Fnwy6Sixtx2ERYjuqPkpNgY4yyD9b3WoyygOVhquvXmipiLfzb27KVE3Bcb0ktLSyzF0bj
        zJUIPPvCFfExKweFPU9khVrFSQ/ldxM=
Date:   Tue, 5 Apr 2022 21:42:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 10/11] IB/mlx5: Fix undefined behavior due to shift
 overflowing the constant
Message-ID: <YkybrjtefUwGhSTQ@zn.tnic>
References: <20220405151517.29753-1-bp@alien8.de>
 <20220405151517.29753-11-bp@alien8.de>
 <YkyK9NfN57ldFuyY@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YkyK9NfN57ldFuyY@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 09:31:16PM +0300, Leon Romanovsky wrote:
> I would like to take this patch to mlx5-next, but it didn't show
> nor in patchworks [1] nor in lore [2].

I'm investigating. I'll resend tomorrow if it hasn't appeared by then.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
