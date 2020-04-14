Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979D31A7900
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 12:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438851AbgDNK7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 06:59:16 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33245 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438848AbgDNK7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 06:59:05 -0400
Received: by mail-io1-f70.google.com with SMTP id n85so10640622iod.0
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 03:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=B/wMlDlQPegcALh4XzxDXP3zbriJPXSUWAjVGj5HNW0=;
        b=KmViWGe3cL4jVmFuIxOPmDjvxPmYMIDN4TRGxAMQocRxucH1W1yp9fC92TCft7t16a
         r2uRtTC+yDxdnUg9H77fYm9MyGZ78r0AnFrwuuyjpwpGn8nP/CbLejGR98n4u5yD7xZe
         hvzL6BiwokuFciMn898L4c6yPCaEKIjqwANbtmOfuxQI5AcBsZi9DTGB4km0i8LufMfx
         vqIGwZz6nVTAXz7irMFbrMLJW0WGN1JK2Vi2JlmaBYj7wlvRoJPJS6XZjVJSJ5MjgQMs
         7IPmvbZqc2DFVLw4aC9WXYxFvFJOa6LeZWRngNwK4oUlIuBV9TjkVlgz3J1IUyu2eax7
         K7Uw==
X-Gm-Message-State: AGi0PuYYY0R1brhh4UkhBmzkf3BlVHXcsLeFltZYBTx6d6w4jawL4uVK
        iW2noo26ZImQIpUb1Z2rMZlcsPcVreR82h112mQXeWeAdr4M
X-Google-Smtp-Source: APiQypKAhI/rash2i+SF7YvWdutz9ltcTt0CfD36FY1rEVx5Y6wMm1OewFDHN3vNTTAmI5vEiUVtkIEsNuYKCiBd0yNc3Rmw/p18
MIME-Version: 1.0
X-Received: by 2002:a6b:770e:: with SMTP id n14mr20446473iom.110.1586861943126;
 Tue, 14 Apr 2020 03:59:03 -0700 (PDT)
Date:   Tue, 14 Apr 2020 03:59:03 -0700
In-Reply-To: <66c3db9b1978a384246c729034a934cc558b75a6.camel@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d7e0f05a33e163e@google.com>
Subject: Re: WARNING in hwsim_new_radio_nl
From:   syzbot <syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com

Tested on:

commit:         e154659b mptcp: fix double-unlock in mptcp_poll
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=5af684c50f30bcb2
dashboard link: https://syzkaller.appspot.com/bug?extid=a4aee3f42d7584d76761
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=144e124fe00000

Note: testing is done by a robot and is best-effort only.
