Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8665668B0E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 06:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjAMFFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 00:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjAMFFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 00:05:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF265BA02
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 21:05:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34CD4B8203D
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DB8C433EF;
        Fri, 13 Jan 2023 05:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673586336;
        bh=tUEg8wlEyYgwKOzoOk3H77HlBlwVcQupar7/f0NT22w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bdWBRbiWdyGiNttIX4MpuNAFy3+lmVhiebeKRcdZCWGwwwpbiDK7kzS7hRxHwcvBs
         hI72OYBgNpueJpxrJ8Hh9ljijakOVKf1PqJEHzo2q0nAeiYslomQh+Mgrxd5y3Ny+y
         a0YKJjbRp5fJiCl0CPdZ6G6QeIXA9dClTXfJxoG0vt9CgVe/MoPlJzxSLTvJ+6Q1cK
         YhM6Iy16Euz2AEWJ327hIiE60vMKprN4D1E46HYdpAZdn9i8fAqG0Yx7Gv2agbdeFU
         rxGkG5RPQzr7lBpZyJZX40iSZBqxVdocQVQIX/BBNa57O2r8xfzt6h/LjJf/nay3zJ
         WHjLb201nPEbw==
Date:   Thu, 12 Jan 2023 21:05:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: Re: [PATCH v2 net-next,8/8] octeontx2-af: add mbox to return
 CPT_AF_FLT_INT info
Message-ID: <20230112210535.0933e422@kernel.org>
In-Reply-To: <20230112044147.931159-9-schalla@marvell.com>
References: <20230112044147.931159-1-schalla@marvell.com>
        <20230112044147.931159-9-schalla@marvell.com>
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

On Thu, 12 Jan 2023 10:11:47 +0530 Srujana Challa wrote:
> Adds a new mailbox to return CPT faulted engines bitmap
> and recovered engines bitmap.

The commit message needs to describe why the change is needed and how
it will be used.
