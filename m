Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617FD410FFE
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 09:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhITHYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 03:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhITHYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 03:24:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E16C061574;
        Mon, 20 Sep 2021 00:22:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mSDdM-0005la-RP; Mon, 20 Sep 2021 09:22:36 +0200
Date:   Mon, 20 Sep 2021 09:22:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH net v5 1/2] net: netfilter: Limit the number of ftp
 helper port attempts
Message-ID: <20210920072236.GH15906@breakpoint.cc>
References: <20210920005905.9583-1-Cole.Dishington@alliedtelesis.co.nz>
 <20210920005905.9583-2-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920005905.9583-2-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> In preparation of fixing the port selection of ftp helper when using
> NF_NAT_RANGE_PROTO_SPECIFIED, limit the number of ftp helper port
> attempts to 128.
> 
> Looping a large port range takes too long. Instead select a random
> offset within [ntohs(exp->saved_proto.tcp.port), 65535] and try 128
> ports.

LGTM, please fix the format argument error the kbuild robot reported
and resend.  You may add

Acked-by: Florian Westphal <fw@strlen.de>

when doing so.
