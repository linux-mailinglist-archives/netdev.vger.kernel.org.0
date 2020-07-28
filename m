Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F598231365
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgG1UBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgG1UBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:01:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE0FC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 13:01:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBE09128A4D7B;
        Tue, 28 Jul 2020 12:44:27 -0700 (PDT)
Date:   Tue, 28 Jul 2020 13:01:11 -0700 (PDT)
Message-Id: <20200728.130111.2163106097158516623.davem@davemloft.net>
To:     hch@lst.de
Cc:     jengelh@inai.de, idosch@idosch.org, Jason@zx2c4.com,
        David.Laight@ACULAB.COM, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net: improve the user pointer check in
 init_user_sockptr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728063643.396100-5-hch@lst.de>
References: <20200728063643.396100-1-hch@lst.de>
        <20200728063643.396100-5-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 12:44:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Tue, 28 Jul 2020 08:36:43 +0200

>  	if (get_user(len, optlen))
>  		return -EFAULT;
        ^^^^^^^^^^^^^^^^^^^^^^^^^^
> -	err = init_user_sockptr(&optval, user_optval);
> +	err = init_user_sockptr(&optval, user_optval, *optlen);
                                                      ^^^^^^^^

Hmmm?
