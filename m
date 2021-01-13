Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9FE2F537B
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbhAMTmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:42:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbhAMTmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 14:42:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 039932333E;
        Wed, 13 Jan 2021 19:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610566899;
        bh=sy/xsRZ83xiC/bL9POsUHJU6O60B9nJN8f53pZkC3j8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RQdescFN6Al7JIrl0cC169kus1nRHAeqjjMcihWqKyhOWe4FcMcybEL3KBfpOW5pa
         VuOyQ5ZppPqNZ8h70TT6bU8T7WBlw8QAf5Zg9ZDXPcTFvtYYV6KhULWxmUPkDuUC2M
         EfZ6wPGrpg9p/asXLv+urJirjTQ+4yYzHGuu8G3JJVJAOWW9mXm7V0BIu2r4OROB9w
         XODONcNKfBzaeI8Ugj70p8V5ueAxUAdL1nkoLcdOXs3P55lRTQ74npAjWLcJjEYMNe
         aBxfb8t5t1ppTgMD+/wjICmWggCc2mfHDKIWFSJBEOe/sgxHCIsE9/1dILR1JKhTDV
         EaRIfboOn0bvg==
Date:   Wed, 13 Jan 2021 11:41:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     syzbot <syzbot+2393580080a2da190f04@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, f.fainelli@gmail.com, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: kernel BUG at net/core/dev.c:NUM!
Message-ID: <20210113114136.4b23f753@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <000000000000f9191905b8c59562@google.com>
References: <000000000000f9191905b8c59562@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 02:27:27 -0800 syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c49243e8 Merge branch 'net-fix-issues-around-register_netd..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=11da7ba8d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bacfc914704718d3
> dashboard link: https://syzkaller.appspot.com/bug?extid=2393580080a2da190f04
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13704c3f500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=160cc357500000

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git sit-fix
