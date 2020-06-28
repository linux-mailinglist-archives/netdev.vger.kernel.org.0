Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52A520C857
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 16:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgF1OLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 10:11:06 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:35090 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgF1OLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 10:11:05 -0400
Received: by mail-il1-f197.google.com with SMTP id m14so10479082iln.2
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 07:11:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=e3mM+wVWZMbblXjHpKh3rVh40chIjEQjp+JbUdH4Rk8=;
        b=rfk1UU9Kh3q5RDMeqladyA/9Teg1ioqoYTToXxbn5lpaNwN4Y+7XcHQYAim4GrDMek
         p3PMHraaaJxP6R1/D6TqEGaWxSeVJXjyNZGaFclkiKHsXpqqw/5UWis6mK0T7HbppD4K
         JckxLwowwNNIwvSe2oly5ToWGxYHrvFW+ZN0OSslA9C5tTN8sdCS7FJB2Ib8mrcRUMIP
         Ho00ZbFv5SLxdYltDEnAQ9UlptMCYW1OLE+KRD+kgGD2Mew8jv4qv6Hs/sIUWTVRsrfB
         okV4nRvboOFmB8EJHwcFxKdc+WHhRBVEmuXEcBpGX5rq/ocVy9bmMgTvuJP3smO82SBu
         BL3g==
X-Gm-Message-State: AOAM532fZ7g4vF+WQL5U3DRUJRdBx3xxxohzUY8GyhsQ1zEk2kyAnn53
        BriOZpcFRh+qzcn8bqKhXZR/jfQ+wMv6emciF3AQ1bKCH2y7
X-Google-Smtp-Source: ABdhPJz5MwNDHEotHDtTCu6kgkRqMjtTHZ3HOcTj8A4ZUaTiR/zkq5ulZ5jdY9rlNC6HnAnYr5pTa3pe9jMG8+5SS3I+fOL0zhJz
MIME-Version: 1.0
X-Received: by 2002:a05:6638:236:: with SMTP id f22mr13173946jaq.18.1593353465153;
 Sun, 28 Jun 2020 07:11:05 -0700 (PDT)
Date:   Sun, 28 Jun 2020 07:11:05 -0700
In-Reply-To: <CAM_iQpUHiSsfkT8tzwAg7CKYXQQ4ZsROxKZbHKv0LxwrPeM=Jw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004ad07105a9258303@google.com>
Subject: Re: possible deadlock in dev_mc_unsync
From:   syzbot <syzbot+08e3d39f3eb8643216be@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+08e3d39f3eb8643216be@syzkaller.appspotmail.com

Tested on:

commit:         152c6a4d genetlink: get rid of family->attrbuf
git tree:       https://github.com/congwang/linux.git net
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=08e3d39f3eb8643216be
compiler:       gcc (GCC) 10.1.0-syz 20200507

Note: testing is done by a robot and is best-effort only.
