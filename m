Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0532C5139AA
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349928AbiD1QZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349933AbiD1QZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:25:28 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4406A43F
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:22:13 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id q9-20020a056e02106900b002cbc8d479eeso2048790ilj.1
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 09:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=o+NNYHCmlN18e93pwDlfBdn8EHsonjKZ0f60NMDZ1RI=;
        b=h+MdfwVQaEfXU/U5sckTkW/IpOqm6HqDlO1LeHj4MFphgLGT6+Z7EZnvGVjUuHYlPp
         vFRNk+TmFOokdaTV4tGZUddoLDbMG/8ejdqoZZxO3jT56H2l9gA64Kg4o+j6tnCzdswA
         hyEp78LF8UJJkPdskcHNaSrcvZvmJgCDSSov5S4+RAxZGL9bqfBFnhuFsgJoiRoj5T9u
         7/XOWVlACCBHB8fVJ1fZzWJZyghXEhruHxRsHxF7EHTxsOOtinUeDjz5hOy4msVdfbaL
         DGTk17xuhayhFaaK2YCdn/fG4GlR/PrbsSQXiN64VoRcOtS2adYXEiT/D1k1Pr0cnP+G
         5Biw==
X-Gm-Message-State: AOAM532MooHIJv7fPSpLbVNjCRbMdfDBl5fJPicwIDfaUl0ybPrpbcLf
        8eshMgKANaK7P+HrQ1/zvFjOjZY7PpvUhsaaKpTRYomM5hZi
X-Google-Smtp-Source: ABdhPJwthCSp2Lm4n3Y5kn4qHfDFDWm2VeW6ZvLb5OBXd/1XBT2uHyHRxo5guK0Eto1k4dewNSUtxKnE1EqlkJqQZWjVORFVCbMd
MIME-Version: 1.0
X-Received: by 2002:a5d:898b:0:b0:649:5bbb:7d95 with SMTP id
 m11-20020a5d898b000000b006495bbb7d95mr13836886iol.107.1651162933305; Thu, 28
 Apr 2022 09:22:13 -0700 (PDT)
Date:   Thu, 28 Apr 2022 09:22:13 -0700
In-Reply-To: <20220428160357.3884-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001b27aa05ddb95442@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in dst_destroy
From:   syzbot <syzbot+736f4a4f98b21dba48f0@syzkaller.appspotmail.com>
To:     hdanton@sina.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+736f4a4f98b21dba48f0@syzkaller.appspotmail.com

Tested on:

commit:         8f4dd166 Merge branch 'akpm' (patches from Andrew)
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ master
kernel config:  https://syzkaller.appspot.com/x/.config?x=864dc6814306810
dashboard link: https://syzkaller.appspot.com/bug?extid=736f4a4f98b21dba48f0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1749d79af00000

Note: testing is done by a robot and is best-effort only.
