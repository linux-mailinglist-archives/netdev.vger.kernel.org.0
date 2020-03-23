Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2197018FE6B
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgCWUFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:05:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51668 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgCWUFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:05:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3840615AD694C;
        Mon, 23 Mar 2020 13:05:08 -0700 (PDT)
Date:   Mon, 23 Mar 2020 13:05:07 -0700 (PDT)
Message-Id: <20200323.130507.986860177541478768.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        kuba@kernel.org, borisp@mellanox.com, secdev@chelsio.com,
        vinay.yadav@chelsio.com
Subject: Re: [PATCH net-next v2] Crypto/chtls: add/delete TLS header in
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319044121.6688-1-rohitm@chelsio.com>
References: <20200319044121.6688-1-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 13:05:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Thu, 19 Mar 2020 10:11:21 +0530

> Kernel TLS forms TLS header in kernel during encryption and removes
> while decryption before giving packet back to user application. The
> similar logic is introduced in chtls code as well.
> 
> v1->v2:
> - tls_proccess_cmsg() uses tls_handle_open_record() which is not required
>   in TOE-TLS. Don't mix TOE with other TLS types.
> 
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Applied, thank you.
