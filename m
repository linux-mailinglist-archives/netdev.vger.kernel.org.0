Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C485C71E
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGBCXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:23:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfGBCW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:22:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF27D14DEABC8;
        Mon,  1 Jul 2019 19:22:58 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:22:57 -0700 (PDT)
Message-Id: <20190701.192257.1757239538999333541.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, alexei.starovoitov@gmail.com,
        dirk.vandermerwe@netronome.com
Subject: Re: [PATCH net] net/tls: reject offload of TLS 1.3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628230759.16360-1-jakub.kicinski@netronome.com>
References: <20190628230759.16360-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:22:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 28 Jun 2019 16:07:59 -0700

> Neither drivers nor the tls offload code currently supports TLS
> version 1.3. Check the TLS version when installing connection
> state. TLS 1.3 will just fallback to the kernel crypto for now.
> 
> Fixes: 130b392c6cd6 ("net: tls: Add tls 1.3 support")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Applied and queued up for v5.1+ -stable.

Thanks.

