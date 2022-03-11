Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1D34D691A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 20:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351120AbiCKTdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 14:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345356AbiCKTdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 14:33:13 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773801B2AD8
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 11:32:10 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id 5-20020a056e0211a500b002c6552a9c5fso6162553ilj.22
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 11:32:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=fnI34CRBlt/cYs2HqCdqD2Q5/sTaoJ/46Ee7fY9DqIA=;
        b=JWE2VXevszHZi+ftieBQoDVq5YHmIkGZSrGk/9mBkUYZApgWUg7Sx0I7vHUPT4cnnB
         F8bpNMH1f0Kyjiua/AXqV9rauTh4haipg5GRMkm2eGR54tqMwX+Itu98fvMLv7AZsPvB
         oLYHrlMcsiN0KQ75iM0BZqBwOXuUePuxKx02RcEhB8wOMYGY1pkkZuYqDzUPYmqJUA2b
         iB3h6cMZWu79mY7C+vbJnEICANekxZuaE/s2Vsf4JRODhbOFpq6dKXS5pbjo4gPh8bBY
         Re75+ymvEVVl0eISNsM2DCijy7NOsMZfdYMfngtmafZH9SrOABnZdGKHoiTwZvlaOBwr
         /fHw==
X-Gm-Message-State: AOAM530h9Bff/EI2+jVOtxd4tcCCGe8kS7bow1vi5YJD5FF7oWTYUzBS
        toHDTjcqHh0WXcRHcjiQQCcIEKuq0Zany3aZ9hC4MhTwtxAu
X-Google-Smtp-Source: ABdhPJw9T42RKvrkWCkabpsnnC9z6AV1gNOg+HSbu964zhQGXxGSiJfYq8qOwb4OWNusJ5OGpWx1PWi96+bxr4WWjM9OPQ71M1Vt
MIME-Version: 1.0
X-Received: by 2002:a92:c9c4:0:b0:2c6:2b1a:c869 with SMTP id
 k4-20020a92c9c4000000b002c62b1ac869mr8663830ilq.120.1647027129866; Fri, 11
 Mar 2022 11:32:09 -0800 (PST)
Date:   Fri, 11 Mar 2022 11:32:09 -0800
In-Reply-To: <04e38a81-f159-2764-0b6b-34b8180ee87b@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000002e20d05d9f663c6@google.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
From:   syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>
To:     hdanton@sina.com, krzysztof.kozlowski@canonical.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
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

commit:         3bf7edc8 Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=16438642a37fea1
dashboard link: https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
