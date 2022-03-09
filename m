Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7A54D3AAA
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbiCIT5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiCIT5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:57:17 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FDE14D276
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:56:17 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id r16-20020a92ac10000000b002c1ec9fa8edso1908354ilh.23
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:56:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=aJ1Eog2W1LKcznurl9kl2G9kB9yGWpw24jPzAJAWqZI=;
        b=pJ4RIXbapeA47pHw/LumXeTrMlmQAvgpQGh8TfRynUW/nSNDOF7Zmu0Pf+piJ349Ey
         0RXq+W3H0gcHIpfl/STqze25pUJdwj5OuhEC1vYlAR/2yo7bkdOwQOF5TcriWjqy+TX4
         FwIalMPdG6x8y/vW9yJbt53V3UzVJspZykj3ZMbJFIWDnO0pTcNNFJ2WGd5JN7cUtarN
         mIrWpblZAKGjN0qFEdcvYEf+te4nYb32NsHsCa5RjanFjf1pEessoO8rEIRAATT1uoTo
         DvKb+etnd5vZHKiw7ZCfXX91iY4+KESZPEW1YkPHhoxilDmaWFDnJi+kpc7DxqHGWzUH
         OxJw==
X-Gm-Message-State: AOAM533Lzdu5lUphKEPWAmvoIPKsJLsxpfo/UCEyuubX+JCBRQ0FhDRY
        IxwcX1nOizm+LBp1ErWkdpEOh80II2f5naPj6HhCHxAV8THc
X-Google-Smtp-Source: ABdhPJw8QbFZm5aQlvQgGcbpKvp0OyzW8aL5faeGnXZ0V5SwSay+jZZrbr/v3WAADgj4CjoqYoVUmRaKKrR1ZWgnrt8cXT5loe7l
MIME-Version: 1.0
X-Received: by 2002:a02:966c:0:b0:317:141d:c924 with SMTP id
 c99-20020a02966c000000b00317141dc924mr1048732jai.104.1646855776596; Wed, 09
 Mar 2022 11:56:16 -0800 (PST)
Date:   Wed, 09 Mar 2022 11:56:16 -0800
In-Reply-To: <d9addbc6-b4bd-289e-9c57-87dc9034f6a2@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008f768505d9ce7d04@google.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
From:   syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com

Tested on:

commit:         330f4c53 ARM: fix build error when BPF_SYSCALL is disa..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=16438642a37fea1
dashboard link: https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=117d9781700000

Note: testing is done by a robot and is best-effort only.
