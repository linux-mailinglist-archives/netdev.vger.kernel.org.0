Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A8323B1FC
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 02:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgHDA5x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Aug 2020 20:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgHDA5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 20:57:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D5EC06174A;
        Mon,  3 Aug 2020 17:57:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1EA07127874A4;
        Mon,  3 Aug 2020 17:41:07 -0700 (PDT)
Date:   Mon, 03 Aug 2020 17:57:51 -0700 (PDT)
Message-Id: <20200803.175751.288490176619838107.davem@davemloft.net>
To:     ioanaruxandra.stancioi@gmail.com
Cc:     david.lebrun@uclouvain.be, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, elver@google.com, glider@google.com,
        stancioi@google.com
Subject: Re: [PATCH v3] seg6_iptunnel: Refactor seg6_lwt_headroom out of
 uapi header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803073333.1998786-1-ioanaruxandra.stancioi@gmail.com>
References: <20200803073333.1998786-1-ioanaruxandra.stancioi@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 17:41:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana-Ruxandra Stancioi <ioanaruxandra.stancioi@gmail.com>
Date: Mon,  3 Aug 2020 07:33:33 +0000

> From: Ioana-Ruxandra Stãncioi <stancioi@google.com>
> 
> Refactor the function seg6_lwt_headroom out of the seg6_iptunnel.h uapi
> header, because it is only used in seg6_iptunnel.c. Moreover, it is only
> used in the kernel code, as indicated by the "#ifdef __KERNEL__".
> 
> Suggested-by: David Miller <davem@davemloft.net>
> Signed-off-by: Ioana-Ruxandra Stãncioi <stancioi@google.com>

Applied, thank you.
