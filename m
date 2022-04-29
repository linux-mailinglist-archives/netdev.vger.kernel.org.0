Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C073514126
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 06:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbiD2EEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 00:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiD2EEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 00:04:30 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C5060058
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:01:10 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id h28-20020a056e021d9c00b002cc403e851aso2941542ila.12
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6DGT19X0vrXDtGdrIDLwVedBzpBwpOHjc6R6Rv3oEpw=;
        b=HLXbWpAyJwpll86sG9PRZUWRvzX8fyuqJkH+dEPDWltMz9NXm6rHMq11fgTi/zM3QR
         7FFRheCatComp2junfKsyYs1uESvyp/Gd06PNFmPvRUlLiBsouKbXoUiixiUlsXN06yW
         1n5oJRYFGfwO2JlXNIRLuf59pBn6ceSpj8J8JqjN9ld77pCcTsaee8VagFH2JVcv4t9U
         lRiYfic5jv2BSE/05+ye3Y1l9bE8L3nkBnJrpjX4sQtQmm4mj8bbMJE7q79MbUzrDbrv
         Ogg4JArOov0qnIvTtOMJ898QyiyudMyN0WE9KDtjteitvn900yRCaHWKmMMUy2TSOIKg
         zyOw==
X-Gm-Message-State: AOAM533VS6VYKnOJ1eBdl3MxnE6gYd1AyGWb5akxHAqAnN+S/mpTU+/8
        o0iW91W2tU9skhpd0j589jlI0pFxzbbM782lWWhCAN4Uy4hR
X-Google-Smtp-Source: ABdhPJxnzt/f4NwKVtddu8fYNy0LbJhuQBGSHknIm+BStrRmSmFktEUT1ErJAs4zpDQrVU+QCjGkfitNRCua+ojOzWc+L7JwwaBF
MIME-Version: 1.0
X-Received: by 2002:a92:cdab:0:b0:2cd:c27c:28c with SMTP id
 g11-20020a92cdab000000b002cdc27c028cmr5575588ild.189.1651204869780; Thu, 28
 Apr 2022 21:01:09 -0700 (PDT)
Date:   Thu, 28 Apr 2022 21:01:09 -0700
In-Reply-To: <20220428231731.3954-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b6fb5705ddc317ba@google.com>
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

commit:         38d741cb Merge tag 'drm-fixes-2022-04-29' of git://ano..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ master
kernel config:  https://syzkaller.appspot.com/x/.config?x=864dc6814306810
dashboard link: https://syzkaller.appspot.com/bug?extid=736f4a4f98b21dba48f0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16c085aaf00000

Note: testing is done by a robot and is best-effort only.
