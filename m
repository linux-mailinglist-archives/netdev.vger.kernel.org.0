Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDE9244F6
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 02:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfEUAMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 20:12:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEUAMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 20:12:03 -0400
Received: from localhost (50-78-161-185-static.hfc.comcastbusiness.net [50.78.161.185])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C25F613F3ABBB;
        Mon, 20 May 2019 17:12:02 -0700 (PDT)
Date:   Mon, 20 May 2019 20:12:02 -0400 (EDT)
Message-Id: <20190520.201202.368431080157706787.davem@davemloft.net>
To:     felipe@felipegasper.com
Cc:     viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3] net: Add UNIX_DIAG_UID to Netlink UNIX socket
 diagnostics.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190519013839.20355-1-felipe@felipegasper.com>
References: <20190519013839.20355-1-felipe@felipegasper.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 17:12:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felipe Gasper <felipe@felipegasper.com>
Date: Sat, 18 May 2019 20:38:39 -0500

> Author: Felipe Gasper <felipe@felipegasper.com>
> Date:   Sat May 18 20:04:40 2019 -0500
> 
>    net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.

Please format your patch submission properly.

This Author: and Date: should not be here in the commit message.

The "net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics." should
be exclusively in your Subject line.

And:

>    This adds the ability for Netlink to report a socket's UID along with the
>    other UNIX diagnostic information that is already available. This will
>    allow diagnostic tools greater insight into which users control which
>    socket.
> 
>    To test this, do the following as a non-root user:
> 
>         unshare -U -r bash
>         nc -l -U user.socket.$$ &
> 
>    .. and verify from within that same session that Netlink UNIX socket
>    diagnostics report the socket's UID as 0. Also verify that Netlink UNIX
>    socket diagnostics report the socket's UID as the user's UID from an
>    unprivileged process in a different session. Verify the same from
>    a root process.
> 
>    Signed-off-by: Felipe Gasper <felipe@felipegasper.com>

This is all unnecessarily indented.

I know what you did, you took something like "git show" output and
just posted it to the list here.

But that's not what you're supposed to do.

Thanks.
