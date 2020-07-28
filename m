Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7868F23038F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgG1HLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgG1HLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 03:11:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F5E20792;
        Tue, 28 Jul 2020 07:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595920312;
        bh=yJacfktf1QlvWuBwJGBrSDfCg5HGJQKMtce+4d5/fk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aqrQ8Mo+HL6du7DoyMbdhlBQcK1gRHxV1aPZhqqTRYe8vACaWkp9Q0ZcQdcP6NVe/
         P0Eb+zHnVno9eEb1C1KFOLwACzLsW00a62hbmIP+rUjzGfx/623VyjBZ5m480/B7b1
         N6bq9D2+k+f1dyU1054inelNWy3mDyUqJMqhukgY=
Date:   Tue, 28 Jul 2020 09:11:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: hso: check for return value in
 hso_serial_common_create()
Message-ID: <20200728071145.GA348828@kroah.com>
References: <20200728064214.572158-1-rkovhaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728064214.572158-1-rkovhaev@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 11:42:17PM -0700, Rustam Kovhaev wrote:
> in case of an error tty_register_device_attr() returns ERR_PTR(),
> add IS_ERR() check
> 
> Reported-and-tested-by: syzbot+67b2bd0e34f952d0321e@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=67b2bd0e34f952d0321e
> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>

Looks good, thanks!

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
