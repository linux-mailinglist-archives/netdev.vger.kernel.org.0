Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7088F4CFF1D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242561AbiCGMuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236483AbiCGMuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9954DF69
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 04:49:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C982609FE
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A639C340E9;
        Mon,  7 Mar 2022 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646657356;
        bh=s4nN7OUMy02TrYJ0JAezZqBHKrtOfvU9WQ+yJkb8lDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q9HeHQ42hgLUfrCx6sEbE1ea6tKDC4BpFIwwsdiIeSMEhD9q5GHdC9gzBHdGTgogA
         Z9HJKWswyok4wf7DCykmNPh8s2LAk1UwS99v9bwBCeSv3V3Un45qAagTJzJ0GaHL8c
         /SRQ3x0j5OuiMqm3GDfHIK1C5cK60wmI9dnnfxQETA0pBIp+CfxRMXFaBCZYPquQp4
         7YXRMvWDVDekw9qNY5Cia44cdHWhIYz4h4A6n8fIiti98hjohprevj3uQzNyCOWTVv
         TWIJcBWOHRWPt4KruEfO9tCrFOF2ocUCa6tUZtwxKO7N6mCZmIVE/MpQtYSM2wMzfX
         l8SJUHc9Jtk5w==
Date:   Mon, 7 Mar 2022 14:49:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shangyan Zhou <sy.zhou@hotmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4] rdma: Fix the logic to print unsigned int.
Message-ID: <YiX/SCRS/tx2koQs@unreal>
References: <OSAPR01MB7567AF3E28F7D2D72FFA876BE3059@OSAPR01MB7567.jpnprd01.prod.outlook.com>
 <OSAPR01MB75671B497B8A1A66AC2BE743E3079@OSAPR01MB7567.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB75671B497B8A1A66AC2BE743E3079@OSAPR01MB7567.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 02:56:06PM +0800, Shangyan Zhou wrote:
> Use the corresponding function and fmt string to print unsigned int32
> and int64.
> 
> Signed-off-by: Shangyan Zhou <sy.zhou@hotmail.com>
> ---
>  rdma/res-cmid.c |  6 +++---
>  rdma/res-cq.c   | 10 +++++-----
>  rdma/res-ctx.c  |  4 ++--
>  rdma/res-mr.c   |  8 ++++----
>  rdma/res-pd.c   |  8 ++++----
>  rdma/res-qp.c   |  8 ++++----
>  rdma/res-srq.c  |  8 ++++----
>  rdma/res.c      | 15 ++++++++++++---
>  rdma/res.h      |  4 +++-
>  rdma/stat-mr.c  |  2 +-
>  rdma/stat.c     |  4 ++--
>  11 files changed, 44 insertions(+), 33 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
