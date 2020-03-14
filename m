Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F191857F8
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgCOBwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:52:33 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:43688 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgCOBwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:52:32 -0400
Received: by mail-il1-f199.google.com with SMTP id t9so10488655ilk.10
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 18:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/CZuM0+mbO6NyqR+mLDX0oKlbyLZj3NtZHFhJDcGVng=;
        b=EOA/DSyJnlEK8iN8NFtYAAe5Q64eMZUsYfKvKA3MnnV+cQ22ZZPxKF6+LpzdBcpKeV
         XVWKDr7Dd+s85i0w25HCX5Ye9XpiGlrmZz5R+3bex5HItI+Q0sd3gSO/7fgTAud3k3ov
         9ZPkNxXB4tgVbfoK5/3py5Sbers7ZxkdVaNFnvR4j2ietZpq4SZ3cKDRwcoyou6Rq+pp
         7teTsk4kNsV6jpSFQhb3h6q+Bh5MOpwBPUZo7HWlaCkFsEiZU/3jCAyfbfMqYphUcZw3
         DWciRmzp7clS0QRIoBeRiWVA2P1Cdzn8HKM9o3/hgp5oz+JUqbap7Bh1tRBdoiuk5L9v
         FBjA==
X-Gm-Message-State: ANhLgQ1vcRNShqJck6Xnu8uP5Dv+//IKSqEG8vmmjBtlGZPA3saGQiXq
        qQ8tFuIK/U93gv1MY79x/tX/FOZiTxBxAsLOh3pMF4TITpMB
X-Google-Smtp-Source: ADFU+vsd7B6zM7k661+N9RLASlT7wDY115i+NOnn4ChlOdfINGGNLgluD9/L+k0eJ+9HakWUkF332HYt3wzwxnDAhQKyCHW7keRq
MIME-Version: 1.0
X-Received: by 2002:a92:79cf:: with SMTP id u198mr2189717ilc.23.1584158642104;
 Fri, 13 Mar 2020 21:04:02 -0700 (PDT)
Date:   Fri, 13 Mar 2020 21:04:02 -0700
In-Reply-To: <CADG63jCSHu7dQ118GEuhXBi0H4CW3cBqB5F2qKiyeVzNb0U+wg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000021721505a0c8ad76@google.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
From:   syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
To:     anenbupt@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but build/boot failed:

failed to checkout kernel repo https://github.com/hqj/hqjagain_test.git/scup_wfree: failed to run ["git" "fetch" "https://github.com/hqj/hqjagain_test.git" "scup_wfree"]: exit status 128
fatal: couldn't find remote ref scup_wfree



Tested on:

commit:         [unknown 
git tree:       https://github.com/hqj/hqjagain_test.git scup_wfree
dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

