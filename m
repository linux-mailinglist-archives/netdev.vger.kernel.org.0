Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346AD17ED7A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 01:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgCJA4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 20:56:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34322 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbgCJA4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 20:56:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB6D215A00CE0;
        Mon,  9 Mar 2020 17:56:46 -0700 (PDT)
Date:   Mon, 09 Mar 2020 17:56:46 -0700 (PDT)
Message-Id: <20200309.175646.2291661470892713299.davem@davemloft.net>
To:     ysseung@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, soheil@google.com,
        ycheng@google.com, ncardwell@google.com
Subject: Re: [PATCH net-next] tcp: add bytes not sent to
 SCM_TIMESTAMPING_OPT_STATS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309201640.84244-1-ysseung@google.com>
References: <20200309201640.84244-1-ysseung@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 17:56:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yousuk Seung <ysseung@google.com>
Date: Mon,  9 Mar 2020 13:16:40 -0700

> Add TCP_NLA_BYTES_NOTSENT to SCM_TIMESTAMPING_OPT_STATS that reports
> bytes in the write queue but not sent. This is the same metric as
> what is exported with tcp_info.tcpi_notsent_bytes.
> 
> Signed-off-by: Yousuk Seung <ysseung@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>

Looks good, applied, thank you.
