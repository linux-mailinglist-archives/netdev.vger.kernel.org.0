Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1F9543CA4
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 21:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbiFHTQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 15:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbiFHTQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 15:16:25 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBDD49F24
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 12:16:22 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id j5-20020a922005000000b002d1c2659644so16284774ile.8
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 12:16:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Zd7VaJ+t20Ip39Sfs4fMNAc8bfbYqGcyc9hWSuHpp9U=;
        b=Uuxkf/3R6r6J4D1HdrQ5Ye9K+hapaHQX4qpNK5t0IfnYlsUzSluT4dnZZd6eDOvN0P
         VgnIkoxOPtKOnZvk/nIxu0nCDhjbmsBwt2rvEhy/7GQvtcXhG+0os+BpcSpSe08bCQS2
         4+34Dbep03zdWbA+3BHMPd2ip6UPNWWpmn2XrfMzMOUpTNPPcpsrHL7VJ+1u8tzWGMZ1
         y3wmgTurR/1F+N45bBf3ejzs4LaDRctBbxTT++vTgltmh9ASfO2XIAIPgVzny+NZQIQE
         Mm4DSC7Tk/jgogPS2/sfe3+PaMBG5eiaIIsQWHm5TcaeOgQU+J8TxIReYdzajZ61ndSh
         kb0w==
X-Gm-Message-State: AOAM531rd8iZ+pzVJmyIojDbhdLCpwmAjnJCAL+VS2FZuWgZewWSOVmZ
        PpO6LO6+IfnD25LXsMLEFwACizZm3TKgkBj4xQFWTLui2rPb
X-Google-Smtp-Source: ABdhPJy0UBXD5u8aWdBLoB3V1Aplx2c/xnxS4MzYAvEgDjQyzbYMEbEVHsASiYiBFtBhWSQ6nWTs6GmjnjgMjJLm7tFgBzEoUm21
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4705:b0:331:7c49:7048 with SMTP id
 cs5-20020a056638470500b003317c497048mr14416586jab.182.1654715781780; Wed, 08
 Jun 2022 12:16:21 -0700 (PDT)
Date:   Wed, 08 Jun 2022 12:16:21 -0700
In-Reply-To: <0000000000009962dc05d7a6b27f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006097c505e0f48aa2@google.com>
Subject: Re: [syzbot] WARNING in mroute_clean_tables
From:   syzbot <syzbot+a7c030a05218db921de5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, erdnetdev@gmail.com,
        eric.dumazet@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
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
