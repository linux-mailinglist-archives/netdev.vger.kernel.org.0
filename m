Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC3B40C323
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 11:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbhIOJ6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 05:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbhIOJ6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 05:58:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64897C061574;
        Wed, 15 Sep 2021 02:56:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mQRes-0004Xc-T7; Wed, 15 Sep 2021 11:56:50 +0200
Date:   Wed, 15 Sep 2021 11:56:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     youling257 <youling257@gmail.com>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/10] netfilter: x_tables: never register
 tables by default
Message-ID: <20210915095650.GG25110@breakpoint.cc>
References: <20210811084908.14744-10-pablo@netfilter.org>
 <20210915095116.14686-1-youling257@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915095116.14686-1-youling257@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

youling257 <youling257@gmail.com> wrote:
> This patch cause kernel panic on my userspace, my userspace is androidx86 7.

You need to provide kernel panic backtrace or reproducer, else I can't do anything
about this.
