Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F5722DC7E
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 09:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgGZHJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 03:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgGZHI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 03:08:59 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58577C0619D2;
        Sun, 26 Jul 2020 00:08:59 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4BDvDf0Trdz1rrLW;
        Sun, 26 Jul 2020 09:08:46 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4BDvDY4g2Xz1qrDX;
        Sun, 26 Jul 2020 09:08:45 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id M61H8ekLgDni; Sun, 26 Jul 2020 09:08:43 +0200 (CEST)
X-Auth-Info: ObXr7NKuP/ed3aOqUP2DwRSFWg3CkaF7qmUDKZFNiwlgCHly/bMVI0yUZSDe+Kon
Received: from hase.home (ppp-46-244-174-182.dynamic.mnet-online.de [46.244.174.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 26 Jul 2020 09:08:43 +0200 (CEST)
Received: by hase.home (Postfix, from userid 1000)
        id C79E21028BD; Sun, 26 Jul 2020 09:08:42 +0200 (CEST)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, edumazet@google.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: get rid of the address_space override in setsockopt v2
References: <20200723060908.50081-1-hch@lst.de>
        <20200724.154342.1433271593505001306.davem@davemloft.net>
        <20200726070311.GA16687@lst.de>
X-Yow:  -- I can do ANYTHING ... I can even ... SHOPLIFT!!
Date:   Sun, 26 Jul 2020 09:08:42 +0200
In-Reply-To: <20200726070311.GA16687@lst.de> (Christoph Hellwig's message of
        "Sun, 26 Jul 2020 09:03:11 +0200")
Message-ID: <87imea3g91.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jul 26 2020, Christoph Hellwig wrote:

> From 6601732f7a54db5f04efba08f7e9224e5b757112 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Sun, 26 Jul 2020 09:00:09 +0200
> Subject: mISDN: remove a debug printk in data_sock_setsockopt
>
> The %p won't work with the new sockptr_t type.  But in the times of
> ftrace, bpftrace and co these kinds of debug printks are pretty anyway,

I think there is a word missing after pretty.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
