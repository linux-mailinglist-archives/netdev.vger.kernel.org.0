Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8F8B11EC
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 17:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbfILPRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 11:17:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:40026 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732835AbfILPRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 11:17:02 -0400
Received: by mail-io1-f69.google.com with SMTP id l9so33413514ioj.7
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 08:17:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=RPiyZVry3vcCdktPjsrAehjjz4bpmZ6S8izbMfh4+Qw=;
        b=Q9ovsMOH31u3IsXH+GM71T7VZc7iYC74j2DLiDYoSyrxc0/B+8r9ioQnXbxgt+Nalv
         ForcZIsceojp8TaEHFrzBnGYgv18zv6FuQQtPWhB+vXbVix+fBxcNkDNEG8pziPXcCtg
         GYG0yy6X7lXYGnOf1VjuBbILMwfo2/2HZCjGJOtijVlVhe1+PyQOfSlNSa9UyCtF+bUA
         c4HLLxkzY1m8n2/9EWSfscMYyPloc8ruQtg4cCeBS0u3e2ODsdOAq+d2D7a72puLUH+j
         GwOYjUQhDl6ppw4qGJaRBI/mbpu/wkWw0CLdrLpw193q8Tuxl5uwVFJ2KS/nztCcTQW0
         qpYw==
X-Gm-Message-State: APjAAAVu3+9PCsWgckX1nJ/HFnKZ/mPhNNgPsY9HT29BRMs1nxl3FNxP
        RtkI6ZW8y/XnVqKTpv1c2hzaRMeCXXG+DQmszH1nfPx8ai/s
X-Google-Smtp-Source: APXvYqzSR03YPSVhMgY8omiNzjtKp/LsOhihqJynqTinJuXFm9yeiEQpDpPKj8OnPE+PaoUQpZvFmlFn8e22sLT7FtGXZct/f2eo
MIME-Version: 1.0
X-Received: by 2002:a02:aa84:: with SMTP id u4mr23912052jai.14.1568301421376;
 Thu, 12 Sep 2019 08:17:01 -0700 (PDT)
Date:   Thu, 12 Sep 2019 08:17:01 -0700
In-Reply-To: <CAKK_rchVQCYmjPSxk9MszV9BtF8y04-j2dpjV0Jg3c+nrRNEWQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001f3a3a05925ca177@google.com>
Subject: Re: memory leak in ppp_write
From:   syzbot <syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, jeliantsurux@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, paulus@samba.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail.com

Tested on:

commit:         6525771f Merge tag 'arc-5.3-rc7' of git://git.kernel.org/p..
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=e6131eafb9408877
dashboard link: https://syzkaller.appspot.com/bug?extid=d9c8bf24e56416d7ce2c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12610ef1600000

Note: testing is done by a robot and is best-effort only.
