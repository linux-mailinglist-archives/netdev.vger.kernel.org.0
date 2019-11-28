Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 525CF10CE26
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfK1R4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:56:01 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:40831 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfK1R4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:56:01 -0500
Received: by mail-il1-f200.google.com with SMTP id y3so18305581ilk.7
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 09:56:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=D3t8HLkD5KERASZ5/10L4Vedv8sGcluqQlgTqIienfY=;
        b=AaokmdDBU5ccpPW4tajOu0VxObcjc9oIbWaH0voXuh2QKqjGXMO/Q8fKbUVL/FkTJG
         7oMNJB/4IBlevRKNCaq9hv8QRr/0jOto8LsZb+KXQppRVs04cXmZihPweI7sIktrygHT
         Gd99JzyUf1H2CkaUkoM/r4x+Vw8cGgWvbxPLaBEqebJ1W13WvTe2d8/zQgjTsymSA+Yo
         PQQKQILvvowS+47LLDa3L2CyOj75ckKpDsZzQM5nyAsAey1Cr/zkxWEUQk7Wbhnb501D
         BY3/zTrZgryLMQxfCVvae+zI1ww7Tc3TZ6NNCTblrHpvtz2RJE7qDTuZ2KwydeFUdHAA
         LE/Q==
X-Gm-Message-State: APjAAAUWKCtRn8fQBJqsrPNJhtMueLlxe9GcIxfasSKNCqrrg3lAGRhN
        64IDr4m7aYHrg/YH/ktzSqNI+hheOOaLCqUAj+sJ+xKxbWIR
X-Google-Smtp-Source: APXvYqwtZGLupDC8dXt0vQ4ZsGccZwV0opxixk1mT9lcdgdGXO6PJkgun8hsxChuS0l4VyECRBAJr2PvxTFlSHngLobliKs2uuUl
MIME-Version: 1.0
X-Received: by 2002:a92:7f0a:: with SMTP id a10mr2543646ild.110.1574963760424;
 Thu, 28 Nov 2019 09:56:00 -0800 (PST)
Date:   Thu, 28 Nov 2019 09:56:00 -0800
In-Reply-To: <20191128173407.GD29518@localhost>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000079707305986bd3cd@google.com>
Subject: Re: WARNING: ODEBUG bug in rsi_probe
From:   syzbot <syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com>
To:     amitkarwar@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        johan@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        siva8118@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but build/boot failed:

failed to checkout kernel repo https://github.com/google/kasan.git/master:  
failed to run  
["git" "fetch" "https://github.com/google/kasan.git" "master"]: exit status  
128
fatal: couldn't find remote ref master



Tested on:

commit:         [unknown
git tree:       https://github.com/google/kasan.git master
dashboard link: https://syzkaller.appspot.com/bug?extid=1d1597a5aa3679c65b9f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=152f94dae00000

