Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E694BC558
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 05:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiBSEaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 23:30:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiBSEaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 23:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D674F447
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 20:29:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D2E060A50
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 04:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C657C004E1;
        Sat, 19 Feb 2022 04:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645244998;
        bh=5Cs7WPRaEnptn7ZY/Nun8EG2ht/uOjZIJuVy/uef7oo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fhQufm2+apF1r4+ettZv5vC8rRAiE4q0rFTptS2F4lSfr840b7+ykBTMLKGLPob26
         zls1+6sTJwAEC2hl+1epMYUMA1feeJXItfUk3CfXeZuoMUrkXcqIZrTOE/Pi/XfJiG
         Diuy22YRt4r3MsdDdkf1+7SoOpqpDzoQL7zCfOYL8Ny8u4m7Bd5NvnuAasPocoBTnn
         2Pu7yiF67r/AbpvH5Kkpz7Zef8vB8LwCFTNXo8so5vwTyiHFJ7rrvayaflhmb18WQP
         H2TbJ4IT2SSJwfnvsFzl5eujne+pnG4TE/W30gIy3jvK4qk6G7Ld2a44HfhRgwFM0m
         Z4bqXVUJO2w8g==
Date:   Fri, 18 Feb 2022 20:29:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: Re: [net-next PATCH 0/2] Add ethtool support for completion event
 size
Message-ID: <20220218202957.31f5e572@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZuqP15pP8Mgi=Q2BfMZuaG04uPYPKwCGAE1cJtJP0SVPYg@mail.gmail.com>
References: <1645109346-27600-1-git-send-email-sbhatta@marvell.com>
        <20220217090110.48bcad89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZuqP15pP8Mgi=Q2BfMZuaG04uPYPKwCGAE1cJtJP0SVPYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 11:07:11 +0530 sundeep subbaraya wrote:
> > Does changing the CQE size also change the size of the completion ring?
> > Or does it only control aggregation / writeback size?  
> 
> In our case we change the completion ring size too.

Okay, sounds good. Let's make sure the behavior is documented.

