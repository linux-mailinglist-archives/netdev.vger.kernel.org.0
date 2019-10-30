Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D23EA136
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfJ3P7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:59:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:42806 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728231AbfJ3P4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:56:48 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iPqL0-0006SA-Kv; Wed, 30 Oct 2019 16:56:46 +0100
Date:   Wed, 30 Oct 2019 16:56:46 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Shmulik Ladkani <shmulik@metanetworks.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH bpf-next 0/2] test_bpf: Add an skb_segment test for a
 linear head_frag=0 skb whose gso_size was mangled
Message-ID: <20191030155646.GC5669@pc-66.home>
References: <20191025134223.2761-1-shmulik.ladkani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025134223.2761-1-shmulik.ladkani@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25618/Wed Oct 30 09:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 04:42:21PM +0300, Shmulik Ladkani wrote:
> Add a reproducer test that mimics the input skbs that lead to the BUG_ON
> in skb_segment() which was fixed by commit 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list").
> 
> Shmulik Ladkani (2):
>   test_bpf: Refactor test_skb_segment() to allow testing skb_segment()
>     on numerous different skbs
>   test_bpf: Introduce 'gso_linear_no_head_frag' skb_segment test
> 
>  lib/test_bpf.c | 112 +++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 103 insertions(+), 9 deletions(-)

Applied, thanks!
