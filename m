Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512C61A1998
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgDHBfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:35:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44360 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbgDHBfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:35:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99F671210A3E4;
        Tue,  7 Apr 2020 18:35:24 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:35:23 -0700 (PDT)
Message-Id: <20200407.183523.1867238117381062491.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] hsr: check protocol version in hsr_newlink()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200407132321.3957-1-ap420073@gmail.com>
References: <20200407132321.3957-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:35:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Tue,  7 Apr 2020 13:23:21 +0000

> In the current hsr code, only 0 and 1 protocol versions are valid.
> But current hsr code doesn't check the version, which is received by
> userspace.
> 
> Test commands:
>     ip link add dummy0 type dummy
>     ip link add dummy1 type dummy
>     ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1 version 4
> 
> In the test commands, version 4 is invalid.
> So, the command should be failed.
> 
> After this patch, following error will occur.
> "Error: hsr: Only versions 0..1 are supported."
> 
> Fixes: ee1c27977284 ("net/hsr: Added support for HSR v1")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied, thank you.
