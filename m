Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83DD21A2B12
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgDHV1w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Apr 2020 17:27:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52912 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbgDHV1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 17:27:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12647127D24BE;
        Wed,  8 Apr 2020 14:27:52 -0700 (PDT)
Date:   Wed, 08 Apr 2020 14:27:49 -0700 (PDT)
Message-Id: <20200408.142749.1712309028781080294.davem@davemloft.net>
To:     lesedorucalin01@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: UDP repair mode for retrieving the send queue of
 corked UDP socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200408205954.GA15086@white>
References: <20200408205954.GA15086@white>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Apr 2020 14:27:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leºe Doru Cãlin <lesedorucalin01@gmail.com>
Date: Wed, 8 Apr 2020 23:59:54 +0300

> Hello everyone!
> 
> In this year's edition of GSoC, there is a project idea for CRIU to add support
> for checkpoint/restore of cork-ed UDP sockets. But to add it, the kernel API needs
> to be extended.
> This is what this patch does. It adds UDP "repair mode" for UDP sockets in a similar
> approach to the TCP "repair mode", but only the send queue is necessary to be retrieved.
> So the patch extends the recv and setsockopt syscalls. Using UDP_REPAIR option in
> setsockopt, caller can set the socket in repair mode. If it is setted, the
> recv/recvfrom/recvmsg will receive the write queue and the destination of the data.
> As in the TCP mode, to change the repair mode requires the CAP_NET_ADMIN capability
> and to receive data the caller is obliged to use the MSG_PEEK flag.
> 
> Best regards,
> Lese Doru
> 
> Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>

Why do I feel like I've seen this patch several times before?

