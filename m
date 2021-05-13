Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F1D37FB73
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 18:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhEMQ2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 12:28:19 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:55180 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbhEMQ2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 12:28:15 -0400
Received: by mail-il1-f197.google.com with SMTP id g10-20020a056e020d0ab02901b4d3f8a0b2so17124435ilj.21
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 09:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YKYMJN0wOTOdIhbhWJ09zW38cF2+wNMxDEkbWJQv620=;
        b=JPHbifKvV5XxmG3wvkFIfbns3XamBpn6W574/k1bZzIDZx2vc54GhTERvYqsdWo+cQ
         WBVaGrdFWTmtMNWfbvzrJT+F6k01TyBQuPbmMYlcGLIhRA5AMvaKFTU7Qalafi40rZpy
         xZqBIg3xcdVXOwopuBqESGg+kT/51DbJbJjwm3v7dCEAweWg05wYkw1taTctWN3DzXfB
         X1wZW//HkFrA29Abw4uAfgL04JyrDy99+V4g5jhGcn18ZexZeadvOdqmBDQo3gxu+q5F
         ddisetFIUIVU1VlDDZy6JQnpFbD26ZBL95eTbf8tmWWL03hfXtfFrGn4z+av2F2PJGTH
         wuKA==
X-Gm-Message-State: AOAM531+d6TEqc7QlIF7+zEit5gqmfzjx683eiFU1Tjr3uVliVkT3sc5
        f7QalRpEyJTDRlo+Wgukz6ZUQ5J7AMK1SyM4g2CHNIb9jSlP
X-Google-Smtp-Source: ABdhPJyDfQsqI4Kf8+DTE946kH5/MEOSEHJVBdeLXA8kLQzSGICDYM4ZCGvRpL5XacZosrDhcc4hXoWum6QCXdcpQ6jqvPq3mm23
MIME-Version: 1.0
X-Received: by 2002:a02:b717:: with SMTP id g23mr39955248jam.109.1620923224227;
 Thu, 13 May 2021 09:27:04 -0700 (PDT)
Date:   Thu, 13 May 2021 09:27:04 -0700
In-Reply-To: <000000000000aaa4a905ac646223@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd05a005c2389844@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in __queue_work (3)
From:   syzbot <syzbot+77e5e02c6c81136cdaff@syzkaller.appspotmail.com>
To:     Markus.Elfring@web.de, anant.thazhemadam@gmail.com,
        davem@davemloft.net, gregkh@linuxfoundation.org, hdanton@sina.com,
        johan.hedberg@gmail.com, kuba@kernel.org, linma@zju.edu.cn,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit e2cb6b891ad2b8caa9131e3be70f45243df82a80
Author: Lin Ma <linma@zju.edu.cn>
Date:   Mon Apr 12 11:17:57 2021 +0000

    bluetooth: eliminate the potential race condition when removing the HCI controller

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127b3593d00000
start commit:   c0842fbc random32: move the pseudo-random 32-bit definitio..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf567e8c7428377e
dashboard link: https://syzkaller.appspot.com/bug?extid=77e5e02c6c81136cdaff
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=140e36a4900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bluetooth: eliminate the potential race condition when removing the HCI controller

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
