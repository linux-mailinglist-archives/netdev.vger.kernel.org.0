Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D6C19E147
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgDCXGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:06:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgDCXGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 19:06:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6F7D121938E3;
        Fri,  3 Apr 2020 16:06:49 -0700 (PDT)
Date:   Fri, 03 Apr 2020 16:06:49 -0700 (PDT)
Message-Id: <20200403.160649.1243854856424851277.davem@davemloft.net>
To:     geliangtang@gmail.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mptcp: add some missing pr_fmt defines
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f66ab0b7dfcc895d901e6e85b30f2a21842d2b2c.1585904950.git.geliangtang@gmail.com>
References: <34c83a5fe561739c7b85a3c4959eb44c3155d075.1585899578.git.geliangtang@gmail.com>
        <f66ab0b7dfcc895d901e6e85b30f2a21842d2b2c.1585904950.git.geliangtang@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Apr 2020 16:06:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>
Date: Fri,  3 Apr 2020 17:14:08 +0800

> Some of the mptcp logs didn't print out the format string:
> 
> [  185.651493] DSS
> [  185.651494] data_fin=0 dsn64=0 use_map=0 ack64=1 use_ack=1
> [  185.651494] data_ack=13792750332298763796
> [  185.651495] MPTCP: msk=00000000c4b81cfc ssk=000000009743af53 data_avail=0 skb=0000000063dc595d
> [  185.651495] MPTCP: msk=00000000c4b81cfc ssk=000000009743af53 status=0
> [  185.651495] MPTCP: msk ack_seq=9bbc894565aa2f9a subflow ack_seq=9bbc894565aa2f9a
> [  185.651496] MPTCP: msk=00000000c4b81cfc ssk=000000009743af53 data_avail=1 skb=0000000012e809e1
> 
> So this patch added these missing pr_fmt defines. Then we can get the same
> format string "MPTCP" in all mptcp logs like this:
> 
> [  142.795829] MPTCP: DSS
> [  142.795829] MPTCP: data_fin=0 dsn64=0 use_map=0 ack64=1 use_ack=1
> [  142.795829] MPTCP: data_ack=8089704603109242421
> [  142.795830] MPTCP: msk=00000000133a24e0 ssk=000000002e508c64 data_avail=0 skb=00000000d5f230df
> [  142.795830] MPTCP: msk=00000000133a24e0 ssk=000000002e508c64 status=0
> [  142.795831] MPTCP: msk ack_seq=66790290f1199d9b subflow ack_seq=66790290f1199d9b
> [  142.795831] MPTCP: msk=00000000133a24e0 ssk=000000002e508c64 data_avail=1 skb=00000000de5aca2e
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Applied, thanks.
