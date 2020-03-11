Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0799181012
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgCKFcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:32:02 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:41858 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgCKFcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:32:02 -0400
Received: by mail-il1-f197.google.com with SMTP id f19so604750ill.8
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 22:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wevRqhBz7Ha1ufXj1J5HganeoAQW6JbLBzDxT526K4A=;
        b=Ay7ziEKxje9XXdCwESeCd3KL7/8YAe/rqQD2oBMk7Rsf77ixpnXQUxjQl8+A0LVXKJ
         aMo4cKemaQxnNzQU1zfxtnzwRsjIEVlaliFuFNAm2DYdqLoW+3ymYL0OxTzAGy7z/pkl
         fkAiHRAdKfP4BFQi+XBLgrIgUJBdYXlmL2h2/DoQZJ5XgRjYd4IzGEh1TXPKOGZS/S+x
         hILx0QQx3/RGP3Q5AgN7OQBMdShRvWhc2cb4xZEPTDn+l46MAkisxeSjxAgnpq/A84GI
         gyU4gaZZKGgAKTzwTQ3iNuG4IEf5OS9TD2WuWJxUqsjEpohoQ6h+rb6B8r1oFTMETugp
         ORYQ==
X-Gm-Message-State: ANhLgQ2luxoQaYzgAJ8X9SJSLR7CAvbx4kfknoocjFcJaeZMsYmc0d5h
        2nGmZxvGkzt1kbvM5xqqOyZYT2XfJQNMCyeEbfYco3khKnB6
X-Google-Smtp-Source: ADFU+vs5AqIDyondsGCpHRqGUbzyITX4Ug9elC3TYXqm2eit9qrpqbl4xt+rQ3f2GwU+70pBRgba2LC0w62AfY1MRyxlthvFVwiY
MIME-Version: 1.0
X-Received: by 2002:a5d:9509:: with SMTP id d9mr1407940iom.127.1583904721925;
 Tue, 10 Mar 2020 22:32:01 -0700 (PDT)
Date:   Tue, 10 Mar 2020 22:32:01 -0700
In-Reply-To: <CAM_iQpXBb_73wLrBWW7qYfpryWB8zUpMs62d-b0cq3Rw2r2f1w@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004efb2705a08d8e8e@google.com>
Subject: Re: KASAN: use-after-free Read in tcindex_dump
From:   syzbot <syzbot+653090db2562495901dc@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+653090db2562495901dc@syzkaller.appspotmail.com

Tested on:

commit:         2c19e526 net_sched: hold rtnl lock for tcindex_partial_des..
git tree:       https://github.com/congwang/linux.git tcindex
kernel config:  https://syzkaller.appspot.com/x/.config?x=bcbe864577669742
dashboard link: https://syzkaller.appspot.com/bug?extid=653090db2562495901dc
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Note: testing is done by a robot and is best-effort only.
