Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BB32CCB6F
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 02:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387493AbgLCBJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 20:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbgLCBJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 20:09:56 -0500
Message-ID: <4bc01a8f34dec1b6c991b53984800e939b2ee690.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606957756;
        bh=aPrQJ4KDDLEsKLY6bCKhizfzL/jclgv77yi3IqdUe4E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MWgdaL2W33JwfQtBydtAvteEsGt1VpC/J8KKOHXybKkvXjgax8smLtDCUpHwknOK/
         28/cd99Pxk3TCuSSGhE6VmNQO62b8HnARGwmM0OD0wCP6wIJh1VTXskmHl+hEed/gM
         3pzzF3bkh1mDx9ZH2RRCjRmGCaGe+Abb7uBeJWzOxXya7gMC4Dqk+gra+c5Q/CLRIZ
         L8rzbD8824QuUB7ar+KR+Udu4q80puqid1mcfE/ld53i0HTInpgu3QNjr9uOeVBVV5
         qVqu4nyu1fKBXb55yDHgyPeEjWZcXd0FXs4jPET9zGQOg59usANfBrRcJYYovYDAWI
         QF90nVF3NoVeQ==
Subject: Re: [pull request][net-next] mlx5 next 2020-12-02
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Wed, 02 Dec 2020 17:09:14 -0800
In-Reply-To: <20201202123211.616d8adb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201202201141.194535-1-saeedm@nvidia.com>
         <20201202123211.616d8adb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-02 at 12:32 -0800, Jakub Kicinski wrote:
> On Wed, 2 Dec 2020 12:11:41 -0800 Saeed Mahameed wrote:
> > Hi Jakub,
> > 
> > This pull request includes [1] low level mlx5 updates required by
> > both netdev
> > and rdma trees, needed for upcoming mlx5 netdev submission.
> > 
> > Please pull and let me know if there's any problem.
> > 
> > [1] 
> > https://patchwork.kernel.org/project/linux-rdma/cover/20201120230339.651609-1-saeedm@nvidia.com/
> 
> fatal: couldn't find remote ref mlnx/mlx5-next
> 

My bad, let me use a proper tag, I will send v2.

