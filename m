Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB5A14116B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 20:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgAQTF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 14:05:59 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:39305 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgAQTF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 14:05:59 -0500
Received: by mail-io1-f65.google.com with SMTP id c16so27138781ioh.6;
        Fri, 17 Jan 2020 11:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=fRKHeayYr8iV/cXG+M7lT2xtOTZJWBbVT59Xh8S1MvU=;
        b=O4ddfGiYLNJyMqHmd9cdLomXshl9mq5RBY/rio3IRZX5qlYNCb5CrZUBjMiiOMKwfx
         FTuD4iGUfx7qEP4mikji1CnskdXSlioR9eYCsLMnPuQKSLg9QoSoWYXHUqYJ6x4H/wRz
         lkgIA/01MKdwTcd9z8YbyfG5uJy3Wrtv0OIE2CR6WDNuhkkkkSDkIX6m12n1wWJ8qKce
         XjEQCtNIP414cXJqd7zm4FmXvZg/OwIYmncqSSme2rCpmIdhToSdxYPvPyCDSBjGSRhO
         0QtKZUMRY6Hz4ZEi4yJTW8D4dsstxcmYDqWc9ZTU2guydfrUy/atcWLf2GMIazobZu4e
         VUPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=fRKHeayYr8iV/cXG+M7lT2xtOTZJWBbVT59Xh8S1MvU=;
        b=ecsydvStmcVmQ0k58fW9wtt7hVLaHLAjqYye3kobC0P+x5QJgdrvwmkg3IZVr6UEG6
         GXnpMXdyf2LzLyndiaxIlWMr+l5+n2sIcG7Rz7fjgDBwRD7ZkxGo1PZEahnbg6RY14Kf
         tLq7h3xivNf4ywjBUTbvz5Yhejjk+qeKsMJBcMO0Fjb8llpa/laGBO32MBpg+WBkxKaV
         PH7AXVVEfwYw1t0FqLmXoC6WeLmR0PhFKXIuNz+faMJn/M+5Nl4Ji3CQkeu96q8+knjY
         iZxET9zm1b4S2tVneNLDW1tvbWWwjwp86NR7CxMekdx15GbhKqESL25pIbS+8SpT2jtv
         kZEQ==
X-Gm-Message-State: APjAAAVCkKIfsHyWBii7REkecm/wVVVhJyv1+Lh8ihCtaF54EXrmewOY
        XbV9y/SeRjIZRZe03rTQQPI=
X-Google-Smtp-Source: APXvYqxvaEi45NJAUlpGewyDxYkn1hQm+L6k2QrW2Y+cwUJIGg/RBVW5wwMRPnfJJHwUth74BMTpLQ==
X-Received: by 2002:a6b:4917:: with SMTP id u23mr846824iob.202.1579287958380;
        Fri, 17 Jan 2020 11:05:58 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w16sm8155740ilq.5.2020.01.17.11.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 11:05:57 -0800 (PST)
Date:   Fri, 17 Jan 2020 11:05:48 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Message-ID: <5e22058cd468d_1e572abf7dd745bc48@john-XPS-13-9370.notmuch>
In-Reply-To: <000000000000ffc1f1059c58e648@google.com>
References: <000000000000ffc1f1059c58e648@google.com>
Subject: RE: WARNING in sk_psock_drop
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    93ad0f96 net: wan: lapbether.c: Use built-in RCU list chec..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=132caa76e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
> dashboard link: https://syzkaller.appspot.com/bug?extid=d73682fcf7fee6982fe3
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 11793 at include/net/sock.h:1578 sock_owned_by_me  
> include/net/sock.h:1578 [inline]
> WARNING: CPU: 1 PID: 11793 at include/net/sock.h:1578  
> sk_psock_drop+0x5fa/0x7f0 net/core/skmsg.c:597
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 11793 Comm: syz-executor.3 Not tainted 5.5.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 01/01/2011

I recently added this sock_owned_by_me so I'll take a look. Thanks for
the report. Seems we have a case where its not held.
