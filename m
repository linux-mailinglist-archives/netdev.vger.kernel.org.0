Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E187843BC9A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbhJZVqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:46:36 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:47788 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbhJZVqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 17:46:35 -0400
Received: by mail-io1-f70.google.com with SMTP id m8-20020a0566022e8800b005de532f3f54so535623iow.14
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 14:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Nkd2MDdhdhQrC35TeT4YASfH+oAymLKxIIDaJwAJcS4=;
        b=8DQ8p1Fj1mmMkZHjmxrxlUTvlKwCeBp/26wywmwLoZmfIt7M9g0tKtwlKntQrjCjYJ
         RyurdC1WL3Q4r+rnKGKg3mAU4PPBEuI2182xOXxfW/4P9PAkV+BAjnad8wvTBYKX8z2I
         CHPr/allU5yH9LdSRh+zvwZ/+br/sPVIZlO81lr8yXzqQ/NUzHPi3t/SgbXAgOl003Xo
         mvHH/alUvWOUWfJWzAJYwhaCtEAmcC3FeElWCOI2NGvMSmIRnLHw11mGzRZbWkXERa6m
         y7JY1GpdT8k/f28af20hn7gPqqeoFkK+PgpPcoBksN1q+T2nUFozo2F6H+kAsZSwYCxb
         Ganw==
X-Gm-Message-State: AOAM531ei7Y1muyrYyJhGnrAjetk27c5Jb3t7FW/C8TaAWAeTKYeh92R
        Zpg0f0vNmjULlSgpvqdMH7puiDhSM7yeNZLVv6ojKS8aiTz/
X-Google-Smtp-Source: ABdhPJzN3TKKDvt07oWmvWN3D3GEM2iDA5um8MqVj3ZDnbSUvjr5KloSalmIqlOE/uEbmF1x00ad/bebF/k+Xst7WWwNpmIp8BjG
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3281:: with SMTP id d1mr17208695ioz.84.1635284650740;
 Tue, 26 Oct 2021 14:44:10 -0700 (PDT)
Date:   Tue, 26 Oct 2021 14:44:10 -0700
In-Reply-To: <00000000000058e2f605b6d2ad46@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b6cfc405cf4860a7@google.com>
Subject: Re: [syzbot] INFO: rcu detected stall in ieee80211_tasklet_handler
From:   syzbot <syzbot+7bb955045fc0840decd3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, fweisbec@gmail.com, hdanton@sina.com,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mingo@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 313bbd1990b6ddfdaa7da098d0c56b098a833572
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Sep 15 09:29:37 2021 +0000

    mac80211-hwsim: fix late beacon hrtimer handling

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=151766bab00000
start commit:   835d31d319d9 Merge tag 'media/v5.15-1' of git://git.kernel..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c32e23fada3a0e4
dashboard link: https://syzkaller.appspot.com/bug?extid=7bb955045fc0840decd3
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e08125300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b17dde300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: mac80211-hwsim: fix late beacon hrtimer handling

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
