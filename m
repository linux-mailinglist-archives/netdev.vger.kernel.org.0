Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82ECE79B09
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbfG2VZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:25:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39738 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729923AbfG2VZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:25:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A601148EA25A;
        Mon, 29 Jul 2019 14:25:57 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:25:57 -0700 (PDT)
Message-Id: <20190729.142557.315557380973492613.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     jonathan.lemon@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 1/3 net-next] linux: Add skb_frag_t page_offset
 accessors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729142211.43b5ccd8@cakuba.netronome.com>
References: <20190729135043.0d9a9dcb@cakuba.netronome.com>
        <932D725D-62F1-47D6-807A-45F81E66B1C6@gmail.com>
        <20190729142211.43b5ccd8@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 14:25:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 29 Jul 2019 14:22:11 -0700

> There is no need to ponder the connotations of verbs. Please just 
> look at other function names in skbuff.h, especially those which 
> copy fields :)
> 
> static inline void skb_copy_hash(struct sk_buff *to, const struct sk_buff *from)
> static inline void skb_copy_secmark(struct sk_buff *to, const struct sk_buff *from)
> static inline void skb_copy_queue_mapping(struct sk_buff *to, const struct sk_buff *from)
> static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buff *src)

I have to agree :-)
