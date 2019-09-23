Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E2BBBEA5
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 00:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503456AbfIWWvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 18:51:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:43564 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392820AbfIWWvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 18:51:01 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iCXAR-00087M-8r; Tue, 24 Sep 2019 00:50:51 +0200
Date:   Tue, 24 Sep 2019 00:50:50 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     syzbot <syzbot+491c1b7565ba9069ecae@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bjorn.topel@intel.com, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: general protection fault in xsk_map_update_elem
Message-ID: <20190923225050.GA26406@pc-63.home>
References: <0000000000006a3a2f05933a5c53@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0000000000006a3a2f05933a5c53@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25581/Mon Sep 23 10:20:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 08:49:11AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    b41dae06 Merge tag 'xfs-5.4-merge-7' of git://git.kernel.o..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=130b25ad600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dfcf592db22b9132
> dashboard link: https://syzkaller.appspot.com/bug?extid=491c1b7565ba9069ecae
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155a0c29600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172bf6d9600000
> 
> The bug was bisected to:
> 
> commit 0402acd683c678874df6bdbc23530ca07ea19353
> Author: Björn Töpel <bjorn.topel@intel.com>
> Date:   Thu Aug 15 09:30:13 2019 +0000
> 
>     xsk: remove AF_XDP socket from map when the socket is released

Bjorn, PTAL, thanks.
