Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D09149CEFF
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiAZPzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiAZPzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:55:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86D8C06161C;
        Wed, 26 Jan 2022 07:55:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C6C7B81EFB;
        Wed, 26 Jan 2022 15:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB77AC340E3;
        Wed, 26 Jan 2022 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643212507;
        bh=X5P7SypHxAAfJ47P91nn/OKaN+5VlziSqogExTqXlTg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J54nB+BdimL640xPgpt9D+WXeL1/7axgnjfCVyoLTbv5dw5nCraemz2kTli0+Rxv3
         TfXuNs/KozWx3J4uFI/t3RCu7mXARI195wwzc2/hWILG2348nJAMqsfsPp8GtyloHi
         DvRIRMZ7LT1xhDGKrtvYnpPgOSSQnDOqiy+AjTFE7s/uSr1S8d9GNGL3T6PutoM/MP
         e8nS2LoLCTjayBdDl0/f3pqNnXD4NtbQE3m48oE4R7lvm+RCPYRiWuaqwKyswLK7h9
         COxhLA+bf0Nrghs8qgoLNeITA1BZMbDXgqcsx/pEIJMAaGZNdluC+b951WdTU9NZQQ
         sdQpnB1qVwafA==
Date:   Wed, 26 Jan 2022 07:55:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <wangjie125@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
Subject: Re: [RESEND PATCH net-next 1/2] net: hns3: add support for TX push
 mode
Message-ID: <20220126075506.0d36076b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <83c5ef91-59c0-aa54-b698-9f069a8d8280@huawei.com>
References: <20220125072149.56604-1-huangguangbin2@huawei.com>
        <20220125072149.56604-2-huangguangbin2@huawei.com>
        <20220125195038.6a07b3c4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <83c5ef91-59c0-aa54-b698-9f069a8d8280@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 14:48:30 +0800 huangguangbin (A) wrote:
> On 2022/1/26 11:50, Jakub Kicinski wrote:
> > On Tue, 25 Jan 2022 15:21:48 +0800 Guangbin Huang wrote:  
> >> +	__iowrite64_copy(ring->tqp->mem_base, desc,
> >> +			 (sizeof(struct hns3_desc) * HNS3_MAX_PUSH_BD_NUM) /
> >> +			 HNS3_BYTES_PER_64BIT);  
> > 
> > Doesn't build, missing closing bracket?
> > .
> >   
> Hi Jakub,
> Sorry, I didn't notice that net-next has not been merged patch
> "asm-generic: Add missing brackets for io_stop_wc macro" at
> https://git.kernel.org/arm64/c/440323b6cf5b.
> 
> When that patch can be merged in net-next?

Likely by the end of the week.
