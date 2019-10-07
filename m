Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6594CEC80
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 21:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbfJGTLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 15:11:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34515 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfJGTLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 15:11:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id y135so710735wmc.1
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 12:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DbRc2uG6vwGHor8rUOgYQjnnzlCy4EGXZk7gH7qQMpM=;
        b=uG7p6wHrB7n4cOy0ooYUcAyhlMa4wqdOKblRbs4syBkt4iGNIKdZ4LZy83ATMVQr/C
         MhN2PoiPrwm0uhYfIxGwBt62WGgpnYmhr3bVb9sZP8KEV+3Rqk4MMy2BgeD0KdtzXwYR
         6aiGQCKbZZHnhXPxoCDR4jSkXOPudKnJiQhsKyNJyeeI/WwYi6nkNVPUTMbqsjCTwWRD
         7iSQuZB5zY67jJhfd6gBYrM4a1C0HiEtFQV4RESx5E+KABjOn/30wu61awX7UD8BxFwg
         XhQfcswg9XntS5sfSKlsvKutdC8dBQVvp9aj4eT3q+WF0pgcGBMe61zlkpA/eRlM4QpF
         HH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DbRc2uG6vwGHor8rUOgYQjnnzlCy4EGXZk7gH7qQMpM=;
        b=jDYPCjXLfeZSXDcTmO2mIfd8pkmcaf735BraKRFkIiWv8S+nORMB7wwJ4sYbbCP6iB
         qo6CaDpowh8HZAZp5JPzV6qEMp3YNrCmlYl9RvbouCNxwO9DxYoCEkBfoGIX1p4E0hKV
         9MRSMp+FUugB3pz4uyxU50FV7XzgjSwVlAUdGVOokXV8F5q7y6XqmYqZANx96kYoJeD0
         5wHpIskd/XYaSNu7GUOwN2u9Prc7OTrsfrWiMirGsrtrLfTL4qt7FRNkMAC84H38bJIW
         4YGRIqKaWSv4YnENIy2/I7I9z/JdMtJBFHsdoO/O65qL3sql73+bStgh8iJIHMg0wvBn
         7R8Q==
X-Gm-Message-State: APjAAAX5LN3QKdybI9rYHAE54OjBKG8VBPbeMwAozJNqFggdzhSvKAP9
        qwuBnNdUGuSyhADdLeYzFgTPYg==
X-Google-Smtp-Source: APXvYqxjJiO6p74kvRlrae8mHexJwU/dwR9MeEs4DdgIIFJsV/o0Y+jflfVCyFAzb2a3GDMBwXy8uA==
X-Received: by 2002:a1c:d8:: with SMTP id 207mr572307wma.65.1570475463803;
        Mon, 07 Oct 2019 12:11:03 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id j11sm20777978wrw.86.2019.10.07.12.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 12:11:03 -0700 (PDT)
Date:   Mon, 7 Oct 2019 21:11:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     syzbot <syzbot+896295c817162503d359@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in devlink_get_from_attrs
Message-ID: <20191007191102.GD2326@nanopsycho>
References: <000000000000b11343059456a5f5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000b11343059456a5f5@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 07, 2019 at 08:59:11PM CEST, syzbot+896295c817162503d359@syzkaller.appspotmail.com wrote:
>Hello,
>
>syzbot found the following crash on:
>
>HEAD commit:    056ddc38 Merge branch 'stmmac-next'
>git tree:       net-next
>console output: https://syzkaller.appspot.com/x/log.txt?x=1590218f600000
>kernel config:  https://syzkaller.appspot.com/x/.config?x=d9be300620399522
>dashboard link: https://syzkaller.appspot.com/bug?extid=896295c817162503d359
>compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a6a6c3600000
>C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fd50dd600000
>
>IMPORTANT: if you fix the bug, please add the following tag to the commit:
>Reported-by: syzbot+896295c817162503d359@syzkaller.appspotmail.com
>
>kasan: CONFIG_KASAN_INLINE enabled
>kasan: GPF could be caused by NULL-ptr deref or user memory access
>general protection fault: 0000 [#1] PREEMPT SMP KASAN
>CPU: 1 PID: 8790 Comm: syz-executor447 Not tainted 5.4.0-rc1+ #0
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>Google 01/01/2011
>RIP: 0010:devlink_get_from_attrs+0x32/0x300 net/core/devlink.c:124

This is fixed already by:
5c23afb980b2 ("net: devlink: fix reporter dump dumpit")
