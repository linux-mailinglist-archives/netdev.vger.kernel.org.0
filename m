Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 240E6102939
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfKSQWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:22:31 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42948 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbfKSQWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:22:31 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iX6Gk-00070c-D1; Tue, 19 Nov 2019 17:22:22 +0100
Date:   Tue, 19 Nov 2019 17:22:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Byron Stanoszek <gandalf@winds.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel 5.4 regression - memory leak in network layer
Message-ID: <20191119162222.GA20235@breakpoint.cc>
References: <alpine.LNX.2.21.1.1911191047410.30058@winds.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.21.1.1911191047410.30058@winds.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Byron Stanoszek <gandalf@winds.org> wrote:
> unreferenced object 0xffff88821a48a180 (size 64):
>   comm "softirq", pid 0, jiffies 4294709480 (age 192.558s)
>   hex dump (first 32 bytes):
>     01 00 00 00 01 06 ff ff 00 00 00 00 00 00 00 00  ................
>     00 20 72 3d 82 88 ff ff 00 00 00 00 00 00 00 00  . r=............
>   backtrace:
>     [<00000000edf73c5e>] skb_ext_add+0xc0/0xf0
>     [<00000000ca960770>] br_nf_pre_routing+0x171/0x489
>     [<0000000063a55d83>] br_handle_frame+0x171/0x300

Brnf related, I will have a look.
