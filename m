Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA011418D
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfEERiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:38:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53056 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEERiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:38:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8AB9114DA649F;
        Sun,  5 May 2019 10:38:21 -0700 (PDT)
Date:   Sun, 05 May 2019 10:38:20 -0700 (PDT)
Message-Id: <20190505.103820.1519624969939965027.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/4] net: extend indirect calls helper usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1556889691.git.pabeni@redhat.com>
References: <cover.1556889691.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:38:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri,  3 May 2019 17:01:35 +0200

> This series applies the indirect calls helper introduced with commit 
> 283c16a2dfd3 ("indirect call wrappers: helpers to speed-up indirect 
> calls of builtin") to more hooks inside the network stack.
> 
> Overall this avoids up to 4 indirect calls for each RX packets,
> giving small but measurable gain TCP_RR workloads and 5% under UDP
> flood.

Series applied, thanks Paolo.
