Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46CB180F93
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgCKFOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:14:02 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44710 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgCKFOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:14:02 -0400
Received: by mail-io1-f71.google.com with SMTP id q13so670272iob.11
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 22:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=y2hVpEQqKWh3yJxXsOzl5nrGR83I9+fKU1M1RVWvyPs=;
        b=dpa1lLGYa4R9QpSUpttuoOsD9e+7uNI14DP5/fICq6X63088pxteGRst3kSdvMhDBf
         9Y7oclq9MlzKIIFbGgEZPDS5XBJLdAbSREhMvvUCOLH75iRJGnvDPCArYaICyfW9Iew2
         GMhq04EySWnYk+fbDv6FKvnVoIbHPLnQqotYgyo6MIIx88AAQQCnqWoJJtfO0xhpilul
         h4czPOV+izIYTGEKOTbfFmocwx2ygNfMJaeuCvTCaGz8hhSv6+xYKbQL5pF1ll+QwSRK
         wOu8/PZ1nrN+IgUGsfr7qGvLp7hZjfeE7Z01KZGQ2Nq12pazAr9UPGr7xN8Pba7uvwDN
         jjzg==
X-Gm-Message-State: ANhLgQ1zlS2QiOCfqot6cAF3InfSExQZygByXNq0Sp/x0DyhvjXa2SaC
        eX5PiqF4aZz1vjMdbuxQH/8et205+dRlZYnFNn0UMHtJWYG8
X-Google-Smtp-Source: ADFU+vt5z22CinsEa4J20FC0o79+4pntXOyIVUtMDbKuRwnpcjat0DQwZbtCeu25P6gsSLudopbiXfK1NVr6hZMf3ewRKmzDM21x
MIME-Version: 1.0
X-Received: by 2002:a5e:c70c:: with SMTP id f12mr1381398iop.130.1583903641662;
 Tue, 10 Mar 2020 22:14:01 -0700 (PDT)
Date:   Tue, 10 Mar 2020 22:14:01 -0700
In-Reply-To: <CAM_iQpXLZ1PaG757i1NiQH9q+xuZAzhued0DYEGNH2XtAWZq2A@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000eb7a5405a08d4d7e@google.com>
Subject: Re: KASAN: invalid-free in tcf_exts_destroy
From:   syzbot <syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com

Tested on:

commit:         2c19e526 net_sched: hold rtnl lock for tcindex_partial_des..
git tree:       https://github.com/congwang/linux.git tcindex
kernel config:  https://syzkaller.appspot.com/x/.config?x=bcbe864577669742
dashboard link: https://syzkaller.appspot.com/bug?extid=dcc34d54d68ef7d2d53d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386

Note: testing is done by a robot and is best-effort only.
