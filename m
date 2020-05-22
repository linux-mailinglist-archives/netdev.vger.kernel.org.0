Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378971DDC12
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgEVAUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbgEVAUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:20:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1B2C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 17:20:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42760120ED486;
        Thu, 21 May 2020 17:20:48 -0700 (PDT)
Date:   Thu, 21 May 2020 17:20:47 -0700 (PDT)
Message-Id: <20200521.172047.1634733635483479925.davem@davemloft.net>
To:     vfedorenko@novek.ru
Cc:     kuba@kernel.org, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org
Subject: Re: [net v3 0/2] net/tls: fix encryption error path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1589964104-9941-1-git-send-email-vfedorenko@novek.ru>
References: <1589964104-9941-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:20:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>
Date: Wed, 20 May 2020 11:41:42 +0300

> The problem with data stream corruption was found in KTLS
> transmit path with small socket send buffers and large 
> amount of data. bpf_exec_tx_verdict() frees open record
> on any type of error including EAGAIN, ENOMEM and ENOSPC
> while callers are able to recover this transient errors.
> Also wrong error code was returned to user space in that
> case. This patchset fixes the problems.

Series applied, thanks.
