Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094A22D5429
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 07:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387605AbgLJGsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 01:48:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730804AbgLJGsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 01:48:45 -0500
Message-ID: <f4eb614ac91ee7623d13ea77ff3c005f678c512b.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607582884;
        bh=my0rlQcv51uQPgNCjUXFo6a0t5kmq4Kc9hlsxMHJ0wo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u38nN20XsesfxiDtl6jLwK0cNVvLax2qdf36gAOYDzVMhJlbAidnOSEjX9WkZ7h2C
         nMcwNISCwxDMDubqk5mnQetYKw1rKl2ISpXa8pEfNCt7UlqJDGRbi9PBrnqlZWw0DD
         9uLtSkvhARo9yU2iycxnp+FvOh4DKZpF+jaB8jl5Hvxfaa3l2aYDyd89RxEFhdDv44
         8taBZZcO5u0P7WIjeukOFx2qk9k96oLw3x5sIguSGdXMH4NdXVOpckLBEWa+r1tac2
         l0zFxTVqn+L46SCWUWk3mgD2wX8xz8IseSNjZWNOPCneKgvRd3BC1A/McDB96ac4Z4
         vOTC2n7298Pjw==
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Date:   Wed, 09 Dec 2020 22:48:01 -0800
In-Reply-To: <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
         <20201204102901.109709-2-marekx.majtyka@intel.com> <878sad933c.fsf@toke.dk>
         <20201204124618.GA23696@ranger.igk.intel.com>
         <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
         <20201207135433.41172202@carbon>
         <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
         <20201207230755.GB27205@ranger.igk.intel.com>
         <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
         <20201209095454.GA36812@ranger.igk.intel.com>
         <20201209125223.49096d50@carbon>
         <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com>
         <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
         <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-09 at 20:34 -0700, David Ahern wrote:
> On 12/9/20 10:15 AM, Saeed Mahameed wrote:
> > > My personal experience with this one is mlx5/ConnectX4-LX with a
> > > limit
> > 
> > This limit was removed from mlx5
> > https://patchwork.ozlabs.org/project/netdev/patch/20200107191335.12272-5-saeedm@mellanox.com/
> > Note: you still need to use ehttool to increase from 64 to 128 or
> > 96 in
> > your case.
> > 
> 
> I asked you about that commit back in May:
> 

:/, sorry i missed this email, must have been the mlnx nvidia email
transition.

> https://lore.kernel.org/netdev/198081c2-cb0d-e1d5-901c-446b63c36706@gmail.com/
> 
> As noted in the thread, it did not work for me.

Still relevant ? I might need to get you some tools to increase #msix
in Firmware.




