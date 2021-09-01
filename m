Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BBD3FD1E2
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 05:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241828AbhIADmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 23:42:07 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:35522 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241824AbhIADmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 23:42:06 -0400
Received: by mail-il1-f200.google.com with SMTP id x3-20020a92de03000000b0022458d4e768so975349ilm.2
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0beOg+MnIe4h9OCbsLE4S8EBVJhiyel3Re+mX7gXaLg=;
        b=AaVBGMxeEYfTYSMVOmMpKifH52xXbIZe4Biccjfh0v+gSZ6VgHBIgXGr3YwIAGxdJE
         QJ5ee9+EIhXAWGfUy53DbpFVi177PeklwbeLBL/xAVhNZyLoF19Nc/RPglfYHq4huoni
         dJg/zr2nVHjiJSDDRlqLg+sFrW8vRihs4Cn0bq0FIS3/uVGYluru7IkB5NUw/BodaY6A
         CSHgRDk5fqNDBYwTd2AbXE2NAPnSQYQSKkyhyOu6pbK5zA+lXtiwY2Zu6DwIdOM6ujgh
         BdTWbYqvJMYSmZnsjJijvMhifi9A31z6lmVW4cS01+81m3pUJvET3wFgSjmRujl7m1BE
         4gsQ==
X-Gm-Message-State: AOAM531jv4eAoRtobyarqKfpbu4nxdG1CdoopBcJjZ2fsuJqaeLqsGdW
        K0nL8fuO9fHMvJihCSh/dFLTINkHGLCtuI0uOnu//dcL8vHR
X-Google-Smtp-Source: ABdhPJwcRouK3MNpdsLyB3uITFnuOZQgmH7wdDL4dTob9ukhwMaq/IdUSJeoLsAgHDjQ4rNwFn2tcWAEE1TaClmauJO65kieMAfb
MIME-Version: 1.0
X-Received: by 2002:a05:6602:26cb:: with SMTP id g11mr25688183ioo.110.1630467670108;
 Tue, 31 Aug 2021 20:41:10 -0700 (PDT)
Date:   Tue, 31 Aug 2021 20:41:10 -0700
In-Reply-To: <20210901030636.2336-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004b732105cae6d6f1@google.com>
Subject: Re: [syzbot] WARNING: refcount bug in qrtr_node_lookup
From:   syzbot <syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, dan.carpenter@oracle.com,
        hdanton@sina.com, linux-kernel@vger.kernel.org,
        manivannan.sadhasivam@linaro.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

arch/x86/kernel/setup.c:916:6: error: implicit declaration of function 'acpi_mps_check' [-Werror,-Wimplicit-function-declaration]
arch/x86/kernel/setup.c:1110:2: error: implicit declaration of function 'acpi_table_upgrade' [-Werror,-Wimplicit-function-declaration]
arch/x86/kernel/setup.c:1112:2: error: implicit declaration of function 'acpi_boot_table_init' [-Werror,-Wimplicit-function-declaration]
arch/x86/kernel/setup.c:1120:2: error: implicit declaration of function 'early_acpi_boot_init' [-Werror,-Wimplicit-function-declaration]
arch/x86/kernel/setup.c:1162:2: error: implicit declaration of function 'acpi_boot_init' [-Werror,-Wimplicit-function-declaration]


Tested on:

commit:         9e9fb765 Merge tag 'net-next-5.15' of git://git.kernel..
git tree:       upstream
dashboard link: https://syzkaller.appspot.com/bug?extid=c613e88b3093ebf3686e
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1413e2f5300000

