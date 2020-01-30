Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB0214E56A
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 23:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgA3WPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:15:32 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:55694 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgA3WPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 17:15:32 -0500
Received: by mail-io1-f70.google.com with SMTP id z21so2874478iob.22
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 14:15:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=+k7iDP+b+RSppJNVffwutaADbltSwq9ahKvDsUQFSno=;
        b=B5zFuKJUsH/3nQLSJ0Px2eav/lMy7Ru4GFwP5O1+3c4e9Q+9tc+CzOlBcHP6vkHmC+
         6IeqMh0+uw/IGjD9cKwXw9KW6dZqMBlkwikDJ3/97ip802iiQyxv185LMj6N8ruLdOg2
         /XiKIlttrxjl2bMDITL/Bmbf3xCLXnRNtmikVZ5gynSm7b1Uv7+axAmHPrIxu6/9Ov2W
         kb3oXjnGuTYstKraCemJzitQyWwWxdrrE1HyxYNtbW/wwf1yet96e0svISDlwN7QR01z
         GcAmqWHRt6npziIS6P4Kg2KO3hK4+kYUW+Iy4lkERqzJiNAIpNigDlBJMUwHLZgE0aRk
         QA5Q==
X-Gm-Message-State: APjAAAXKIHEoIEA05wbdHeW2UsZxhRI/e9tUzL4D6YcKQTqoPUfTq+hu
        6nVxzxZb8EJBXb2seaF8r3AAdRvzxw5VIxguH9usOyg2KaIu
X-Google-Smtp-Source: APXvYqzCBZ/4ytbfQ/bruKEWdSfGIalMqVxY1nmEN/PfITi1/h8RpCDn5XQ2z28pfaS1iyaRrIPuWw325giOjT+XycQu/RjlaEmK
MIME-Version: 1.0
X-Received: by 2002:a92:8141:: with SMTP id e62mr6399121ild.119.1580422531620;
 Thu, 30 Jan 2020 14:15:31 -0800 (PST)
Date:   Thu, 30 Jan 2020 14:15:31 -0800
In-Reply-To: <3725016.1580422520@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097a7d3059d62cbd4@google.com>
Subject: Re: Re: KMSAN: use-after-free in rxrpc_send_keepalive
From:   syzbot <syzbot+2e7168a4d3c4ec071fdc@syzkaller.appspotmail.com>
To:     David Howells <dhowells@redhat.com>
Cc:     davem@davemloft.net, dhowells@redhat.com, glider@google.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git e4866645bc264194ef92722ff09321a485d913a5

KMSAN bugs can only be tested on https://github.com/google/kmsan.git tree
because KMSAN tool is not upstreamed yet.
See https://goo.gl/tpsmEJ#kmsan-bugs for details.

>
