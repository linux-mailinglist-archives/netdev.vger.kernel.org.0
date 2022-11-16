Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0326962C716
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbiKPSAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238294AbiKPSAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:00:21 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930C260EBE
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:00:20 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id y5-20020a056602120500b006cf628c14ddso9090576iot.15
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:00:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ycgML46GVnsWZeJ4w7iB/iE60xPyJH5cRCy0usl0TcE=;
        b=Ngc/Fk9cOd/Tng781mz6duG/B+vWCUZ2fpVWkz2iOQfAuMLPR+UXxZI7ayqYGkBHMK
         Y9CVkStkG2pMnm+oWBZV80jivxo3MBSuzteO/1ZxcD+a3k+MOWKcwbEoRyxTckg3Fyfq
         qxIiyQwxyLWFNWGppyr1qwEPZ45Vx7Ud+odICULE4GKbTKSg+v0d4U4ETnm+W2ok/EIA
         RuEjPMQYWyNnFJ0j0uFmx8fqKkwBMmesDRSYrO+TnK3kn6sTlGKzYGSKX8EWwqxX72/Z
         fWY5yKi0yfkLC+nejvpCRDrDqQj4lqvRtiDuMFAgTsBsesGe2HhO2P8LLgbSum33KTqv
         sElA==
X-Gm-Message-State: ANoB5pn6z97i49INYhI9yM8liKWTUO1Cxr/sVx7RAtdugabWXwgPHGTY
        XeGIrsuhabN64IkgBdmTzV+mA2vaTRCszoQyelc5PU8FQhfx
X-Google-Smtp-Source: AA0mqf5NtoIlGoJ2s3JWmc44IFhUzxfdBe1A5rYNXkxFD59dySblOo06dnvl7e4yNEM1ogQwETU7n+4Oiku6UbAgzWxTktgKwZlb
MIME-Version: 1.0
X-Received: by 2002:a92:d8c8:0:b0:300:a79f:c8c8 with SMTP id
 l8-20020a92d8c8000000b00300a79fc8c8mr11819921ilo.206.1668621619981; Wed, 16
 Nov 2022 10:00:19 -0800 (PST)
Date:   Wed, 16 Nov 2022 10:00:19 -0800
In-Reply-To: <110c82d2.191982.18480907a32.Coremail.linma@zju.edu.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ec751205ed9a3ebb@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in nci_send_cmd
From:   syzbot <syzbot+4adf5ff0f6e6876c6a81@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

Reported-and-tested-by: syzbot+4adf5ff0f6e6876c6a81@syzkaller.appspotmail.com

Tested on:

commit:         1c96c97c nfc/nci: fix race with opening and closing
git tree:       https://github.com/f0rm2l1n/linux-fix.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=12f48735880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a2318f9a4fc31ad
dashboard link: https://syzkaller.appspot.com/bug?extid=4adf5ff0f6e6876c6a81
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
