Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680EC2F4037
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388095AbhALXTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 18:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730671AbhALXTY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 18:19:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D44C523123;
        Tue, 12 Jan 2021 23:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610493523;
        bh=p4DckI6ojqTBJjsLgAhtVdszW1hMcOFjGhIjlUEUegY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Vf3nPc5inL5kKxJl15NhQNKtpBswixRYf21hWTGTZZvsUn1FEzO/FWkmqHgUwj5kP
         gDxpqWGWuB/lYHDe9SExxh7S8WX/dOPDFmQOdyP9nFF/NV9RJTsCZpuh8p8hM1VDxc
         PnU4rbZMv0ti+FTz6tBuoclM9Xmyb3imReA6GvtG+At4hsDph0deWCv0NtGmfVl2xN
         4+1F0kBEBeZ6A1+e6oNcwh/NUf0C/Z078eZFSJ1J1Wu6a1gNMAS9OAHYkV8OWg2aCN
         wIqnXYp4AbBj3dh34IWcmlsBHqM4AWjq5Hmi6JJPJORgXZAXpgMgkYYBA64E+LbhD5
         4MFvuHw2ounPA==
Message-ID: <b2f089b5ac625f8bce15e322534d4d405384c4f2.camel@kernel.org>
Subject: Re: [PATCv4 net-next] octeontx2-pf: Add RSS multi group support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org
Date:   Tue, 12 Jan 2021 15:18:41 -0800
In-Reply-To: <5f140376c36bbe47edeb8784ada3b74fafe05afe.camel@kernel.org>
References: <20210104072039.27297-1-gakula@marvell.com>
         <5f140376c36bbe47edeb8784ada3b74fafe05afe.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-12 at 15:16 -0800, Saeed Mahameed wrote:
> On Mon, 2021-01-04 at 12:50 +0530, Geetha sowjanya wrote:
> > Hardware supports 8 RSS groups per interface. Currently we are
> > using
> > only group '0'. This patch allows user to create new RSS
> > groups/contexts
> > and use the same as destination for flow steering rules.
> > 
> > usage:
> > To steer the traffic to RQ 2,3
> > 
> > ethtool -X eth0 weight 0 0 1 1 context new
> > (It will print the allocated context id number)
> > New RSS context is 1
> > 
> > ethtool -N eth0 flow-type tcp4 dst-port 80 context 1 loc 1
> > 
> > To delete the context
> > ethtool -X eth0 context 1 delete
> > 
> > When an RSS context is removed, the active classification
> > rules using this context are also removed.
> > 
> > Change-log:
> > 
> > v4
> > - Fixed compiletime warning.
> > - Address Saeed's comments on v3.
> > 
> 
> This patch is marked as accepted in patchwork
> https://patchwork.kernel.org/project/netdevbpf/patch/20210104072039.27297-1-gakula@marvell.com/
> 
> but it is not actually applied, maybe resend..
> 
> 
> you can add:
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> 

I missed Jakub's comment, The patch is already applied, i looked at the
wrong tree.

Thanks.

