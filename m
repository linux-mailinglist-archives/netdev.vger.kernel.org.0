Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0426E1C46AF
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgEDTEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:04:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35679 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727859AbgEDTEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:04:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588619045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UQThDJEUDr/92+sgwacANdF+cPlLZR5WZG2TjmvmO5M=;
        b=F6bvNdDUwj1YGjf4x2neF1Fy3EUiQUjyz25NCM2ZLMOvDBdTz5pJRhWTVRfoy4fsn9VJ/l
        RYASd1iXTAfTsM3qXBKBxYWtE2j5duDFXkeos1ggCx5syLqRu6SOu2j4SwOFZmYaMDLJO2
        DEJMZhmCzIR2RQHOvGdz3swZxYKHNfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-JW7jwDGzNVOEaAWa-UeBTw-1; Mon, 04 May 2020 15:03:55 -0400
X-MC-Unique: JW7jwDGzNVOEaAWa-UeBTw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 846C5107ACF2;
        Mon,  4 May 2020 19:03:53 +0000 (UTC)
Received: from treble (ovpn-117-112.rdu2.redhat.com [10.10.117.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DDDED63BBA;
        Mon,  4 May 2020 19:03:50 +0000 (UTC)
Date:   Mon, 4 May 2020 14:03:48 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, peterz@infradead.org,
        shile.zhang@linux.alibaba.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Subject: Re: BUG: stack guard page was hit in unwind_next_frame
Message-ID: <20200504190348.iphzmd7micvidh46@treble>
References: <0000000000005a8fe005a4b8a114@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0000000000005a8fe005a4b8a114@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 02, 2020 at 11:36:11PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    8999dc89 net/x25: Fix null-ptr-deref in x25_disconnect
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=16004440100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
> dashboard link: https://syzkaller.appspot.com/bug?extid=e73ceacfd8560cc8a3ca
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com

Infinite loop in network code.

#syz dup: BUG: stack guard page was hit in deref_stack_reg

-- 
Josh

