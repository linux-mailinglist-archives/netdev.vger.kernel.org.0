Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D4CF1B38
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 17:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732178AbfKFQbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 11:31:01 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:51847 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731931AbfKFQbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 11:31:01 -0500
Received: by mail-io1-f69.google.com with SMTP id v14so4117751iob.18
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 08:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8qQR7ifchLtVQScswn65dfk7elFvbbBsPLx89EZOqFY=;
        b=ZTSlffZjuYmCdSOQTGqABAgHIL5L4g380bXcxfpfKk7mhqLhLfsuzTVQx6QBNlzury
         +6AF8MCYC6IKkb3yqkCWJZnDQroeiV0NOyUo/qLumg7+ABnn20BmAAmO7RopZwaredr1
         ZhBT6QvdLwnjeYobs5Ww2MnGRaeFUIEo8o10IfYhS3w19mUC7qCF4rn9fSCINwl6tHCO
         rUzEvMuVOHbgpdltT/ZDiQ0kFPr+YXUFqAjw7rQppoQGaInwCThgegPNTSMHBfpzhAkk
         QrlN1Av2UvReZN589m8pFwvYaHb1WD+MeSxVJLSbv4cIMP6lyA7uHQK2mGtxM+37TrmE
         Hoew==
X-Gm-Message-State: APjAAAXDDFd1za3I0YjPek5zfaNsRVV66CZCMshOHw6OnuU0IEw2EptR
        LJ+Z2bsFPh2o/j/veZ7SCpiUDKxDAkocaOi7wPvmoT53Lpb9
X-Google-Smtp-Source: APXvYqzJaos90vJCHlJEG2ocpHVHhe/sc8GDCraGflaO/sINZTNc8yyil2i7O1XFj/ujTG84Wa7yw3ahjIzw2P2jJiFrwRJnnD9F
MIME-Version: 1.0
X-Received: by 2002:a6b:ee02:: with SMTP id i2mr6283904ioh.153.1573057860375;
 Wed, 06 Nov 2019 08:31:00 -0800 (PST)
Date:   Wed, 06 Nov 2019 08:31:00 -0800
In-Reply-To: <1573043012.3090.24.camel@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fa9f850596b01212@google.com>
Subject: Re: KMSAN: uninit-value in cdc_ncm_set_dgram_size
From:   syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com>
To:     netdev@vger.kernel.org, oneukum@suse.com,
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
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11599e8ae00000

Note: testing is done by a robot and is best-effort only.
