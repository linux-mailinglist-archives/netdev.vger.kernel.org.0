Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB2F6179B
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 23:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfGGVNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 17:13:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42610 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfGGVNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 17:13:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6FC5715280187;
        Sun,  7 Jul 2019 14:13:52 -0700 (PDT)
Date:   Sun, 07 Jul 2019 14:13:46 -0700 (PDT)
Message-Id: <20190707.141346.494117083099888245.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com
Subject: Re: [PATCH net 0/2] net/tls: fix poll() wake up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190704215037.6008-1-jakub.kicinski@netronome.com>
References: <20190704215037.6008-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 14:13:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu,  4 Jul 2019 14:50:35 -0700

> This small fix + selftest series is very similar to the previous
> commit 04b25a5411f9 ("net/tls: fix no wakeup on partial reads").
> This time instead of recvmsg we're fixing poll wake up.

Series applied and patch #1 queued up for -stable.

Thanks!
