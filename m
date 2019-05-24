Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F26629271
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389281AbfEXIIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:08:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:58794 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388959AbfEXIIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:08:10 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hU5FI-0007Rn-Eo; Fri, 24 May 2019 10:08:08 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hU5FI-000VH1-8U; Fri, 24 May 2019 10:08:08 +0200
Subject: Re: bpf build error
To:     syzbot <syzbot+cbe357153903f8d9409a@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000008666df05899b7663@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <649cac1e-c77c-daf8-6ae7-b02c8571b988@iogearbox.net>
Date:   Fri, 24 May 2019 10:08:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <0000000000008666df05899b7663@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25458/Thu May 23 09:58:32 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/24/2019 07:28 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    e6f6cd0d bpf: sockmap, fix use after free from sleep in ps..
> git tree:       bpf
> console output: https://syzkaller.appspot.com/x/log.txt?x=16f116e4a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fc045131472947d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=cbe357153903f8d9409a
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+cbe357153903f8d9409a@syzkaller.appspotmail.com
> 
> net/core/skbuff.c:2340:6: error: ‘struct msghdr’ has no member named ‘flags’

Disregard, tossed from bpf tree.
