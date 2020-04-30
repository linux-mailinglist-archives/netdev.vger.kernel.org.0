Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8641C071A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgD3T47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3T46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:56:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4006CC035495;
        Thu, 30 Apr 2020 12:56:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DE7A1289CE3F;
        Thu, 30 Apr 2020 12:56:55 -0700 (PDT)
Date:   Thu, 30 Apr 2020 12:56:54 -0700 (PDT)
Message-Id: <20200430.125654.335144341485365161.davem@davemloft.net>
To:     mchehab+huawei@kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, devel@driverdev.osuosl.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, kou.ishizaki@toshiba.co.jp,
        netdev@vger.kernel.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, marcelo.leitner@gmail.com,
        kadlec@netfilter.org, johannes@sipsolutions.net, fw@strlen.de,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        benh@kernel.crashing.org, linux-wireless@vger.kernel.org,
        geoff@infradead.org, mpe@ellerman.id.au, linux-can@vger.kernel.org,
        ioana.ciornei@nxp.com, linux-sctp@vger.kernel.org,
        vyasevich@gmail.com, rds-devel@oss.oracle.com,
        ruxandra.radulescu@nxp.com, dhowells@redhat.com,
        pablo@netfilter.org, kvalo@codeaurora.org,
        santosh.shilimkar@oracle.com, socketcan@hartkopp.net,
        nhorman@tuxdriver.com, courmisch@gmail.com,
        linux-rdma@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-x25@vger.kernel.org, mkl@pengutronix.de
Subject: Re: [PATCH 00/37] net: manually convert files to ReST format -
 part 2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 12:56:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Thu, 30 Apr 2020 18:03:55 +0200

> That's the second part of my work to convert the networking
> text files into ReST. it is based on today's linux-next (next-20200430).
> 
> The full series (including those ones) are at:
> 
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=net-docs
> 
> I should be sending the remaining patches (another /38 series)
> after getting those merged at -next.
> 
> The documents, converted to HTML via the building system are at:
> 
> 	https://www.infradead.org/~mchehab/kernel_docs/networking/

Series applied to net-next, thank you.
