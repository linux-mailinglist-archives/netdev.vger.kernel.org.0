Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13334FF555
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbiDMLBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:01:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49990 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiDMLBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:01:34 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id BAF3684090C3;
        Wed, 13 Apr 2022 03:59:12 -0700 (PDT)
Date:   Wed, 13 Apr 2022 11:59:10 +0100 (BST)
Message-Id: <20220413.115910.1259895348912996409.davem@davemloft.net>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] net: add __sys_socket_file()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20220412202240.234207-2-axboe@kernel.dk>
References: <20220412202240.234207-1-axboe@kernel.dk>
        <20220412202240.234207-2-axboe@kernel.dk>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 13 Apr 2022 03:59:13 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 12 Apr 2022 14:22:39 -0600

> This works like __sys_socket(), except instead of allocating and
> returning a socket fd, it just returns the file associated with the
> socket. No fd is installed into the process file table.
> 
> This is similar to do_accept(), and allows io_uring to use this without
> instantiating a file descriptor in the process file table.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Acked-by: David S. Miller <davem@davemloft.net>
