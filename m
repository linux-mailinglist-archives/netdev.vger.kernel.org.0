Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13BCC1A42FB
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 09:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgDJH3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 03:29:02 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33253 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgDJH3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 03:29:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id x2so887953qtr.0
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 00:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Fp4kHLta6ZgyzAdMRrwqjvqnCNaMnOLJwog4i1Ni3k=;
        b=ONMTUtxDuiccw4fzD/0N/48iQgXvRiaZsq3i8CKsQktOIikk2rF9mNM+MiN1ng5pO4
         bsTyXbsatmp4t9tj1gftdN1Uj081H9qv03b93tQcmPRTOuXo7ivIBj5LETU7dq5iNnTL
         nfEKNW36UJrVkkRhJz4ccwT6h77vKAujJhgXsB6sTiFcYYNTLvOKEfaMhnRmS0UtiSfA
         DtDi/zvOnERz2+4SsmnwcLmxEguHKcZnJtgnjmH80oQPZWL6yFtrNdom+k6O7TpLc7yd
         4L/n6txrcaFs0Oen1soYK0aEmv3GU11TI+xVmsD7hQiGFadeN+O+uUExq30CzRWnYshp
         XHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Fp4kHLta6ZgyzAdMRrwqjvqnCNaMnOLJwog4i1Ni3k=;
        b=hg6k4CKtcrk5QydoVjB1BNTB2imLFNVZmEKBJtnnEYSZl3stdlE+5wMbhuB9/vA2R5
         sV/YRaMUR7p5IB21PaKJK2gJx7QXRUPor3k7oV33YPF6pfjKM2Mv7GeRkJhwXkGv3y5t
         e68aCBWKJfV3ZH2Cetlv4E7JN6SYx3nZtP1HUhfSMuu44FC0GB0+11hbL919eqRueDC2
         ENMbH81hmvp7bkO0yflVmS6c2GeVgM0BSx1ZSAQEHSi0gUbESpffPlxSKfKQopEe9Lxo
         N03wc5YHgARxl3FklC25W+ycwlGFKnWpnWoYNDCpzwPtub6RA62M1RBaWkR+Pt2Ew6qA
         Xyug==
X-Gm-Message-State: AGi0PubTknZ/0ogCOuNqp2nmfD7SiF2e+Fi0+jKl/oyekNjv9ASCv4AX
        BYAFEhctB+FzU+GCFupwvlk/Jee+1405oyU1ixXO7w==
X-Google-Smtp-Source: APiQypKgexf1MRhqFtGwGLtyDFygeWcyBxQLuAy1Yt2jgWfPBQNFN7i7rTc2h0FfRwURoicccMa82rMzWhtTl0NKjXo=
X-Received: by 2002:ac8:3581:: with SMTP id k1mr3290521qtb.50.1586503741490;
 Fri, 10 Apr 2020 00:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a3376f05a2ea8c22@google.com>
In-Reply-To: <000000000000a3376f05a2ea8c22@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 10 Apr 2020 09:28:50 +0200
Message-ID: <CACT4Y+ZfP7zDOOCksy=NY161ddiKiOzsSty1JfA8+JaP1zacUw@mail.gmail.com>
Subject: Re: net test error: BUG: mismatching fuzzer/executor system call
 descriptions: ADDR vs ADDR (2)
To:     syzbot <syzbot+564b4e9875b107591b55@syzkaller.appspotmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 9:19 AM syzbot
<syzbot+564b4e9875b107591b55@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    aa81700c macsec: fix NULL dereference in macsec_upd_offloa..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=15cff49fe00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c1e98458335a7d1
> dashboard link: https://syzkaller.appspot.com/bug?extid=564b4e9875b107591b55
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+564b4e9875b107591b55@syzkaller.appspotmail.com
>
> Warning: Permanently added '10.128.1.4' (ECDSA) to the list of known hosts.
> 2020/04/06 18:39:32 fuzzer started
> 2020/04/06 18:39:33 connecting to host at 10.128.0.26:41717
> 2020/04/06 18:39:34 checking machine...
> 2020/04/06 18:39:34 checking revisions...
> 2020/04/06 18:39:34 BUG: mismatching fuzzer/executor system call descriptions: 670a1e865c0bc7d60e9886acf4666ee3677e346e vs f787d115f9efa49fdd59261850f5c05f43fbe327
> syzkaller login:

This is now fixed with:
https://github.com/google/syzkaller/commit/2f886fb32cd97875de4a67dfb04c90d925b7d73d

#syz invalid
