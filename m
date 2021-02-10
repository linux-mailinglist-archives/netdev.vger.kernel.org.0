Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F86317084
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhBJTpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232802AbhBJTog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 14:44:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1724764E57;
        Wed, 10 Feb 2021 19:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612986235;
        bh=bgCsZ03i95vQiy2BEuAXPEwY9pbkTTIwDSWELbLF8+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mD8AOnd7KvdMGoiZRGe5t7bN5xPPbvl56S/KLb/lddwh4X/Ce2QusoFqaekEKCfBh
         50sMYmFaEFjrJp52zieFuprG3q8NO5CMW+gT2fSiOFtHkBMPQlnGMh5Txxua5Gl9Gr
         dmAmwFUvU1NPZ2zHi3dsE7LvHr6GA3YypmrCJgNd9F4wAO/dm6An2DOnbg6Ym6rOAi
         AO11mLN/ZVI21LvjkmzZIltq4Co5pPr92n6riDc//0ik/FFTBiOxRRNnx+F+kWkolX
         37LHBKvEdgSKo0wzmXpuACuIO6RrM7blpIJ2dXBOtbM6muHryDTJO6734uZt+qh0gz
         HolCIdENFRz7g==
Date:   Wed, 10 Feb 2021 11:43:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
Message-ID: <20210210114354.0646b575@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ygnhim70go6m.fsf@nvidia.com>
References: <20210206050240.48410-1-saeed@kernel.org>
        <20210206050240.48410-2-saeed@kernel.org>
        <20210206181335.GA2959@horizon.localdomain>
        <ygnhtuqngebi.fsf@nvidia.com>
        <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ygnho8gtgw2l.fsf@nvidia.com>
        <20210209100504.119925c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ygnhlfbxgifc.fsf@nvidia.com>
        <20210209115012.049ee898@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ygnhim70go6m.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 13:25:05 +0200 Vlad Buslov wrote:
> On Tue 09 Feb 2021 at 21:50, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 9 Feb 2021 21:17:11 +0200 Vlad Buslov wrote:  
> >> 4. Decapsulated payload appears on namespaced VF with IP address
> >> 5.5.5.5:
> >> 
> >> $ sudo ip  netns exec ns0 tcpdump -ni enp8s0f0v1 -vvv -c 3  
> >
> > So there are two VFs? Hm, completely missed that. Could you *please*
> > provide an ascii diagram for the entire flow? None of those dumps
> > you're showing gives us the high level picture, and it's quite hard 
> > to follow which enpsfyxz interface is what.  
> 
> Sure. Here it is:

Thanks a lot, that clarifies it!
