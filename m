Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD773169F
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfEaV3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:29:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfEaV3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:29:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E25861500FF56;
        Fri, 31 May 2019 14:29:36 -0700 (PDT)
Date:   Fri, 31 May 2019 14:29:36 -0700 (PDT)
Message-Id: <20190531.142936.1364854584560958251.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     dsahern@gmail.com, dsahern@kernel.org, netdev@vger.kernel.org,
        idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
References: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
        <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
        <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 14:29:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David, can you add some supplementary information to your cover letter
et al.  which seems to be part of what Alexei is asking for and seems
quite reasonable?

Thanks.
