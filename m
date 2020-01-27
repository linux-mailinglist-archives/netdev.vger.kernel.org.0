Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B25114A5E7
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgA0OVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:21:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbgA0OVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 09:21:10 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F4AF206D3;
        Mon, 27 Jan 2020 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580134869;
        bh=9grUDBlpkZBiGDuifFySHYkjodars0QnmiJQVp43ar0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SlgafFLF7owdsL9/XDRgbPoAt3iH+Gt/vSXQ4V/+LqQcmHh5LfBhQXjXO4feAW1eE
         B9XyJY5AaZadAYkZBScfAdYjdw4gbrPXGrPofKPzDjiRAjGlrG4peU1HiEoH0iLQWY
         hWHe/ReefkSRUX775Oh4vMacDLPxRko44m5lKeEE=
Date:   Mon, 27 Jan 2020 06:21:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200127062108.082c9e5e@cakuba>
In-Reply-To: <20200127064534.GJ3870@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
        <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
        <20200126194110.GA3870@unreal>
        <20200126124957.78a31463@cakuba>
        <20200126210850.GB3870@unreal>
        <20200126133353.77f5cb7e@cakuba>
        <2a8d0845-9e6d-30ab-03d9-44817a7c2848@pensando.io>
        <20200127053433.GF3870@unreal>
        <20200127064534.GJ3870@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 08:45:34 +0200, Leon Romanovsky wrote:
> > The thing is that we don't consider in-kernel API as stable one, so
> > addition of new field which is not in use in upstream looks sketchy to
> > me, but I have an idea how to solve it.  
> 
> Actually, it looks like my idea is Jakub's and Michal's idea. I will use
> this opportunity and remove MODULE_VERSION() too.

If you do please make sure DKMS works. I remember it was looking at
that value.
