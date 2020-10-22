Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9164B295604
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 03:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894682AbgJVBVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 21:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894678AbgJVBVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 21:21:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31FF322206;
        Thu, 22 Oct 2020 01:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603329697;
        bh=bAS3MOjbHaeoazFondRxidEN1BF9st4c9oDpan10AFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gCFuJVCOxRMudasgSfFIuvGK2qtKITHR932La4e+QjRgw+ITGGD1ER9Tw54t3rtrT
         jiQhu+rjQywQcmqg/CZfUxjNdavKbL83UNWBv5KVw8uMHwV4j/rCifhx0YoxGLqy8f
         J4HnG/1JnU60XfTMrQXRAdS7Iu7zn4/fpZ3rsS24=
Date:   Wed, 21 Oct 2020 18:21:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: [PATCH net] chelsio/chtls: Utilizing multiple rxq/txq to
 process requests
Message-ID: <20201021182135.219f1fd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1485e31a-e248-9b2c-439d-d3e18661669b@chelsio.com>
References: <20201020194305.12352-1-vinay.yadav@chelsio.com>
        <20201020212644.7b25b036@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1485e31a-e248-9b2c-439d-d3e18661669b@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 10:39:22 +0530 Vinay Kumar Yadav wrote:
> On 10/21/2020 9:56 AM, Jakub Kicinski wrote:
> > On Wed, 21 Oct 2020 01:13:06 +0530 Vinay Kumar Yadav wrote:  
> >> patch adds a logic to utilize multiple queues to process requests.
> >> The queue selection logic uses a round-robin distribution technique
> >> using a counter.  
> > 
> > What's the Fixes tag for this one?
> 
> Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")

On a closer look it doesn't seem like round robin was ever implemented
here. So this doesn't seem like a fix. Unless you can prove otherwise
please repost for net-next when it opens.
