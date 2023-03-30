Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A646D0D18
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjC3RsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbjC3RsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:48:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47850C678;
        Thu, 30 Mar 2023 10:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D01B86213E;
        Thu, 30 Mar 2023 17:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E031DC433D2;
        Thu, 30 Mar 2023 17:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680198498;
        bh=yi8eHpP6NUAQWBfR10H+scUOTl4s+bsdyGr8rJ8lTl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uuEpr7P5sOVQjwpd0kbkonmjD/YEfi/bsKKCUsWcxY9HmxKIJpsW4WBuSWBEAJC6D
         TFa4CW9T9WMMnPrec2M9SvazsSdmucvxEudWmBzxwV0brQkGeG5XerWwIEhbLsUm0Q
         vm6ldXB2Qe4RxVC3w08Xc60bT0iou+JCmefxmEmOlRQsmRSdaUEFNCPfFFsg4DQkwT
         eOlPphlykFiRHJAIo1S1ylxNZgwb7BKPJoE/sZeeR6x8jroveadOnLyg1/4qXXrPFI
         LeXuRp1aaCt2/83gtHZIHzmnu9tuZGOwrCMsg0JFbWggY1H2K2wS0BtMh5+ewI3X1+
         bANyUUdNNJt3A==
Date:   Thu, 30 Mar 2023 10:48:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <richardcochran@gmail.com>
Subject: Re: [net PATCH 0/7] octeontx2: Miscellaneous fixes
Message-ID: <20230330104816.29d6fc4e@kernel.org>
In-Reply-To: <20230329170619.183064-1-saikrishnag@marvell.com>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 22:36:12 +0530 Sai Krishna wrote:
> From: Sai Krishna <saikrishnag@marvell.com>
> To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,         <pabeni@redhat.com>, <netdev@vger.kernel.org>,         <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,         <richardcochran@gmail.com>
> CC: Sai Krishna <saikrishnag@marvell.com>

First of all, does the maintainers file need to be updated?

This driver has a crazy number of maintainers:

MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER
M:	Sunil Goutham <sgoutham@marvell.com>
M:	Linu Cherian <lcherian@marvell.com>
M:	Geetha sowjanya <gakula@marvell.com>
M:	Jerin Jacob <jerinj@marvell.com>
M:	hariprasad <hkelam@marvell.com>
M:	Subbaraya Sundeep <sbhatta@marvell.com>
L:	netdev@vger.kernel.org
S:	Supported
F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
F:	drivers/net/ethernet/marvell/octeontx2/af/

And yet the person posting patches for the company is not on that list?!
Please clean this up, or CC authors of patches on the fixes.
