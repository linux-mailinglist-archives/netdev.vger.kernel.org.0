Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81AD5EFDA4
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 13:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388770AbfKEMvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 07:51:02 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:43159 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388468AbfKEMvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 07:51:01 -0500
Received: by mail-il1-f199.google.com with SMTP id d11so18474586ild.10
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 04:51:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/lWajsW87pe+jU9auqaIDGr38Nf06GOlbpdLBf+DWPk=;
        b=lxflS/ZJyB33J6DPPUsD0sl0I6Xhg2wF2SVcLAIqNYdU3VOYYELnRavP4UTastUpvc
         ambjgXXW0korgzw8Q6tDeXXHg56y2Iq4uG8PaZ1MTfUofHkmqlTjhroNX7aFcDtSNZkd
         3j7b9zHhZ+/5SYt/FgXX63zu58cCQCBj8cNWdJg+JzjUhZ2BIDxk01suoDgXVeW3pheO
         /GC9LAOmM1ZCt1tDWeSkLzwiVa1SGaXBt2qKag/JAiuLzWYYf+UemK67jb5J7bppp4bN
         8FkYamSbEaNFzhdAmKkQmue5OPbVWdGgmBvp4EqWLLCrM7CevCkhddztRy7Qa2PJN+9q
         ETSA==
X-Gm-Message-State: APjAAAW7mNQcqC9DGrqRPVV8JuKDAyL+AxVc5H6nsV8WKVsPou4s9OdK
        1bVUV+2a1kIk/acsZTFXaCphhfxmcdp9Y7roxocAHxP0y3Gx
X-Google-Smtp-Source: APXvYqzaWIg1tdrmzLbrJ+5MbJ3oMtwvvbO3F0xFNyd06idM/Zc7zKv0xAb30Rx4+qrlCabNIqwresbUOQGkA4+PyMw3U30e2QZG
MIME-Version: 1.0
X-Received: by 2002:a5d:9856:: with SMTP id p22mr15367560ios.29.1572958261043;
 Tue, 05 Nov 2019 04:51:01 -0800 (PST)
Date:   Tue, 05 Nov 2019 04:51:01 -0800
In-Reply-To: <1572952316.2921.3.camel@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065678d059698e26c@google.com>
Subject: Re: KMSAN: uninit-value in cdc_ncm_set_dgram_size
From:   syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oneukum@suse.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+0631d878823ce2411636@syzkaller.appspotmail.com

Tested on:

commit:         96c6c319 net: kasan: kmsan: support CONFIG_GENERIC_CSUM on..
git tree:       https://github.com/google/kmsan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=9e324dfe9c7b0360
dashboard link: https://syzkaller.appspot.com/bug?extid=0631d878823ce2411636
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16b798dce00000

Note: testing is done by a robot and is best-effort only.
