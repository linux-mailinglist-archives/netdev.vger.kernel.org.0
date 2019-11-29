Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC9D10D35B
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 10:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfK2Jj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 04:39:58 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64841 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2Jj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 04:39:58 -0500
Received: from fsav301.sakura.ne.jp (fsav301.sakura.ne.jp [153.120.85.132])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xAT9duVL025281;
        Fri, 29 Nov 2019 18:39:56 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav301.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav301.sakura.ne.jp);
 Fri, 29 Nov 2019 18:39:56 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav301.sakura.ne.jp)
Received: from [192.168.1.9] (softbank126040062084.bbtec.net [126.40.62.84])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id xAT9dnVK025145
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Fri, 29 Nov 2019 18:39:55 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: Re: general protection fault in smack_socket_sendmsg (2)
To:     syzbot <syzbot+131d2229316b7012ac06@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
References: <000000000000723a32059870fbd4@google.com>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, jmorris@namei.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        serge@hallyn.com, Casey Schaufler <casey@schaufler-ca.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <ee964c66-da56-def6-9525-6d960ab9487a@I-love.SAKURA.ne.jp>
Date:   Fri, 29 Nov 2019 18:39:49 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <000000000000723a32059870fbd4@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/29 9:05, syzbot wrote:
>  rxrpc_send_keepalive+0x254/0x3c0 net/rxrpc/output.c:655

Again net/rxrpc/output.c:655

#syz dup: KMSAN: use-after-free in rxrpc_send_keepalive
