Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E17D8719
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 06:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbfJPECv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 00:02:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44332 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbfJPECv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 00:02:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54B29108A31AE;
        Tue, 15 Oct 2019 21:02:50 -0700 (PDT)
Date:   Tue, 15 Oct 2019 21:02:49 -0700 (PDT)
Message-Id: <20191015.210249.78012402045984501.davem@davemloft.net>
To:     vvidic@valentin-vidic.from.hr
Cc:     hslester96@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+f1842130bbcfb335bac1@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: usb: sr9800: fix uninitialized local variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191015202020.29114-1-vvidic@valentin-vidic.from.hr>
References: <20191015202020.29114-1-vvidic@valentin-vidic.from.hr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 21:02:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Date: Tue, 15 Oct 2019 22:20:20 +0200

> Make sure res does not contain random value if the call to
> sr_read_cmd fails for some reason.
> 
> Reported-by: syzbot+f1842130bbcfb335bac1@syzkaller.appspotmail.com
> Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>

Applied.

But often in situation like this a failed read can more aptly be indicated by
an all-1's value.
