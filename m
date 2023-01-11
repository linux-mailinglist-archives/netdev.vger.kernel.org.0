Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7540C6660F6
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbjAKQu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbjAKQuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:50:23 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341A4201A
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:50:22 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id y11-20020a056e02178b00b0030c048d64a7so11246322ilu.1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 08:50:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IVlkwIcu/ERIdMF9zXl1iw0QgUBv4pumheJU/b/0NDs=;
        b=dW8s89KFTOvuXjz8Ie6jw1lZS1KP9ZfIT5Fhu8b9v1Kk6Ba/KebGCVw5UyhDBnen14
         ziK9+cDJdy74VCGYP8W+UxtnGM+/Bs7h6rk4Oq0JO5lSm0hLFEykR1Tu29SMldbYNjV9
         c6JsjOU5lpwfJLB+mttDIV4dGm/N1a1k8yBBlPrl072IRGox/6aLuAf2lpSUnolL0VA5
         682LGgVb8kctB9lLpwdqPv+2TH0cxuLnt2xhq+stHCL8Wvl6Jh7w5zyQVntgYYNe7akh
         ctXZtFessZt5+FfFH4qsey8s1oVhy41+ocbxnXmx9sbX0IEEmuCOoSE/H5qY/x55GROl
         N9Xw==
X-Gm-Message-State: AFqh2kquyH4Ks5lg8nuw2xi+Z5LDzSCzb5v5RWd7fZtUnzDmFMNUYeV7
        +TrEVUe6bgetDo6BReD4Np73lSXyQNKlGLdJ4/e1YOPzYp2F
X-Google-Smtp-Source: AMrXdXujnSvvkWTnatFl3bt07Qrfr/4g3+DZMb319bEIWyA1L0LGyYfmqDQ3TNiVTo/n48VFRnoT4MotGowevDTm9Ec3f7rhjHlv
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:c88:b0:303:7518:f784 with SMTP id
 b8-20020a056e020c8800b003037518f784mr5091367ile.295.1673455821594; Wed, 11
 Jan 2023 08:50:21 -0800 (PST)
Date:   Wed, 11 Jan 2023 08:50:21 -0800
In-Reply-To: <2265390.1673430114@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cb290605f1ffcbed@google.com>
Subject: Re: [syzbot] kernel BUG in rxrpc_put_call
From:   syzbot <syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

Reported-and-tested-by: syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com

Tested on:

commit:         8fed7565 Merge tag 'mlx5-fixes-2023-01-09' of git://gi..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=13b40d1c480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46221e8203c7aca6
dashboard link: https://syzkaller.appspot.com/bug?extid=4bb6356bb29d6299360e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11834e5a480000

Note: testing is done by a robot and is best-effort only.
