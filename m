Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376943718CC
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhECP75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 11:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230462AbhECP74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 11:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE326610C8;
        Mon,  3 May 2021 15:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620057543;
        bh=qXr2Z8va5KyGZllISWznZ+Blkxc64T5mAw47fF5xgCA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l2mvxW4pCyrQfSD26OU5+ioVkId1JtrTE8+K52dceHJhxRo9mDEtbrVXh8IutCBYk
         NQO5giZQrZjmfi7aAyr9TY5vJVc0iOGszenz8JEPaSaAM8Hs3IR0OzWgGFv1s39M+K
         mTyQgtGQUU8ctXZOMvp6JF1KZKCNdFvVkWpkWac9d2RDl7pOSCqMZ2tvcg5jxScybY
         G6iwEpyFyF/Ab92wWL1sMnAwghw/1MRMjBTWvYP3cpIyYFLuFfUudL9NXuTSpxHsxv
         RgUl/qz+oZgjeyQ4bGvxMNSdyEoBKFih4DhJjnvaEuMeIDjJcq3UAuB/Fe1dPguAFd
         9VLcDgJSjMHLQ==
Date:   Mon, 3 May 2021 08:59:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next v2 7/7] netlink: stats: add on --all-groups
 option
Message-ID: <20210503085901.63cc248e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210502213640.lqykslgktlvjpaa5@lion.mk-sys.cz>
References: <20210422154050.3339628-1-kuba@kernel.org>
        <20210422154050.3339628-8-kuba@kernel.org>
        <20210502213640.lqykslgktlvjpaa5@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 May 2021 23:36:40 +0200 Michal Kubecek wrote:
> > Add a switch for querying all statistic groups available
> > in the kernel.
> > 
> > To reject --groups and --all-groups being specified
> > for one request add a concept of "parameter equivalency"  
> 
> I like the idea but the term "equivalency" may be a bit misleading.
> Maybe "alternatives" would express the relation better.

Thanks for the review! I take it you mean to rename the code as well?
Not just the commit message?
