Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACE7534419
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 21:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241206AbiEYTQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 15:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344222AbiEYTQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 15:16:19 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C7711804
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 12:16:16 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id i189-20020a6bb8c6000000b0065e475f5ca9so11044537iof.15
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 12:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Zd7VaJ+t20Ip39Sfs4fMNAc8bfbYqGcyc9hWSuHpp9U=;
        b=3cDbD5UytBUFXJ75M8aN1E3AutcjS6IkU9jSghXKhhhWdciM0nYmVch2GVaFp+HpJx
         wHEeycshN+lsxO6/HGrlLzxt2C6yae4KNeoxayIj1UlFrxtf7Sd/4uLqoCqv2cuOUca+
         bB8Pm4Apx3wyV4hl1NCg/Y3CCtDUmhTZZ9HbzcMHudWMd3QUtLSe1M8ir9YeT0tfQkdK
         T9u5M0BDS335OY6lW1ucuWMujDGRzhhHmk+27OAXAqK/D7MYDyO5A8FefFPUCgdOBCOa
         Gmj28sZfd4z0MomHDca9r+t1nvtS7kjJhdN+80+4kJy/zSNC1Li8nWCRi4qymWkvbYjx
         cOzg==
X-Gm-Message-State: AOAM532CKqIhNE/+WFOkbW8oyO2Ya5koZK9s+bu0jrDBMPNR11uM3lv6
        8H3UiJ6o12bKltxaOYUIPlKMa8I4TBAJ9YgeXNZXlEmUoTJ2
X-Google-Smtp-Source: ABdhPJzxkK6efujxpBRrAJRPK4B+eeU7x8Paa5p6HD1Kw/H7xuz1ZqVcFs5pr1sQ1+srrNbm0lxfdajZhe18FVStIan97Too8PVI
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1bc1:b0:2d1:8e35:dcba with SMTP id
 x1-20020a056e021bc100b002d18e35dcbamr11361659ilv.58.1653506175646; Wed, 25
 May 2022 12:16:15 -0700 (PDT)
Date:   Wed, 25 May 2022 12:16:15 -0700
In-Reply-To: <0000000000009962dc05d7a6b27f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003bc05a05dfdae88b@google.com>
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
