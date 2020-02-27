Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4404D1728FE
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbgB0TyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:54:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729594AbgB0TyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:54:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDFBB1217932C;
        Thu, 27 Feb 2020 11:54:22 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:54:22 -0800 (PST)
Message-Id: <20200227.115422.561903884313675348.davem@davemloft.net>
To:     tklauser@distanz.ch
Cc:     kuba@kernel.org, netdev@vger.kernel.org, ktkhai@virtuozzo.com,
        arnd@arndb.de
Subject: Re: [PATCH net v1] unix: define and set show_fdinfo only if procfs
 is enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200227133442.18728-1-tklauser@distanz.ch>
References: <20200226172953.16471-1-tklauser@distanz.ch>
        <20200227133442.18728-1-tklauser@distanz.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 11:54:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>
Date: Thu, 27 Feb 2020 14:34:42 +0100

> Follow the pattern used with other *_show_fdinfo functions and only
> define unix_show_fdinfo and set it in proto_ops if CONFIG_PROC_FS
> is set.
> 
> Fixes: 3c32da19a858 ("unix: Show number of pending scm files of receive queue in fdinfo")
> Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

I applied v0 before seeing this, so I just committed a relative fixup
to the tree instead.

Thanks.
