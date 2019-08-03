Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6D580372
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 02:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390591AbfHCAY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 20:24:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390047AbfHCAY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 20:24:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F5351264E2AF;
        Fri,  2 Aug 2019 17:24:56 -0700 (PDT)
Date:   Fri, 02 Aug 2019 17:24:53 -0700 (PDT)
Message-Id: <20190802.172453.1075167824005057182.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, borisp@mellanox.com, aviadye@mellanox.com,
        davejwatson@fb.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        willemb@google.com, xiyou.wangcong@gmail.com, fw@strlen.de,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net-next] net/tls: prevent skb_orphan() from leaking
 TLS plain text with offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730211258.13748-1-jakub.kicinski@netronome.com>
References: <20190730211258.13748-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Aug 2019 17:24:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 30 Jul 2019 14:12:58 -0700

> I'm sending this for net-next because of lack of confidence
> in my own abilities. It should apply cleanly to net... :)

It looks like there will be changes to this.
