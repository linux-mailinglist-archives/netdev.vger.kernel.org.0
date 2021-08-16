Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730083EDEE9
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhHPVBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:01:42 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:36855 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbhHPVBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 17:01:42 -0400
Received: by mail-il1-f199.google.com with SMTP id c20-20020a9294140000b02902141528bc7cso10399196ili.3
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 14:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=QdxFVZxxVpsbxj2o+V3LRFIQHQQnZrQkJLl5OL4ggRM=;
        b=qxpne5AyiHqRTRmAAPjw3W+nNfS+HUJW1+/eNu1izGbDLNS1flxFzlorWh5zDS2J+5
         DrXwVEiVBALrhwEAWT6nJWWfFhIA/gqQotxSdGHlxZrR/cGzddq3GnPtdUkaxP4+UnM7
         FRpM+XVih6w9gMXrGuKS0mZgqvbub0fJDGvQESFsVLvAXlPenfhp6QnlMNtFlLbXbrad
         XH6ZUwsYvxCxpOYy5ZZimyrULrkyV3bDYV5pQwmJ8jmLrCk7eI9sEpW3nm4v34huT4nk
         G/GnHMjGu7dovFiL3kEZ+jGZmNDEv+eVrYTX7gUklKwcyrRIoFh3D3HU2JHTujVsnyXn
         ryBQ==
X-Gm-Message-State: AOAM53057rxK6TnhqScLF3DmcvmLY2Ki9UjU6eiDMUJ9uJ6AlVbxJaFh
        ynncnM3NtyG5c15pyAPDrOSQiPYchSk0kRYQ4kqAIdQbOJ69
X-Google-Smtp-Source: ABdhPJwbLG6x/Nim7U+ZAhIBCiDjR+IfP2PInnWonRdz7ac8GlsIVYJT2H3mkthaKYjCFEL1injmoeKZyfkmc6VcPTKerPKls3PN
MIME-Version: 1.0
X-Received: by 2002:a05:6638:33a2:: with SMTP id h34mr513258jav.43.1629147669921;
 Mon, 16 Aug 2021 14:01:09 -0700 (PDT)
Date:   Mon, 16 Aug 2021 14:01:09 -0700
In-Reply-To: <568c354b-6e4b-d15a-613e-3389c99a93a1@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000027061b05c9b38026@google.com>
Subject: Re: [syzbot] INFO: task hung in hci_req_sync
From:   syzbot <syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

net/bluetooth/hci_core.c:1346:18: error: 'HCI_MAX_TIMEOUT' undeclared (first use in this function); did you mean 'HCI_CMD_TIMEOUT'?


Tested on:

commit:         a2824f19 Merge tag 'mtd/fixes-for-5.14-rc7' of git://g..
git tree:       upstream
dashboard link: https://syzkaller.appspot.com/bug?extid=be2baed593ea56c6a84c
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=145874a6300000

