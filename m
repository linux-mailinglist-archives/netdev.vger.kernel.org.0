Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4835D78AC
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 16:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732706AbfJOOfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 10:35:33 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34868 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732599AbfJOOfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 10:35:33 -0400
Received: by mail-qt1-f193.google.com with SMTP id m15so30910128qtq.2;
        Tue, 15 Oct 2019 07:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DoA7U+1EiFSKPTajJmzsru2e+jWbJ7gKTLijxhS/pE8=;
        b=FjoyVZHoSTUDcDlrKIbSEe4fSN5W1bzK5JcVxpZ643T169U6KVjAQ/RcGwjWt3O5LE
         n+y8CuXCp8sAWq0YoC9suhPOPeK7/8E2JpzhRHlJTVoPycRM+yy2CAfwbOzFCI2D0yj/
         oxXjrHFBDkh1P9eD0yMeaAkkd9ge961cfFOQwrIAHgb2FG5cM7jtweq1lrG5MyICXTr6
         3nevgXAGl7hciDzGc2qAC6SwbgM9v5RNW85BmXZX6k1Jcqr+AmZsXfoX71kgMNV/wIW9
         GDbDOYnFp2zW+Rm7zrnivoWsqIgoszImjxzXD1mkmKE7E810JTS2tmS74YLXtIPIsipk
         jk1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DoA7U+1EiFSKPTajJmzsru2e+jWbJ7gKTLijxhS/pE8=;
        b=aAylk5fpsk3C/zIZJJUEEgsyXzFYx/sR9t/G0qm6LYZsUTbZf1jgFAVGjHyNJ4VIiE
         ahl2XPw4hF/zevy3tjTNr6HP4NSzaTtzPFPa/SwpsgtFh3TU+rSsostwhDgWhf060H7w
         NLDmzasWfeSfODNGtJ6VckNnHfa4XhahduTMWwa1GEb2Q1Kxp3Q5NIlmQYGrQX2rG+V4
         uw3krdlrwo3inISlKz31Y5dTlmR1/D+/thywmgxGStB2A5RhJF9yZi2QxTJvLWkKJPP4
         4APM4Qdud66PSmQJ5rkakt7jgQhuyL2M1nmoK/W1hhtKHCw2rmhWXRdI+iVSw7Q5f+wu
         BJWQ==
X-Gm-Message-State: APjAAAVD8mj8bP7O1ccbJFJ3GezlwYuAryy8ARcN4zBmWg2tUtexAqKq
        o0O4WvfBabd/8tksc7s59Ek=
X-Google-Smtp-Source: APXvYqyRJtMEqqxoanaDeIZhH0tI4w/qivH8thnGvX4T+rBrCcoUbR/K6pkQlef1BRQz6IqEB8Z3GA==
X-Received: by 2002:a0c:ef85:: with SMTP id w5mr37269301qvr.159.1571150132259;
        Tue, 15 Oct 2019 07:35:32 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.217])
        by smtp.gmail.com with ESMTPSA id l189sm9613014qke.69.2019.10.15.07.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 07:35:31 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7D153C0857; Tue, 15 Oct 2019 11:35:28 -0300 (-03)
Date:   Tue, 15 Oct 2019 11:35:28 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: change sctp_prot .no_autobind with true
Message-ID: <20191015143528.GJ3499@localhost.localdomain>
References: <06beb8a9ceaec9224a507b58d3477da106c5f0cd.1571124278.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06beb8a9ceaec9224a507b58d3477da106c5f0cd.1571124278.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 03:24:38PM +0800, Xin Long wrote:
> syzbot reported a memory leak:
> 
>   BUG: memory leak, unreferenced object 0xffff888120b3d380 (size 64):
>   backtrace:
> 
>     [...] slab_alloc mm/slab.c:3319 [inline]
>     [...] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
>     [...] sctp_bucket_create net/sctp/socket.c:8523 [inline]
>     [...] sctp_get_port_local+0x189/0x5a0 net/sctp/socket.c:8270
>     [...] sctp_do_bind+0xcc/0x200 net/sctp/socket.c:402
>     [...] sctp_bindx_add+0x4b/0xd0 net/sctp/socket.c:497
>     [...] sctp_setsockopt_bindx+0x156/0x1b0 net/sctp/socket.c:1022
>     [...] sctp_setsockopt net/sctp/socket.c:4641 [inline]
>     [...] sctp_setsockopt+0xaea/0x2dc0 net/sctp/socket.c:4611
>     [...] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3147
>     [...] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
>     [...] __do_sys_setsockopt net/socket.c:2100 [inline]
> 
> It was caused by when sending msgs without binding a port, in the path:
> inet_sendmsg() -> inet_send_prepare() -> inet_autobind() ->
> .get_port/sctp_get_port(), sp->bind_hash will be set while bp->port is
> not. Later when binding another port by sctp_setsockopt_bindx(), a new
> bucket will be created as bp->port is not set.
> 
> sctp's autobind is supposed to call sctp_autobind() where it does all
> things including setting bp->port. Since sctp_autobind() is called in
> sctp_sendmsg() if the sk is not yet bound, it should have skipped the
> auto bind.
> 
> THis patch is to avoid calling inet_autobind() in inet_send_prepare()
> by changing sctp_prot .no_autobind with true, also remove the unused
> .get_port.
> 
> Reported-by: syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
