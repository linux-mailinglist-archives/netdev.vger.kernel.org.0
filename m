Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F67A308E2D
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhA2UKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhA2UIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 15:08:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC5A961492;
        Fri, 29 Jan 2021 20:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611950845;
        bh=xjP274BccIW6uh1op9N5K90XxapKuRZFHdJzXTpp05M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BkHtlPr5U3ceR65EMWCYM4eu6w1Yvpu+ffX1NNTtxmHW3PrvHaMB+VS34UnzosGkV
         bmJ38ghg7jiPjn/GonZ3HipIrjkq+ETRPUdVv9dNZ2g12ZcORdZiGHBQ+imjjy3xoq
         UXlEB2PnXhu/Zitng7hENeHcRXhPy42jxPgUl2cDKQHmz/pm21nYHz+VUOHzLM87Hu
         s37hfj6oEAKb4KpCsI48L81gdm/AWYxSPKM5XGS47l4gMaGJtzsAGnj3jqgTNnMJ3z
         094jPTcFRS4WmoP3wvb8+tnY/Po/hT/wwxswCls+UhKdYoVsmc54PJQ4kVjK6EfyBT
         jjnsY0tlVL/zw==
Date:   Fri, 29 Jan 2021 12:07:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next V1] net: adjust net_device layout for cacheline
 usage
Message-ID: <20210129120723.1e90ab42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <28a12f2b-3c46-c428-ddc2-de702ef33d3f@gmail.com>
References: <161168277983.410784.12401225493601624417.stgit@firesoul>
        <2836dccc-faa9-3bb6-c4d5-dd60c75b275a@gmail.com>
        <20210129085808.4e023d3f@carbon>
        <20210129114642.139cb7dc@carbon>
        <20210129113555.6d361580@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <28a12f2b-3c46-c428-ddc2-de702ef33d3f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 20:47:41 +0100 Eric Dumazet wrote:
> On 1/29/21 8:35 PM, Jakub Kicinski wrote:
> 
> > kdoc didn't complain, and as you say it's already a mess, plus it's
> > two screen-fulls of scrolling away... 
> > 
> > I think converting to inline kdoc of members would be an improvement,
> > if you want to sign up for that? Otherwise -EDIDNTCARE on my side :)
> >   
> 
> What about removing this kdoc ?
> 
> kdoc for a huge structure is mostly useless...

It's definitely not useful for "us", I'd guess most seasoned developers
will just grep for uses of the field - but maybe it is useful for noobs
trying to have high-level sense of the code? 

Either way is fine by me, we can always preserve meaningful comments
inline without the kdoc decorator.
