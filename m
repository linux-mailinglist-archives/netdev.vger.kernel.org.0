Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEE110EFA1
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfLBS6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:58:09 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40288 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727464AbfLBS6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:58:09 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ibqtc-0007yK-3Z; Mon, 02 Dec 2019 19:58:08 +0100
Date:   Mon, 2 Dec 2019 19:58:08 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Marco Oliverio <marco.oliverio@tanaza.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        fw@strlen.de, rocco.folino@tanaza.com
Subject: Re: [PATCH nf] netfilter: nf_queue: enqueue skbs with NULL dst
Message-ID: <20191202185808.GS795@breakpoint.cc>
References: <20191202185430.31367-1-marco.oliverio@tanaza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202185430.31367-1-marco.oliverio@tanaza.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marco Oliverio <marco.oliverio@tanaza.com> wrote:
> Bridge packets that are forwarded have skb->dst == NULL and get
> dropped by the check introduced by
> b60a77386b1d4868f72f6353d35dabe5fbe981f2 (net: make skb_dst_force
> return true when dst is refcounted).

Acked-by: Florian Westphal <fw@strlen.de>
