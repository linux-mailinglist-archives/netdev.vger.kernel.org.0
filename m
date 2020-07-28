Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E5023136A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgG1UCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgG1UCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:02:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F62C061794;
        Tue, 28 Jul 2020 13:02:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F85F128A4D86;
        Tue, 28 Jul 2020 12:45:46 -0700 (PDT)
Date:   Tue, 28 Jul 2020 13:02:30 -0700 (PDT)
Message-Id: <20200728.130230.969755460801493655.davem@davemloft.net>
To:     rkovhaev@gmail.com
Cc:     kuba@kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: hso: check for return value in
 hso_serial_common_create()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728064214.572158-1-rkovhaev@gmail.com>
References: <20200728064214.572158-1-rkovhaev@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 12:45:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>
Date: Mon, 27 Jul 2020 23:42:17 -0700

> in case of an error tty_register_device_attr() returns ERR_PTR(),
> add IS_ERR() check
> 
> Reported-and-tested-by: syzbot+67b2bd0e34f952d0321e@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=67b2bd0e34f952d0321e
> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>

Applied, thank you.
