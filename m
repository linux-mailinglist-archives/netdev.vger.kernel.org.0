Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F384012D4DE
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 23:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfL3Wpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 17:45:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727732AbfL3Wpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 17:45:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3857F1555A0C5;
        Mon, 30 Dec 2019 14:45:31 -0800 (PST)
Date:   Mon, 30 Dec 2019 14:45:30 -0800 (PST)
Message-Id: <20191230.144530.870155928947538046.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        ncardwell@google.com, ycheng@google.com, kafai@fb.com
Subject: Re: [PATCH net] tcp_cubic: refactor code to perform a divide only
 when needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191230140619.137147-1-edumazet@google.com>
References: <20191230140619.137147-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 14:45:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 30 Dec 2019 06:06:19 -0800

> Neal Cardwell suggested to not change ca->delay_min
> and apply the ack delay cushion only when Hystart ACK train
> is still under consideration. This should avoid a 64bit
> divide unless needed.
 ...
> Fixes: 42f3a8aaae66 ("tcp_cubic: tweak Hystart detection for short RTT flows")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Neal Cardwell <ncardwell@google.com>
> Link: https://www.spinics.net/lists/netdev/msg621886.html
> Link: https://www.spinics.net/lists/netdev/msg621797.html

Applied to net-next, since that's where the Fixes tag commit actually
lives.

Thanks.
