Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3C1668B0F
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 06:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjAMFEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 00:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjAMFEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 00:04:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0175B4BD
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 21:04:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57968B8203E
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 05:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76998C433D2;
        Fri, 13 Jan 2023 05:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673586282;
        bh=pLbpvr6ckyZ4c+JrarGOXwbwj6xKzbQQ27ZaO0U6Z2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tHGm622/EIILJ9t/PZMNhEWevYjulLE345WYoyLQ16Y6CKBemETlmut4KqME8zt0G
         IbtXM0uAKP4mrjtNdWkOyFyA080BRbBSAnPzNCNnZ7rkd3/TUAn9HK02+xuH2Qi/qB
         ZJAE9Oqto/CGRHKqrZcNlS+ekrhas7jbzfTS0aEAWzGGWOQazj+niDmnTGRRAhEUP2
         Qsd7cmKPrzEHqtFMkCbPZNhJvPqhn3lE0xyqcmolviTUjm94VgJZhHV4cAipIAP8ls
         D+MewfoUl3qFggNAvKu82IjD9eisWPJoGSni+55dRFR5hhr6vSZqPQTQ+6ILjNDTKk
         NtDwKdhAVimXg==
Date:   Thu, 12 Jan 2023 21:04:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: Re: [PATCH v2 net-next,7/8] octeontx2-af: add ctx ilen to cpt lf
 alloc mailbox
Message-ID: <20230112210440.1d5d90a5@kernel.org>
In-Reply-To: <20230112044147.931159-8-schalla@marvell.com>
References: <20230112044147.931159-1-schalla@marvell.com>
        <20230112044147.931159-8-schalla@marvell.com>
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

On Thu, 12 Jan 2023 10:11:46 +0530 Srujana Challa wrote:
> Subject: [PATCH v2 net-next,7/8] octeontx2-af: add ctx ilen to cpt lf alloc mailbox
 
> Adds ctx_ilen to CPT_LF_ALLOC mailbox to provide
> the provison to user to give CPT_AF_LFX_CTL:ctx_ilen.

Please improve the commit messages. Too many acronyms meaningless to
an upstream reviewer, and even the parts in English look scrambled.
"to provide the provison to user to give" ?
