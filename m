Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7BEAE521
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404797AbfIJIJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:09:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404739AbfIJIJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 04:09:31 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F5F8154A86C5;
        Tue, 10 Sep 2019 01:09:28 -0700 (PDT)
Date:   Tue, 10 Sep 2019 10:09:23 +0200 (CEST)
Message-Id: <20190910.100923.398630420341862032.davem@davemloft.net>
To:     chunguo.feng@amlogic.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] tcp: fix tcp_disconnect() not clear tp->fastopen_rsk
 sometimes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906093429.930-1-chunguo.feng@amlogic.com>
References: <20190906093429.930-1-chunguo.feng@amlogic.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 01:09:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: chunguo feng <chunguo.feng@amlogic.com>
Date: Fri, 6 Sep 2019 17:34:29 +0800

> From: fengchunguo <chunguo.feng@amlogic.com>
> 
> This patch avoids fastopen_rsk not be cleared every times, then occur 
> the below BUG_ON:
> tcp_v4_destroy_sock
> 	->BUG_ON(tp->fastopen_rsk);
> 
> When playback some videos from netwrok,used tcp_disconnect continually.
 ...
> Signed-off-by: fengchunguo <chunguo.feng@amlogic.com>

This still needs review.
