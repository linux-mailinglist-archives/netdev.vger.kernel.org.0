Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE3A6B9DD
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfGQKOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:14:45 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63867 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfGQKOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 06:14:44 -0400
Received: from fsav305.sakura.ne.jp (fsav305.sakura.ne.jp [153.120.85.136])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x6HADtYS087173;
        Wed, 17 Jul 2019 19:13:55 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav305.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav305.sakura.ne.jp);
 Wed, 17 Jul 2019 19:13:55 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav305.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x6HADodo087151
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Wed, 17 Jul 2019 19:13:55 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: KASAN: use-after-free Write in check_noncircular
To:     Dmitry Vyukov <dvyukov@google.com>
References: <0000000000001e443b058ddcb128@google.com>
Cc:     syzbot <syzbot+f5ceb7c55f59455035ca@syzkaller.appspotmail.com>,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <d87d7844-5dce-b423-9d54-4e51d482ba5f@i-love.sakura.ne.jp>
Date:   Wed, 17 Jul 2019 19:13:52 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0000000000001e443b058ddcb128@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not a TOMOYO's bug. But

On 2019/07/17 17:58, syzbot wrote:
> ==================================================================
> BUG: KASAN: use-after-free in check_noncircular+0x91/0x560 kernel/locking/lockdep.c:1722
> Write of size 56 at addr ffff888089815160 by task syz-executor.4/8772
> 
> CPU: 1 PID: 8772 Comm: syz-executor.4 Not tainted 5.2.0+ #31
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
> 

what happened here? No trace was printed to console output?

> Allocated by task 8457:
