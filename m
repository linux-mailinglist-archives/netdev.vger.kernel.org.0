Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7013C79155
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfG2QqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:46:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728170AbfG2QqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:46:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B1B112665353;
        Mon, 29 Jul 2019 09:46:14 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:46:13 -0700 (PDT)
Message-Id: <20190729.094613.2239689143737241909.davem@davemloft.net>
To:     juliana.rodrigueiro@intra2net.com
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH] isdn: hfcsusb: Fix mISDN driver crash caused by
 transfer buffer on the stack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2635856.so0i2TFZOM@rocinante.m.i2n>
References: <2635856.so0i2TFZOM@rocinante.m.i2n>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 09:46:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Date: Mon, 29 Jul 2019 10:20:56 +0200

> @@ -1705,12 +1705,22 @@ static int
>  setup_hfcsusb(struct hfcsusb *hw)
>  {
>  	u_char b;
> +	int ret;
> +	void *dmabuf = kmalloc(sizeof(u_char), GFP_KERNEL);

Please order these local variable declarations from longest to shortest line.

Thank you.
