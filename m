Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB09523A7C
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344879AbiEKQkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiEKQkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:40:22 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1B81FE1DB
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:40:21 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id h17-20020a056602155100b0065aa0081429so1467272iow.10
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:40:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Zd7VaJ+t20Ip39Sfs4fMNAc8bfbYqGcyc9hWSuHpp9U=;
        b=E/YHpyGbwL4kSJ6rdKP0Gmqcb1Bv7wzsxf26LHhuycXOWrSMVnNKD+0KK1SQa0/jOp
         VES5q8lVkC40cbTjyu29EMVHhcGrp6EilPz+uhbOvndBqg/Vy+Yl3gjJpxshEt7frMzO
         xu03qAQ7h4YmE+SfozJD93eqtHC/pttEjqj0+fFJKYh/zdlRTE4qv3+JwWnHTh7f3pYz
         0T8PrHGmVONuD8cotHV/6yVJWaT/138/iHM5LaIWLKupsiHre6hwq2uXkoA3cj1z5eoN
         ZL+d735uSLSrUC3HcX7DdatnfS8k7MKwRIIhjwlWqjx9qsfcPQmMnpGXlcvPPY+KEKhw
         bEeg==
X-Gm-Message-State: AOAM530srmRCireginy+ZRvNGAMNFhOPiQuTBvjeYinblUYk8gT/dPgz
        Mu7bsOFzFbbKb3m0vVAt94ZkSmYP3mhM2lQa9mNoiGMinwid
X-Google-Smtp-Source: ABdhPJxpDKFr2qFtoKE0bFOelRySco0CrSfRQHwnpEEtvMC60H+c4vbp8d0h4MoPp5WG8UlxLu/OtRDgBXAPie4D3JazSj1FTMRE
MIME-Version: 1.0
X-Received: by 2002:a6b:2c46:0:b0:65a:4d2f:53 with SMTP id s67-20020a6b2c46000000b0065a4d2f0053mr11130775ios.149.1652287221059;
 Wed, 11 May 2022 09:40:21 -0700 (PDT)
Date:   Wed, 11 May 2022 09:40:21 -0700
In-Reply-To: <0000000000009962dc05d7a6b27f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e0d41905debf1844@google.com>
Subject: Re: [syzbot] WARNING in mroute_clean_tables
From:   syzbot <syzbot+a7c030a05218db921de5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, erdnetdev@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
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

This bug is marked as fixed by commit:
ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table()
But I can't find it in any tested tree for more than 90 days.
Is it a correct commit? Please update it by replying:
#syz fix: exact-commit-title
Until then the bug is still considered open and
new crashes with the same signature are ignored.
