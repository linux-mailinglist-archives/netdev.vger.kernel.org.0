Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598B847E73C
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 18:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbhLWRtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 12:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhLWRtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 12:49:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB84DC061401;
        Thu, 23 Dec 2021 09:49:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 537F4B81CB9;
        Thu, 23 Dec 2021 17:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA93EC36AE9;
        Thu, 23 Dec 2021 17:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640281790;
        bh=vQOgNDYHuRpA4JUbEbJjbkeRgnP1IV3+OfJbHLgTWGI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PMvS8XzwAVFKxZJrRlNDFZnnVCU5i8ePrGJbY1W9+Etvf62U99gIRvL8geDi+rcQL
         ki6y3BFr6bY13nYUmcONRNaH+izL4c6m4cXibnvPBRwrory4E84t4ePOp/J8rhBMy8
         V2tUYCohQHuAvcGDZawL3vleXIFEQplq8X70Cv2CCjmV0mWDEngsM0OTmA830q9CvH
         pgDE2yacyiYgyXghCI6CNSYsp8xi5/moOr4GyXs00Q1Cyyf2CCqi/Zogfk1Ajc8cOR
         FJDIumv9VX6BDsJxEZK7Z1lImEYUHxmS8zMWEcfBsm2gy8W2Je+B1khYu3lLL9QrX5
         fF7ESbstAUnXQ==
Date:   Thu, 23 Dec 2021 09:49:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <wangjie125@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next 0/2] net: hns3: add support for TX push
Message-ID: <20211223094948.7d65a29d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211223123013.29367-1-huangguangbin2@huawei.com>
References: <20211223123013.29367-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Dec 2021 20:30:11 +0800 Guangbin Huang wrote:
> From: Yufeng Mo <moyufeng@huawei.com>
> 
> This series adds TX push support for the HNS3 ethernet driver.
> And it relies on "asm-generic: introduce io_stop_wc() and add
> implementation for ARM64"[1], which has not been merged into
> the net-next branch yet.
> 
> [1]https://git.kernel.org/arm64/c/d5624bb29f49

We can merge these as it would break the build. I think you'll need to
wait until mid-January at which point 5.17-rc1 would have been cut and
all tress would have converged.
