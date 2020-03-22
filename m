Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6590818E753
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 08:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgCVHSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 03:18:05 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:41505 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgCVHSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 03:18:05 -0400
Received: by mail-io1-f71.google.com with SMTP id n15so8557042iog.8
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 00:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8H+ZxvVVLEf1sn4M+jADRlnacqoZ3lSMMd7kp5U9RKI=;
        b=KPefFhCSMqVrAiq8necLdC+x6LCbTlhtfXDKz5oy5/N31q2zaEApzhxq6AekUHsQRz
         Qxa/2ZyVV93BsRXn+QING7UQ+G8ARMlh5XiFR7jXULx4yXePeSOnXfUECkyOG3d7chtv
         0sj0wH9RVSLX01pikmt3cON+zp4Rsbk+G4ZV+3UfsJtg2x+CKfIAc+tmLSLsAGJwnq1E
         qa6JaxIChkKQkdH4uZPSyRxMvOf+Vi8z2aX6FAMliBKvJat8MotWDws/WOeqU3bEoigY
         pjg4SfJSuGaTCJ50/hjmsS0YtWsdbcZPc0HKArEdaK69GgLJUETS32Lsu9HTNXLPqiUx
         bBqA==
X-Gm-Message-State: ANhLgQ2zSMCIIlnh4g1g6gwZaRz0VOZZI+IMzbL2x+IiiLIM3waQQyws
        KXF7MohStw2wjjpIC65ACaBZe5sPP38p+AfVEiPLahefrXNy
X-Google-Smtp-Source: ADFU+vvIFTtvKwJU396waC62o4+9tlw5aZYfAr7eL4DgL4YwSOJjDROpLIdkgAFOw9HEhlZhSWC/8N4NpyRvDPpo0+fwEiVh790Z
MIME-Version: 1.0
X-Received: by 2002:a92:8dc3:: with SMTP id w64mr14333976ill.68.1584861484221;
 Sun, 22 Mar 2020 00:18:04 -0700 (PDT)
Date:   Sun, 22 Mar 2020 00:18:04 -0700
In-Reply-To: <CADG63jCpZWBjtJH_rjzBjTyTfYV0z9SHf1CzT9ic0-VY5C4AiQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c909b405a16c5105@google.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
From:   syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
To:     anenbupt@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com

Tested on:

commit:         573a2520 datamsg_list
git tree:       https://github.com/hqj/hqjagain_test.git datamsg_list
kernel config:  https://syzkaller.appspot.com/x/.config?x=6dfa02302d6db985
dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Note: testing is done by a robot and is best-effort only.
