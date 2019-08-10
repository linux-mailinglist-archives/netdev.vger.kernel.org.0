Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B168887A4
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 04:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfHJC4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 22:56:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfHJC4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 22:56:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 857B715402FEF;
        Fri,  9 Aug 2019 19:56:02 -0700 (PDT)
Date:   Fri, 09 Aug 2019 19:56:02 -0700 (PDT)
Message-Id: <20190809.195602.1013240319655127797.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, willemb@google.com, davejwatson@fb.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        oss-drivers@netronome.com,
        syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net/tls: swap sk_write_space on close
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190810013623.14707-1-jakub.kicinski@netronome.com>
References: <20190810013623.14707-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 19:56:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri,  9 Aug 2019 18:36:23 -0700

> Now that we swap the original proto and clear the ULP pointer
> on close we have to make sure no callback will try to access
> the freed state. sk_write_space is not part of sk_prot, remember
> to swap it.
> 
> Reported-by: syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com
> Fixes: 95fa145479fb ("bpf: sockmap/tls, close can race with map free")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied, thanks Jakub.
