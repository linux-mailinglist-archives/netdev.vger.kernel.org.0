Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5503721CC
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhECUqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:46:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44716 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhECUqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 16:46:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4D3194D0B0F95;
        Mon,  3 May 2021 13:45:45 -0700 (PDT)
Date:   Mon, 03 May 2021 13:45:39 -0700 (PDT)
Message-Id: <20210503.134539.1344269109528145336.davem@davemloft.net>
To:     shubhankarvk@gmail.com
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, willemb@google.com,
        xie.he.0141@gmail.com, edumazet@google.com,
        john.ogness@linutronix.de, eyal.birger@gmail.com,
        wanghai38@huawei.com, colin.king@canonical.com,
        tannerlove@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] net: packet: af_packet.c: Add new line after
 declaration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210503170309.63r2mtupzn5ne6zt@kewl-virtual-machine>
References: <20210503170309.63r2mtupzn5ne6zt@kewl-virtual-machine>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 03 May 2021 13:45:49 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
Date: Mon, 3 May 2021 22:33:09 +0530

> New line added after declaration
> Tabs have been used instead of spaces for indentation
> Each subsequent line of block commment start with a *
> This is done to maintain code uniformity
> 
> Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>

Please resubmit this when net-next opens back up, thank you.
