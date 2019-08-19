Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C1D94EC1
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbfHSUQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:16:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbfHSUQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:16:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1AA2014630830;
        Mon, 19 Aug 2019 13:16:23 -0700 (PDT)
Date:   Mon, 19 Aug 2019 13:16:22 -0700 (PDT)
Message-Id: <20190819.131622.1350491807311302676.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190819184911.15263-1-pablo@netfilter.org>
References: <20190819184911.15263-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 13:16:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 19 Aug 2019 20:49:06 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Remove IP MASQUERADING record in MAINTAINERS file,
>    from Denis Efremov.
> 
> 2) Counter arguments are swapped in ebtables, from
>    Todd Seidelmann.
> 
> 3) Missing netlink attribute validation in flow_offload
>    extension.
> 
> 4) Incorrect alignment in xt_nfacct that breaks 32-bits
>    userspace / 64-bits kernels, from Juliana Rodrigueiro.
> 
> 5) Missing include guard in nf_conntrack_h323_types.h,
>    from Masahiro Yamada.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
