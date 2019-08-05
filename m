Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE8E0824C6
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbfHESTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:19:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbfHESTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:19:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3A211540E30F;
        Mon,  5 Aug 2019 11:19:06 -0700 (PDT)
Date:   Mon, 05 Aug 2019 11:19:06 -0700 (PDT)
Message-Id: <20190805.111906.1380210569649795922.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        borkmann@iogearbox.net, brandon.cazander@multapplied.net,
        alexei.starovoitov@gmail.com
Subject: Re: [net v1 PATCH 0/4] net: fix regressions for generic-XDP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156468229108.27559.2443904494495785131.stgit@firesoul>
References: <20190731211211.GA87084@multapplied.net>
        <156468229108.27559.2443904494495785131.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 11:19:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 01 Aug 2019 20:00:11 +0200

> Thanks to Brandon Cazander, who wrote a very detailed bug report that
> even used perf probe's on xdp-newbies mailing list, we discovered that
> generic-XDP contains some regressions when using bpf_xdp_adjust_head().
> 
> First issue were that my selftests script, that use bpf_xdp_adjust_head(),
> by mistake didn't use generic-XDP any-longer. That selftest should have
> caught the real regression introduced in commit 458bf2f224f0 ("net: core:
> support XDP generic on stacked devices.").
> 
> To verify this patchset fix the regressions, you can invoked manually via:
> 
>   cd tools/testing/selftests/bpf/
>   sudo ./test_xdp_vlan_mode_generic.sh
>   sudo ./test_xdp_vlan_mode_native.sh
> 
> Link: https://www.spinics.net/lists/xdp-newbies/msg01231.html
> Fixes: 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
> Reported by: Brandon Cazander <brandon.cazander@multapplied.net>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Series applied and queued up for -stable, thanks.
