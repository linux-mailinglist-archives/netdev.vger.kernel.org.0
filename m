Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCE85E892B
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 09:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiIXHcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 03:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiIXHcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 03:32:23 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AB6B6544
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 00:32:21 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id r12-20020a92cd8c000000b002f32d0d9fceso1779033ilb.11
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 00:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=smF9HOdC+2VyuIQusJkqLf0ZxepoTAJJv1ZHTIKRl8M=;
        b=f7vsTN9tax202igM5TADZr5XlDiZirnjLRdzv57OqZCN1b8UwxnISkvhUipPZppIVr
         uXEiSKz39egQ9wlcNpgmSBsWewxEzZ9RIekP4o96JxOt/I5CE9+vUectlGbzBSnpXG0d
         VuM2cxoNGCIS708pNbV08qoLJVerDN6RUr8/33GQlFxF7Y2+gYG4YPDE5j14per0GABH
         6AzI9GmQWbPRD+F4A+LsrEedb9GlfwobfaXf1jaSF6wbW8AV3bMxszTTLNveHqztKr08
         9Dx4jSgGvKLOVC6wJcKA7VeaGjL/QRDyUMJX6n+hP1Mrgb/umHx+d9sOXTc+U/1b1hbV
         Hgqg==
X-Gm-Message-State: ACrzQf0sk34Wv+oJlb9YWM/epJSRFPQSLqc7wvlvknpRoSjBVWNHVmZ2
        VE2bJ408HyTLV7MwScMXyYIUq+2XWXgN+6L8owazPpOSBIDP
X-Google-Smtp-Source: AMsMyM5dpGDWio+1+8ELwAvfIQQcmtxpvjqTNwVl62gZuxZPf/+C54q/yGdRRt2kmcIH9d9supA+klcDz9KQHyEup54tWf+JEwPc
MIME-Version: 1.0
X-Received: by 2002:a6b:670b:0:b0:6a0:d9db:5ae5 with SMTP id
 b11-20020a6b670b000000b006a0d9db5ae5mr5283649ioc.62.1664004740784; Sat, 24
 Sep 2022 00:32:20 -0700 (PDT)
Date:   Sat, 24 Sep 2022 00:32:20 -0700
In-Reply-To: <20220924071035.16027-1-yin31149@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007aab3a05e9674b8c@google.com>
Subject: Re: [syzbot] WARNING in wireless_send_event
From:   syzbot <syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com>
To:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, keescook@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
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

Reported-and-tested-by: syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com

Tested on:

commit:         aaa11ce2 Add linux-next specific files for 20220923
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13b03250880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=186d1ff305f10294
dashboard link: https://syzkaller.appspot.com/bug?extid=473754e5af963cf014cf
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11b03250880000

Note: testing is done by a robot and is best-effort only.
