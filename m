Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FE768DC12
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjBGOuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjBGOuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:50:23 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88FED7
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:50:22 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id r17-20020a927611000000b00313da1a3ce6so2410091ilc.11
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 06:50:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T3BVpFeHZ4lGXaf3B9wqQOSFxEjUFqOh7/UypgMatbI=;
        b=Xj52jRz1vD3XhEOpOPKib08F6FOxlbx3tEdcVp88UJdJ3AZ+CHMtbV1d19QhPbJk+j
         /Pbbtflyk0JTmF8H9psZgay/MfPv6/T2f66Ni7zQAJY8qdGK3yORpN1A5pmi8YdIeh+W
         E96i4Td54LJbCOUGfCcwhY81lp4UH3F7q1TcJdrv6nKdyjjoxSHXVGVUknlq0vZk1Zs9
         MMmyw7D4jV0mlqKZPsPejvTRbIy0E8nzO3Q4Xn5XQD1rP4Rvw5+Zu3iIjKhAYe1eaPE1
         Axek/IcBFkXfVztyw0doxyY7p0HvkPEhjy9qqEn2jvq2/0jH1fn0gMZlXU/MZFPMfL1W
         jYBA==
X-Gm-Message-State: AO0yUKW7E152dUbftHbOpWsSroK4C4tShOiPjnwNJvbw4A2MNbfm2Yrr
        3poROdaFb+TnaK1lTtAomNeCstwEqhqEgpStzhmXqhyTZpIx
X-Google-Smtp-Source: AK7set8pvWEhKgCAbGbH6gZM/EsmYg8BlGseGJ+RzL9CS0ajuddu+7+EUE4zu40NEaK6+tsBcKGO2IvIgNwqkmaLOCbuRIkcNeWA
MIME-Version: 1.0
X-Received: by 2002:a02:8815:0:b0:3be:9943:54f5 with SMTP id
 r21-20020a028815000000b003be994354f5mr2385849jai.84.1675781422218; Tue, 07
 Feb 2023 06:50:22 -0800 (PST)
Date:   Tue, 07 Feb 2023 06:50:22 -0800
In-Reply-To: <3151684.1675779419@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064832d05f41d44e4@google.com>
Subject: Re: [syzbot] kernel BUG in process_one_work
From:   syzbot <syzbot+c0998868487c1f7e05e5@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        bpf@vger.kernel.org, davem@davemloft.net, dhowells@redhat.com,
        edumazet@google.com, hch@lst.de, jhubbard@nvidia.com,
        kuba@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, npiggin@gmail.com, pabeni@redhat.com,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        will@kernel.org
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

Reported-and-tested-by: syzbot+c0998868487c1f7e05e5@syzkaller.appspotmail.com

Tested on:

commit:         fab9eebf iov_iter: Kill ITER_PIPE
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/ iov-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=1529647b480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=facc234423e66dc6
dashboard link: https://syzkaller.appspot.com/bug?extid=c0998868487c1f7e05e5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
