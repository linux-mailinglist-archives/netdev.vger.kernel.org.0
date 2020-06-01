Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6031EB1E1
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgFAWui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgFAWui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:50:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478FEC05BD43
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 15:50:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03A1511F5F667;
        Mon,  1 Jun 2020 15:50:37 -0700 (PDT)
Date:   Mon, 01 Jun 2020 15:50:37 -0700 (PDT)
Message-Id: <20200601.155037.1847715618466234423.davem@davemloft.net>
To:     ayush.sawal@chelsio.com
Cc:     herbert@gondor.apana.org.au, manojmalviya@chelsio.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next V2 0/2] Fixing compilation warnings and errors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200601174159.9900-1-ayush.sawal@chelsio.com>
References: <20200601174159.9900-1-ayush.sawal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 15:50:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>
Date: Mon,  1 Jun 2020 23:11:57 +0530

> Patch 1: Fixes the warnings seen when compiling using sparse tool.
> 
> Patch 2: Fixes a cocci check error introduced after commit
> 567be3a5d227 ("crypto: chelsio -
> Use multiple txq/rxq per tfm to process the requests").
> 
> V1->V2
> 
> patch1: Avoid type casting by using get_unaligned_be32() and
>     	put_unaligned_be16/32() functions.
> 
> patch2: Modified subject of the patch.

Series applied.
