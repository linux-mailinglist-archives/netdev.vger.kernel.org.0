Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77EB3D5BD1
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhGZN5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhGZN5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:57:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31520C061757;
        Mon, 26 Jul 2021 07:37:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m81jV-0000DC-Sn; Mon, 26 Jul 2021 16:37:29 +0200
Date:   Mon, 26 Jul 2021 16:37:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH 2/3] net: netfilter: Add RFC-7597 Section 5.1 PSID support
Message-ID: <20210726143729.GN9904@breakpoint.cc>
References: <20210722071750.GG9904@breakpoint.cc>
 <20210725232840.30565-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210725232840.30565-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> Adds support for masquerading into a smaller subset of ports -
> defined by the PSID values from RFC-7597 Section 5.1. This is part of
> the support for MAP-E and Lightweight 4over6, which allows multiple
> devices to share an IPv4 address by splitting the L4 port / id into
> ranges.
> 
> Co-developed-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> Co-developed-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
> Signed-off-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
> Signed-off-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
> Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
> ---

Thanks for your patience and addressing all the comments.

Reviewed-by: Florian Westphal <fw@strlen.de>
