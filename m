Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069C51376B9
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgAJTMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:12:48 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40692 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgAJTMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:12:48 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ipzi7-00CT3f-W8; Fri, 10 Jan 2020 20:12:44 +0100
Message-ID: <b5d74ce6b6e3c4b39cfac7df6c2b65d0a43d4416.camel@sipsolutions.net>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 cfg80211_wext_siwrts
From:   Johannes Berg <johannes@sipsolutions.net>
To:     syzbot <syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Cody Schuffelen <schuffelen@google.com>
Date:   Fri, 10 Jan 2020 20:12:42 +0100
In-Reply-To: <00000000000073b469059bcde315@google.com> (sfid-20200110_201111_717668_AFB00A9F)
References: <00000000000073b469059bcde315@google.com>
         (sfid-20200110_201111_717668_AFB00A9F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-01-10 at 11:11 -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    2f806c2a Merge branch 'net-ungraft-prio'
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1032069ee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5c90cac8f1f8c619
> dashboard link: https://syzkaller.appspot.com/bug?extid=34b582cf32c1db008f8e
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.

It's quite likely also in virt_wifi, evidently that has some issues.

Cody, did you take a look at the previous report by any chance?

johannes

