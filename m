Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEED6F5A4E
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732977AbfKHVl4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 16:41:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38800 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732101AbfKHVly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:41:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6394153B3140;
        Fri,  8 Nov 2019 13:41:53 -0800 (PST)
Date:   Fri, 08 Nov 2019 13:41:53 -0800 (PST)
Message-Id: <20191108.134153.1710494153341797450.davem@davemloft.net>
To:     toke@redhat.com
Cc:     daniel@iogearbox.net, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 2/6] selftests/bpf: Add tests for automatic
 map unpinning on load failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <157324878734.910124.13947548477668878554.stgit@toke.dk>
References: <157324878503.910124.12936814523952521484.stgit@toke.dk>
        <157324878734.910124.13947548477668878554.stgit@toke.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 13:41:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Fri, 08 Nov 2019 22:33:07 +0100

> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> This add tests for the different variations of automatic map unpinning on
> load failure.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
