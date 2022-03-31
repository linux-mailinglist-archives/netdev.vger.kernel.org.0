Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7BF4EDDB8
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiCaPsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239982AbiCaPst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:48:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63D93A9;
        Thu, 31 Mar 2022 08:47:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F8CD609E9;
        Thu, 31 Mar 2022 15:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79637C340ED;
        Thu, 31 Mar 2022 15:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648741620;
        bh=cEGVTkftOWacxOkSFXlwf1myFdjc75yANlPjREI+RQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KhFEUO23zJ0ThCl0EXFROOmhXFFcWupvOGRTwmOvqyFps15MWSb0+yMNhXQorftm6
         /abVRnNgc3XjiaOwrfU3a3WGmbYzU95Jcrua8x5HOaVFHGIbDyxwIpTV4Ib7PVlcH1
         +PK9cGvTuLWlXep176fdQoRMQjvttKogqYYgSXSykzU6lZuwvc4jRtzLWZmu4xRjJP
         RmbHSLv/13myKqPCN03Xc9Do90Aus1c5NUdmYtSx5amV0yyWQUWbFYReNcfy3yx3nO
         z/PDPi5/i4Bji7ZUAKqbBP+sjWYb5ibYNLvxCesa3UXEKF0ESZhL0DeIrVeBj/mFAl
         8JOsAqoQyUdLA==
Date:   Thu, 31 Mar 2022 08:46:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qing Wang <wangqing@vivo.com>
Cc:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: remove duplicate assignment
Message-ID: <20220331084659.58ba1843@kernel.org>
In-Reply-To: <1648728494-37344-1-git-send-email-wangqing@vivo.com>
References: <1648728494-37344-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 05:08:14 -0700 Qing Wang wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> netdev_alloc_skb() has assigned ssi->netdev to skb->dev if successed,
> no need to repeat assignment.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.18
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.18-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
