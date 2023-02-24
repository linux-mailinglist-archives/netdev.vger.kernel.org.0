Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABC16A1526
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 04:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjBXDDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 22:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBXDDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 22:03:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25988A4B;
        Thu, 23 Feb 2023 19:03:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 662B3B81A53;
        Fri, 24 Feb 2023 03:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBE0C433EF;
        Fri, 24 Feb 2023 03:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677207784;
        bh=nJk183oZJwTlZUGeg+/8SvbDtB87n3GYLJJ3zBy7xls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cuEgDSyMiNIx/xrZ3BFOy+x81vTz0QorBIXyU9jfNFTOfjqs3QA90Fl86osvKieZg
         NtAPQxCW+F8vj/U7dlWzTmBUmhot0Jhhzd6ClAfGYU/O7fjnE0oYlXB5pzzTXknoFd
         UPLR8Soxu5lwUoFULvCYETHGwdn5WALPLU5vi+fb96o8RVJ/Fte0w4fkOS3a8m+rr4
         fzdF64DkcY29UEcRdX/PR9pMTIgfzHaoU7727sMxb0ySp36z0T0Txjiyrt2FDj2CLM
         tkSVEPkJ5DZQ8wg8LTjzZpAcjCBx4khXV/kafYo6cG9I7sgHVAfMLeK2ADsaXjWhJY
         TL4oToMBsHG+A==
Date:   Thu, 23 Feb 2023 19:03:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Deepak R Varma <drv@mailo.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>
Subject: Re: [PATCH v3] octeontx2-pf: Use correct struct reference in test
 condition
Message-ID: <20230223190302.2ec6fd5b@kernel.org>
In-Reply-To: <Y/YYkKddeHOt80cO@ubun2204.myguest.virtualbox.org>
References: <Y/YYkKddeHOt80cO@ubun2204.myguest.virtualbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Feb 2023 18:58:48 +0530 Deepak R Varma wrote:
> Fix the typo/copy-paste error by replacing struct variable ah_esp_mask name
> by ah_esp_hdr.
> Issue identified using doublebitand.cocci Coccinelle semantic patch.
> 
> Fixes: b7cf966126eb ("octeontx2-pf: Add flow classification using IP next level protocol")
> Link: https://lore.kernel.org/all/20210111112537.3277-1-naveenm@marvell.com/
> Signed-off-by: Deepak R Varma <drv@mailo.com>

Applied, thanks!
