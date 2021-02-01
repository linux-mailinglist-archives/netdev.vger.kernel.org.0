Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C233B30A424
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhBAJNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbhBAJNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:13:14 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BFAC061573;
        Mon,  1 Feb 2021 01:12:33 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l6VFy-00ENBK-Cv; Mon, 01 Feb 2021 10:12:26 +0100
Message-ID: <b38420df0274c60362b32df9b51c1dcc45b4d5a8.camel@sipsolutions.net>
Subject: Re: WARNING in sta_info_insert_check
From:   Johannes Berg <johannes@sipsolutions.net>
To:     syzbot <syzbot+8dcc087eb24227ded47e@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Date:   Mon, 01 Feb 2021 10:12:25 +0100
In-Reply-To: <00000000000037b29b05ba3f9859@google.com> (sfid-20210201_062624_516998_05A83835)
References: <00000000000037b29b05ba3f9859@google.com>
         (sfid-20210201_062624_516998_05A83835)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-01-31 at 21:26 -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    bec4c296 Merge tag 'ecryptfs-5.11-rc6-setxattr-fix' of git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11991778d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f75d66d6d359ef2f
> dashboard link: https://syzkaller.appspot.com/bug?extid=8dcc087eb24227ded47e
> userspace arch: arm64
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8dcc087eb24227ded47e@syzkaller.appspotmail.com

Looks like this is a dup.

#syz dup: WARNING in sta_info_insert_rcu

Just in this case sta_info_insert_check() didn't get inlined into
sta_info_insert_rcu().

johannes

