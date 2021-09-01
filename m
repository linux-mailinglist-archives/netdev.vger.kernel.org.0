Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FA13FE393
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243319AbhIAUQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:16:17 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:44954 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhIAUQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:16:16 -0400
Received: by mail-io1-f70.google.com with SMTP id d15-20020a0566022befb02905b2e9040807so324570ioy.11
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 13:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EWh7AfEBQS0YoU0ozxM6YG0zLIfPh1jKCDo2dTRpkEg=;
        b=mhbfxjW+RIg+ne6II3A6PwrEDrxtTNxyZK/0pfHo0mmoHAjHok52lB5OeWql96uER7
         0gD7er07IhwrRzQClRsp0OMoVttYqvnN3fAw/S6VdOtbfnM7Ycp+RqsyrXw+jIufCYA+
         NWpjrTXk9zBUleDocHQhnCoHgo5fYrJBsgi8XXroIPyuj/HB/+R5siwOAXm5pAEGp1KQ
         9rAcnuEB9mp4CDT51gVASLoZYsNxcvougn/OFRzNveVYOSLBg5RP/2JF1/QRaobwn/RA
         tuWy1E13K3K+q23taiD3rvQN1a+o5Darzyry5BUZq8zEqLXqAQoU7F9h8lihFXgj/cws
         FZvw==
X-Gm-Message-State: AOAM530VDd0s4mwdn1FWCjwvvFd4/kNSDba2AA8aBPbDof4GqXtxkbJ+
        Dt0eV1YSTfLIkX4F6x0dQ7eLtS6W/iJ4o8pirpqKrAWZaRP3
X-Google-Smtp-Source: ABdhPJwOUbXzdVuZamlU8JUgZs2HfIvAlCoqH12e74cXJ2LTAYqEbCSZM1HArKzLR9OZLN9gND0th90s0Dlew3QZhebdaxqmULp4
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d11:: with SMTP id q17mr1179827jaj.63.1630527314101;
 Wed, 01 Sep 2021 13:15:14 -0700 (PDT)
Date:   Wed, 01 Sep 2021 13:15:14 -0700
In-Reply-To: <ba030947-6463-9a0f-7ce1-cd712ef9c1aa@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005a8dc805caf4b92e@google.com>
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in xfrm_get_default
From:   syzbot <syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com>
To:     antony.antony@secunet.com, christian.langrock@secunet.com,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paskripkin@gmail.com, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

arch/x86/kernel/setup.c:916:6: error: implicit declaration of function 'acpi_mps_check' [-Werror=implicit-function-declaration]
arch/x86/kernel/setup.c:1110:2: error: implicit declaration of function 'acpi_table_upgrade' [-Werror=implicit-function-declaration]
arch/x86/kernel/setup.c:1112:2: error: implicit declaration of function 'acpi_boot_table_init' [-Werror=implicit-function-declaration]
arch/x86/kernel/setup.c:1120:2: error: implicit declaration of function 'early_acpi_boot_init'; did you mean 'early_cpu_init'? [-Werror=implicit-function-declaration]
arch/x86/kernel/setup.c:1162:2: error: implicit declaration of function 'acpi_boot_init' [-Werror=implicit-function-declaration]


Tested on:

commit:         9e9fb765 Merge tag 'net-next-5.15' of git://git.kernel..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git master
dashboard link: https://syzkaller.appspot.com/bug?extid=b2be9dd8ca6f6c73ee2d
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14a2a34d300000

