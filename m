Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6A3F33AD3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfFCWJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:09:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFCWJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:09:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 22BE9136E16AB;
        Mon,  3 Jun 2019 15:09:51 -0700 (PDT)
Date:   Mon, 03 Jun 2019 15:09:50 -0700 (PDT)
Message-Id: <20190603.150950.574612418524478159.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] tcp: use this_cpu_read(*X) instead of
 *this_cpu_ptr(X)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190601021733.190857-1-edumazet@google.com>
References: <20190601021733.190857-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 15:09:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 31 May 2019 19:17:33 -0700

> this_cpu_read(*X) is slightly faster than *this_cpu_ptr(X)
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
