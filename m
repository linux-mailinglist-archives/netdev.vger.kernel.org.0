Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232E17B4EC
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbfG3VWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:22:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbfG3VWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:22:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EBE0614A8CC6D;
        Tue, 30 Jul 2019 14:22:13 -0700 (PDT)
Date:   Tue, 30 Jul 2019 14:22:13 -0700 (PDT)
Message-Id: <20190730.142213.2287309603269635758.davem@davemloft.net>
To:     jonathan.lemon@gmail.com
Cc:     willy@infradead.org, jakub.kicinski@netronome.com,
        kernel-team@fb.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/3 net-next] Finish conversion of skb_frag_t to
 bio_vec
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730144034.444022-1-jonathan.lemon@gmail.com>
References: <20190730144034.444022-1-jonathan.lemon@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 14:22:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>
Date: Tue, 30 Jul 2019 07:40:31 -0700

> The recent conversion of skb_frag_t to bio_vec did not include
> skb_frag's page_offset.  Add accessor functions for this field,
> utilize them, and remove the union, restoring the original structure.
> 
> v2:
>   - rename accessors
>   - follow kdoc conventions

Series applied, thanks Jonathan.
