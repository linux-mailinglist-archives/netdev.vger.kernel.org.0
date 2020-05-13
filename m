Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3F11D0F8E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 12:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732778AbgEMKRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 06:17:55 -0400
Received: from verein.lst.de ([213.95.11.211]:45564 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732472AbgEMKRz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 06:17:55 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 93B3E68C65; Wed, 13 May 2020 12:17:52 +0200 (CEST)
Date:   Wed, 13 May 2020 12:17:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net/scm: cleanup scm_detach_fds
Message-ID: <20200513101751.GA1454@lst.de>
References: <20200511115913.1420836-1-hch@lst.de> <20200511115913.1420836-3-hch@lst.de> <20200513092918.GA596863@splinter> <20200513094908.GA31756@lst.de> <20200513095811.GA598161@splinter> <20200513101037.GA1143@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513101037.GA1143@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:10:37PM +0200, Christoph Hellwig wrote:
> Ok.  I'll see what went wrong for real and will hopefully have a
> different patch for you in a bit.

Can you try this patch instead of the previous one?

diff --git a/net/core/scm.c b/net/core/scm.c
index a75cd637a71ff..875df1c2989db 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -307,7 +307,7 @@ static int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
 		sock_update_classid(&sock->sk->sk_cgrp_data);
 	}
 	fd_install(new_fd, get_file(file));
-	return error;
+	return 0;
 }
 
 static int scm_max_fds(struct msghdr *msg)
