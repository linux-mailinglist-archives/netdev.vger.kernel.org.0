Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E561BB58
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbfEMQzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:55:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39996 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbfEMQzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:55:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 178D814E266C8;
        Mon, 13 May 2019 09:55:34 -0700 (PDT)
Date:   Mon, 13 May 2019 09:55:33 -0700 (PDT)
Message-Id: <20190513.095533.1009313701419474775.davem@davemloft.net>
To:     edumazet@google.com
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, bpf@vger.kernel.org,
        syzkaller@googlegroups.com, ppenkov@google.com, sdf@google.com
Subject: Re: [PATCH net] flow_dissector: disable preemption around BPF calls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190513163855.225489-1-edumazet@google.com>
References: <20190513163855.225489-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:55:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 13 May 2019 09:38:55 -0700

> Various things in eBPF really require us to disable preemption
> before running an eBPF program.
> 
> syzbot reported :
. ..
> Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.
