Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF1D5F5FA8
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiJFDd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJFDdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:33:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CBA349B4;
        Wed,  5 Oct 2022 20:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51FB26155A;
        Thu,  6 Oct 2022 03:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEA9C433D6;
        Thu,  6 Oct 2022 03:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665027231;
        bh=nUXGmgdB2ZKTAoeJkVxiPb49QsBHrqPiXBxyDm1FkOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h1/i0PYMmVNUzZCb5vAHmmaaEVfNMg6psuj+opVp4A6v09SW5x4N54YQ1ymv5QhM/
         SpJMwLRZoar0vKiMdyi/lj0mExziSGPCxEnZylapjlNyypUpHEpmkYJxETUGuRU+19
         LmeLOtQCBn7rrJ+yg6PSMvR4SU9R1S6zw9xVWhquDyKGWW9X9viH53TTWpjw7pUg+U
         po6xFaXLDABxxKr41NsH8gs5egpriWIFbA6ejpWu+1OBKhVoWrWybkkYF9c5Ptxwv5
         leMKPqrgHRUlidohnHW1p88/7wRqJaaYpDF5P+WJlE5egEmOk8IJleCHGANBc1QgsV
         VUCOnvV5eeE/A==
Date:   Wed, 5 Oct 2022 20:33:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bnx2x: Fix spelling mistake "tupple" -> "tuple"
Message-ID: <20221005203350.5093d954@kernel.org>
In-Reply-To: <20221004163235.157485-1-colin.i.king@gmail.com>
References: <20221004163235.157485-1-colin.i.king@gmail.com>
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

On Tue,  4 Oct 2022 17:32:35 +0100 Colin Ian King wrote:
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c | 10 +++++-----
>  fs/freevxfs/vxfs_olt.c                              |  2 +-

Looks like two unrelated subsystems?

Please repost the netdev bits after the merge window.
