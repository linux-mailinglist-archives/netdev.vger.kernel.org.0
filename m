Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F1141DD12
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 17:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245052AbhI3PP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:15:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37588 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244780AbhI3PP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 11:15:26 -0400
Received: from netfilter.org (unknown [37.29.219.236])
        by mail.netfilter.org (Postfix) with ESMTPSA id D8F2F63ED0;
        Thu, 30 Sep 2021 17:12:15 +0200 (CEST)
Date:   Thu, 30 Sep 2021 17:13:37 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, lukas@wunner.de, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <YVXUIUMk0m3L+My+@salvia>
References: <20210928095538.114207-1-pablo@netfilter.org>
 <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
 <YVVk/C6mb8O3QMPJ@salvia>
 <3973254b-9afb-72d5-7bf1-59edfcf39a58@iogearbox.net>
 <YVWBpsC4kvMuMQsc@salvia>
 <20210930072835.791085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210930072835.791085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 07:28:35AM -0700, Jakub Kicinski wrote:
> On Thu, 30 Sep 2021 11:21:42 +0200 Pablo Neira Ayuso wrote:
[...]
> The lifetime of this information is constrained, can't it be a percpu
> flag, like xmit_more?

It's just one single bit in this case after all.

> > Probably the sysctl for this new egress hook is the way to go as you
> > suggest.
> 
> Knobs is making users pay, let's do our best to avoid that.

Could you elaborate?

Thanks.
