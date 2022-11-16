Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BE662C774
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbiKPSRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239155AbiKPSRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:17:30 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5C563CF6
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:17:24 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id x21-20020a5d9455000000b006bc1172e639so9181675ior.18
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:17:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7OndYXh8YdBOGRjDenydUtY0hFqgWlEV17sQog75UHw=;
        b=J0C8QFPbbYX7Dp5/pnls7RR0xxYrqpcttJsdxYe8Qjb4yKhkEtCC5mTAQ/54eMcNAz
         7Dxh5XFH6HVdNouzcd6iDIs0jSaCg0k8jBseSBZGTMeSLZnnHrFFGokM8ncuNy8sjy4J
         PR0VbgdwNddfVOOnsE+FeLWPw0OqhrMaLUU/9t6zwvYXnUOgim3XFmjQu/pHKNES5ffy
         Bn6VWuqMKCjfu1JHD+FnJzS1U99h1QAyoPJqiWmVCQWTsuEYSWjkq2Bh0y26jnIpkJF3
         4M/kszPvN5gJs2CB6JBf1AlgB2+Rw4T0Ea99wJ2VILzW27Fm+EDVgItKS1cBM1lV8ZnL
         h6vA==
X-Gm-Message-State: ANoB5pmQGXDCmoprviNfguU3EkOFVrYbRQus0QJbxRIozwwX8Vh94HyU
        uEaafI2OkMaAUbLg/cdyVuZYF67TrGGiu9oHP7UNajNmGFs/
X-Google-Smtp-Source: AA0mqf5MZGLf+LT0YuUCsrkaeTE8MY5BN0l4FU8jpLa5ph/uDKldbRg0/SQBxohx9ht0gFfHi0tnJ97010+4ifk5YO2OlC5NGbNX
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:489:b0:300:b9c4:8c1 with SMTP id
 b9-20020a056e02048900b00300b9c408c1mr11045689ils.124.1668622643740; Wed, 16
 Nov 2022 10:17:23 -0800 (PST)
Date:   Wed, 16 Nov 2022 10:17:23 -0800
In-Reply-To: <a700b13.191985.1848090ad97.Coremail.linma@zju.edu.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1c64505ed9a7bde@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in nci_cmd_timer
From:   syzbot <syzbot+10257d01dd285b15170a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+10257d01dd285b15170a@syzkaller.appspotmail.com

Tested on:

commit:         1c96c97c nfc/nci: fix race with opening and closing
git tree:       https://github.com/f0rm2l1n/linux-fix.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=16b3ea01880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c42faa14acb6dc7f
dashboard link: https://syzkaller.appspot.com/bug?extid=10257d01dd285b15170a
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
