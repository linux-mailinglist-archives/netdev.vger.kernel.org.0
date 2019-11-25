Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425321092F3
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 18:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfKYRkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 12:40:05 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36893 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfKYRkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 12:40:04 -0500
Received: by mail-pf1-f193.google.com with SMTP id p24so7716496pfn.4
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 09:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=PU2OcTJib2FEZCO1+EC6n/q7O1nFdX7GUda6zHMnWpk=;
        b=EzZ2Px6Zht5jTSbcT4wZXq7XoUzg3ELf9KnSjVfwZY6qPCXdLAs0Bud5oD73CKNWcw
         IogNuIZthU6pcXD47kbxJJcGlr3Z/x6kj7WsJzhaA91cHaEN9fugwnjFAm4j21cRPSoW
         xCYEqwIRZ3lNSZjaMV3U1PG0Gltb+Bws0aJPqmfPNgLunyrClUgttyvj/D+VCy0Ap3ME
         WGfc2FSr5LxwkXYhTO62ef3CVexOp18hgj4ilr9/0MgWT4oRk/I01c1yK9AXr8Z2OrzK
         TzueyAFcOa4PlaKzIm0SZ8iqf/wW/uiUlhiOZjKPAI50KoqSW223yXw9oDa5nKDO65Db
         21Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=PU2OcTJib2FEZCO1+EC6n/q7O1nFdX7GUda6zHMnWpk=;
        b=Yu9UKzfg7O4k0hD1M4LlPbapTgvcBttmW7VBOO/h6UBASgAUQXLiFYn3VKxiyXRga7
         uZnKhu2CPxaBpRk+zjNQAPZBLqpJ/ut/rnCqNRMoN7JmS3PtYc3mNvd/QJEMa/2ykxu9
         lke9HJ6X2kt40Ct5fI1sOnmSE3lSeg93Nns/h1HS9AzxpfP+LyazQ0/5S452QSNbEziM
         KOvr0GQRW8JUQGZtv7QRi0huWpAVUgfg+guGSQktjpE2C4XxTw/iwr3N3BrTvZVS4nA3
         oF/a3bvRWBoOy4cibaSVA3lbCb6jD3UD3idMWcEYQ/hdlg0Hnk6/99LKSjJE02EpWRHX
         p8Ww==
X-Gm-Message-State: APjAAAWTJRK8SgwJkPVKENGLy5hAKK/Z/v9BVrSDHEEZcVqeK+RWpNyw
        1JdZy5ZwwzcsBup+MXv6hwmhLA==
X-Google-Smtp-Source: APXvYqxtGVIhqBr/k4qZbkvbGJ/4yO/5Bkpqb+skwsxuP3qDbEWgyC1v/SGycn6AZG8kDPEo1sUP2w==
X-Received: by 2002:a63:a449:: with SMTP id c9mr33513974pgp.53.1574703604127;
        Mon, 25 Nov 2019 09:40:04 -0800 (PST)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id m6sm8935278pgl.42.2019.11.25.09.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 09:40:03 -0800 (PST)
Date:   Mon, 25 Nov 2019 09:39:56 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+13e1ee9caeab5a9abc62@syzkaller.appspotmail.com>
Cc:     aviadye@mellanox.com, borisp@mellanox.com, davejwatson@fb.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        ilyal@mellanox.com, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pombredanne@nexb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Subject: Re: WARNING in sk_stream_kill_queues (3)
Message-ID: <20191125093956.58133ee8@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <00000000000093bc3b05982dd771@google.com>
References: <000000000000013b0d056e997fec@google.com>
        <00000000000093bc3b05982dd771@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 07:59:01 -0800, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 3c4d7559159bfe1e3b94df3a657b2cda3a34e218
> Author: Dave Watson <davejwatson@fb.com>
> Date:   Wed Jun 14 18:37:39 2017 +0000
> 
>      tls: kernel TLS support
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127a8f22e00000
> start commit:   be779f03 Merge tag 'kbuild-v4.18-2' of git://git.kernel.or..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=117a8f22e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=167a8f22e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=855fb54e1e019da2
> dashboard link: https://syzkaller.appspot.com/bug?extid=13e1ee9caeab5a9abc62
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165a0c1f800000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=114591af800000
> 
> Reported-by: syzbot+13e1ee9caeab5a9abc62@syzkaller.appspotmail.com
> Fixes: 3c4d7559159b ("tls: kernel TLS support")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looking at the repro timeline I'm fairly confident that
commit 9354544cbccf ("net/tls: fix page double free on TX cleanup")
stopped this. Even though it must had been appearing earlier due to a
different bug, because what the mentioned commit fixed was more recent
than the report.

#syz fix: net/tls: fix page double free on TX cleanup
