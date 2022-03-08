Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89594D2040
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 19:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbiCHSaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 13:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbiCHSaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 13:30:04 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E677638D87
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 10:29:07 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id j18-20020a056e02125200b002c5fd4f94a7so11624814ilq.4
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 10:29:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Eq80vscKFSPEzgR+FDiRmuoeTAILRwkYVSwA6/NoYo4=;
        b=eUsxJzfsUPFl0k848ekfIlhkK0zCvzKh3X0sx9OUyg2aU5CLrXVcn1EaCmw4RmVnli
         jaky46HaxStL1VpT34gAoxn9QfaaVAt7bN2aAMffejzYj+wouxMzZKLDf8OQ9GC5/ibD
         T++HKryibL5nYVUegpydNiKFgqyPFJKuBWynmj6O4UsCwZ3u6K4VDQIRVJv7Ph3LseKC
         i2hFRr4HzV2968ckZc/Wil31P9ABhaiWarlo9CeoWjE2mI8oqFxvILW20gOjFF7JtpRU
         HXLTRUETqs6ixKROJYcDwBVwE6ah2gZ01XCYz4GhuiIY1XZYW+yLmKkaArQc6oWu3214
         NRxg==
X-Gm-Message-State: AOAM530lNjMEeCJS77dOMIZiiHjVb+fsSTfsYtFZZxEJo2N/3eAKpNfg
        uUAlykZZXcbIQCdWdu/DJRjDBHUb2Ep4poySdiKxo+m476Ol
X-Google-Smtp-Source: ABdhPJwVFPhNiHPfPMNpTVlIMlvVOvmig1Aq+ErIY65R0hsIf8B3ZibkKBvvJFKpbOO64etTDlNuig/+Q1eNkcIlSyv6RBtHeB1a
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a45:b0:2c2:b182:e0ac with SMTP id
 u5-20020a056e021a4500b002c2b182e0acmr16924537ilv.264.1646764147309; Tue, 08
 Mar 2022 10:29:07 -0800 (PST)
Date:   Tue, 08 Mar 2022 10:29:07 -0800
In-Reply-To: <ef9d2a7e-932b-9389-ce4c-82b9d74952c8@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000007834c05d9b9289f@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in port100_send_complete
From:   syzbot <syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com>
To:     krzysztof.kozlowski@canonical.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com

Tested on:

commit:         92f90cc9 Merge tag 'fuse-fixes-5.17-rc8' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=aba0ab2928a512c2
dashboard link: https://syzkaller.appspot.com/bug?extid=16bcb127fb73baeecb14
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10a7dfd1700000

Note: testing is done by a robot and is best-effort only.
