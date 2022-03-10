Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852204D4B0C
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243674AbiCJO05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243708AbiCJO0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:26:12 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA001139802
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:22:17 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id e23-20020a6b6917000000b006406b9433d6so3941957ioc.14
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:22:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=pt6H2yEOvbchK2G/mDFNXqaD9NNW74OxNiZGPSNIUtM=;
        b=y4aphub6x6whXSVbIe6piPoVM6AtwXK3nSGz+m/BMlvA1SIgU4ipib2MGjZid2WXjH
         Xo1FyoTMASy+6wXvXbiwGxWFu520jVSvJA0+NXEaWXTbUaLtTy0IWLrVo8aIzc0eye+P
         ztzakvmQfPFVBn+XtmzD2UBAwAJ2VzKkQ1DeL7DsjdWn53evSCmd1xBa6+7tZoYaKeR8
         Cft4sbYfTcIihWIxQLWTGBEtj01HMAKCY1pZu++hjWxyhnIyG+YIDW3IEpZuHDR1zMqb
         lDuCKkDOgb/a33vSXynR/eO5Kg9xJ2PUcEnE6CHtupjnK7L1hercxZL+55IcE0fu9nAO
         WbnA==
X-Gm-Message-State: AOAM530dieQl7RDPUOrB4KmNS+EK7jHOnWUuzzcYnF0cDPaplCQ2Mb0/
        h8a/u+oVh8IykAjIPkDqWV7MszkMwgm3m2mRj/uerqUIorXk
X-Google-Smtp-Source: ABdhPJxO5gO8RMGycxaiSjpAHPo/WwHF1PocT7lXNL6skBMH8eWBmrdKDQXngaT1plEH6LU71jfsudv/ZUBdL904rx77l8dJrn1D
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2192:b0:2bf:e954:5588 with SMTP id
 j18-20020a056e02219200b002bfe9545588mr3904031ila.101.1646922130772; Thu, 10
 Mar 2022 06:22:10 -0800 (PST)
Date:   Thu, 10 Mar 2022 06:22:10 -0800
In-Reply-To: <20220310084247.1148-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000093d7ec05d9ddf04f@google.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
From:   syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>
To:     hdanton@sina.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
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

commit:         1db333d9 Merge tag 'spi-fix-v5.17-rc7' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=16438642a37fea1
dashboard link: https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
