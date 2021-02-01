Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6869A30A62A
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 12:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhBALGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 06:06:24 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:46120 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbhBALFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 06:05:53 -0500
Received: by mail-il1-f198.google.com with SMTP id j5so13278227ila.13
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 03:05:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=hJQOQRKY0dVzOCXS/HKD2cAkQX1ygeAUzi8IeN/ekfU=;
        b=gfk8o9H9KGCY67Q5PRIz1J6NWrj+d9X08GZ1EY7Wo0EUTXW+NvDucV+IVnTdkCXOuD
         +Y2wLVEpacJ8WMMqGCXT7Nz5sKbLnf7Df3nFtuu07viJ+nuEi/9KB29Q3Gzw8buXz6mH
         D4PROb9zfpoRkgc9FYHFMv4KPEcpDFUXBroNlx1stz8KABkGjjtjQvqpJj365JZ7yiEU
         iQDIiARz5ZYCmMt/I4YWfJgvME4qHptvsBmDvEqVDNoaEQ+uQrZEOOvI6HwG8VW4KN0e
         0nvxqcMux1aEkZnNtVPQDZkiRLJkpR4ckodMWJPJAj6gluxiNzA9xx5zoAEjEPcHT9hk
         WEQA==
X-Gm-Message-State: AOAM530RqEhvf/DSb4/94K1Lu6368tR7L6vpOya4K+lfLYwqhIWscVCl
        hPhmLrTHqedM0AY/lgpL+06yVE1RYlqSYMuf0SLadiWcRBK7
X-Google-Smtp-Source: ABdhPJwI+EmkHMf0DTBwZMv5lgn2W6hnUt+rnGz3MNckYJhYDzOi15MKNkcfu1h/ZfOviGJPwwoWL3CW+LUd3q6ZMDe78S2nwatp
MIME-Version: 1.0
X-Received: by 2002:a6b:b7d3:: with SMTP id h202mr5653934iof.97.1612177512858;
 Mon, 01 Feb 2021 03:05:12 -0800 (PST)
Date:   Mon, 01 Feb 2021 03:05:12 -0800
In-Reply-To: <4151792.1612177504@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f80b3205ba445357@google.com>
Subject: Re: Re: KASAN: use-after-free Read in rxrpc_send_data_packet
From:   syzbot <syzbot+174de899852504e4a74a@syzkaller.appspotmail.com>
To:     David Howells <dhowells@redhat.com>
Cc:     dhowells@redhat.com, hdanton@sina.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git 7ef09ba11b33e371c9a8510c1f56e40aa0862c65

This crash does not have a reproducer. I cannot test it.

>
