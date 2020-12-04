Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63032CF0A2
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbgLDPWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730493AbgLDPWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 10:22:05 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C14C061A52
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 07:21:24 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1klCtb-0003NT-RG; Fri, 04 Dec 2020 16:21:19 +0100
Date:   Fri, 4 Dec 2020 16:21:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        pabeni@redhat.com, fw@strlen.de, davem@davemloft.net
Subject: Re: [PATCH] mptcp: print new line in mptcp_seq_show() if mptcp isn't
 in use
Message-ID: <20201204152119.GA31101@breakpoint.cc>
References: <c1d61ab4-7626-7c97-7363-73dbc5fa3629@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1d61ab4-7626-7c97-7363-73dbc5fa3629@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianguo Wu <wujianguo106@163.com> wrote:
> From: Jianguo Wu <wujianguo@chinatelecom.cn>

A brief explanation would have helped.
This is for net tree.

> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>

Fixes: fc518953bc9c8d7d ("mptcp: add and use MIB counter infrastructure")
Acked-by: Florian Westphal <fw@strlen.de>
