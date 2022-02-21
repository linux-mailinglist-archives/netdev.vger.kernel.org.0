Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5984BEB11
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiBUSkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:40:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiBUSkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:40:33 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78531195
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:40:09 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id r191-20020a6b8fc8000000b0063de0033ee7so10061335iod.3
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:40:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=RPxzAA9BnC5qAmWaV/3BRmFXPmX58G4c2OEDKIVxKv8=;
        b=R6f6wn8yZ+jb72QnPQTZaPRYShotC865g6bpWMKa3Cp6QKRAdgG2410FIq0eHXnJYu
         iR27nvaqKx+ddTb8D3s4SHQeW9eXxgsJFM4vy/QA87lTDi7XpSsugNfjwRGYnH1E8xH/
         5hMTVBYhsdvdaeMOHc/7kciDZWVtrSMqaUzfmhu92ALNi3WFA03ZrbJYv4+4tGFF1a3M
         VCRKppllTTBCdlbedpSDv9/yV3wo27ib5qyw7N8fYee6RVRjayR7mc4D1LVEIuhmxXJW
         JgWVkPh0YYkzpOtIRXg0gh2hlP49AUHgofhEKN0owiDK8DHUJ1fI9gXmsrAUnSyzj0KZ
         MRSg==
X-Gm-Message-State: AOAM5332QoVQnar9aiv61kLOrzhUETRMjblcKPj0XYm8ApvhCyexxnU6
        iupwuID7jajmzJBF2Hi3oV9T41o61v79oHTyTYTEv5Ngu2s/
X-Google-Smtp-Source: ABdhPJwLbZq1aO/UEzVzfLzH/O6TrJEsmlPP5tRjxaPEBMQxIGZHoAyGqkO3wxpQXTnQRAJs8+uaGTbby9XZRQfsky6WhY4Ylyrw
MIME-Version: 1.0
X-Received: by 2002:a6b:2cc5:0:b0:614:50a6:c099 with SMTP id
 s188-20020a6b2cc5000000b0061450a6c099mr16011690ios.71.1645468808827; Mon, 21
 Feb 2022 10:40:08 -0800 (PST)
Date:   Mon, 21 Feb 2022 10:40:08 -0800
In-Reply-To: <YhPZf7qHeOWHgTHe@anirudhrb.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d6dbd305d88b8fb6@google.com>
Subject: Re: [syzbot] INFO: task hung in vhost_work_dev_flush
From:   syzbot <syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com>
To:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mail@anirudhrb.com, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
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

Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com

Tested on:

commit:         038101e6 Merge tag 'platform-drivers-x86-v5.17-3' of g..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=96b2c57ab158898c
dashboard link: https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15e55046700000

Note: testing is done by a robot and is best-effort only.
