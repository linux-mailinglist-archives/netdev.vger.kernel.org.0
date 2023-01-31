Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12C9682879
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjAaJQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbjAaJQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:16:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B374AA71;
        Tue, 31 Jan 2023 01:14:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7BE7B819FF;
        Tue, 31 Jan 2023 09:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163D5C433D2;
        Tue, 31 Jan 2023 09:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675156435;
        bh=ekva0SLj9iCfYLRa863pnI7NwSOpLzthcVYFLGuv9iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YtorveO7MFgs1CzmsJWcSDI8CJlFdgXlEIUXAhAmZUT7n1JrkXRj42eHdvstbph9n
         Fh+o73MyfYAuKhIPFWBFUvwzPyxC0JL76d5j/HSWIxJPDEnjTBp7qVaZFQUJPOKkpZ
         jwW75Z6J41eWtV+GAPQZfKcEaPgZmz66iNXwqSbDeFQOr08gfVy72PLJu5yFcnmFkI
         2o0/x7g6rAY7BwAw5blzjPTv2E47hMuoZKQ6D3Zgmxfr1ICsTUMEclsteguf1ngYqO
         oMxbtjf8RYXfKZ42nVZBsPv9MspdPt2/usSyV2EuG6zdkvKgV1t1T2qwbcnNseVIii
         rsf1YzogZciFw==
Date:   Tue, 31 Jan 2023 11:13:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jiri@resnulli.us, sgoutham@marvell.com
Subject: Re: [net PATCH v2] octeontx2-af: Fix devlink unregister
Message-ID: <Y9jbz3Z70lByrj7x@unreal>
References: <20230131061659.1025137-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131061659.1025137-1-rkannoth@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 11:46:59AM +0530, Ratheesh Kannoth wrote:
> Exact match feature is only available in CN10K-B.
> Unregister exact match devlink entry only for
> this silicon variant.
> 
> Fixes: 87e4ea29b030 ("octeontx2-af: Debugsfs support for exact match.")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> ---
>  .../marvell/octeontx2/af/rvu_devlink.c        | 35 ++++++++++++++-----
>  1 file changed, 27 insertions(+), 8 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
