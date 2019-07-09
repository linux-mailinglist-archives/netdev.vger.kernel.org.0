Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEC462E16
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfGICZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:25:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33756 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfGICZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:25:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DE50133E9740;
        Mon,  8 Jul 2019 19:25:53 -0700 (PDT)
Date:   Mon, 08 Jul 2019 19:25:52 -0700 (PDT)
Message-Id: <20190708.192552.833537119648669033.davem@davemloft.net>
To:     viro@zeniv.linux.org.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] sockfs: switch to ->free_inode()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705191322.GK17978@ZenIV.linux.org.uk>
References: <20190705191322.GK17978@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 19:25:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>
Date: Fri, 5 Jul 2019 20:13:22 +0100

> we do have an RCU-delayed part there already (freeing the wq),
> so it's not like the pipe situation; moreover, it might be
> worth considering coallocating wq with the rest of struct sock_alloc.
> ->sk_wq in struct sock would remain a pointer as it is, but
> the object it normally points to would be coallocated with
> struct socket...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied.
