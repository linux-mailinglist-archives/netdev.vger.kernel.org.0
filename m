Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DAC48FC6C
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 12:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbiAPLzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 06:55:13 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:53073 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiAPLzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 06:55:13 -0500
Received: by mail-il1-f199.google.com with SMTP id m3-20020a056e02158300b002b6e3d1f97cso9340658ilu.19
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 03:55:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=pcqghOLmFHQd4kNv1nK4ZF7/rBgU1CFGoN8hBRKSd1Q=;
        b=QbvKfjm+wtOM1SSgfGbEoWfnr976V/t5+/5z2m6Vyb6Iqq6L43ER2eQu5/Pg3iBtKX
         4wE3cOHfcjl8UFiSezFgiMacgqQ//Yr4uOrVtrHYPwo2tFDzBq/CxBMSx8oFljFam97I
         eladeFampWw0vfV93IraZ2ej3Kz5cFs9k74KtC4nH5FLFxMigPbTOIw/DiiE2ViDE4KK
         3UOQR20nCbPs8Wh4EwCcaYCesVEaa/uB+6SxxjtaB3fTrXEoYbQxVd56ZCtV/0nl/fSc
         J/PCai0SrPJ9tNcwdoDjhr43k00jJBRDD7BPq+l72u0CsVJmv5TjCLnnhoGzIIC0UFni
         glHg==
X-Gm-Message-State: AOAM531ycHlunZ6TilxI4a5BDDnvNhNdgjDecrBoxB/S77yADWPbkobE
        ILam4mg66rBgMZ7C+ziRzmvfi6pWRE0athiktBPccOYqG0ZR
X-Google-Smtp-Source: ABdhPJyNE1UXBXOaJSv3x38kfUBkh6qf2pgvHb9ayYaWHoon7Wy48IkgOgp4MvqbPEA+S/toakjHMjXjn7ZqV3S9AeIh3XGkCmeF
MIME-Version: 1.0
X-Received: by 2002:a02:856a:: with SMTP id g97mr3746783jai.199.1642334112626;
 Sun, 16 Jan 2022 03:55:12 -0800 (PST)
Date:   Sun, 16 Jan 2022 03:55:12 -0800
In-Reply-To: <20220116114236.2135-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000062bd0405d5b1b5ef@google.com>
Subject: Re: [syzbot] general protection fault in nfc_alloc_send_skb
From:   syzbot <syzbot+7f23bcddf626e0593a39@syzkaller.appspotmail.com>
To:     hdanton@sina.com, krzysztof.kozlowski@canonical.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nixiaoming@huawei.com, paskripkin@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+7f23bcddf626e0593a39@syzkaller.appspotmail.com

Tested on:

commit:         4d66020d Merge tag 'trace-v5.17' of git://git.kernel.o..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4d92848a46d5895
dashboard link: https://syzkaller.appspot.com/bug?extid=7f23bcddf626e0593a39
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11b7cc60700000

Note: testing is done by a robot and is best-effort only.
