Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9DF1B30EE
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 22:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgDUUGm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 16:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDUUGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 16:06:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD24C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 13:06:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6449D128C6D44;
        Tue, 21 Apr 2020 13:06:40 -0700 (PDT)
Date:   Tue, 21 Apr 2020 13:06:37 -0700 (PDT)
Message-Id: <20200421.130637.1641882866461308403.davem@davemloft.net>
To:     lesedorucalin01@gmail.com
Cc:     pabeni@redhat.com, netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH v4] net: UDP repair mode for retrieving the send queue
 of corked UDP socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200416132242.GA2586@white>
References: <20200416132242.GA2586@white>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Apr 2020 13:06:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leºe Doru Cãlin <lesedorucalin01@gmail.com>
Date: Thu, 16 Apr 2020 16:22:42 +0300

> In this year's edition of GSoC, there is a project idea for CRIU to add 
> support for checkpoint/restore of cork-ed UDP sockets. But to add it, the
> kernel API needs to be extended.
> 
> This is what this patch does. It adds UDP "repair mode" for UDP sockets in 
> a similar approach to the TCP "repair mode", but only the send queue is
> necessary to be retrieved. So the patch extends the recv and setsockopt 
> syscalls. Using UDP_REPAIR option in setsockopt, caller can set the socket
> in repair mode. If it is setted, the recv/recvfrom/recvmsg will receive the
> write queue and the destination of the data. As in the TCP mode, to change 
> the repair mode requires the CAP_NET_ADMIN capability and to receive data 
> the caller is obliged to use the MSG_PEEK flag.
> 
> Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>

I'm not applying this without any reviews.

So if someone cares about this feature they should review this
change.

Thank you.
