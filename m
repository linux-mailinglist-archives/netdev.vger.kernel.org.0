Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4704330FC
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhJSI0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:26:24 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:56318 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234537AbhJSI0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:26:23 -0400
Received: by mail-il1-f198.google.com with SMTP id o8-20020a056e02068800b0025999dab84fso3458237ils.22
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 01:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6W80Ea/xPGSCAMfuK5dcuPBivclSSvzM+U5pUl++MiE=;
        b=dTq21Sak2/C6crYir3LxD62vrJdVBGDFhwhYknT+j7xPe5cf4qWdRhEdq9D48ADNlp
         uNlfdoAt3+MtPcS05nWRgtnQR8cuUGmhckjoidXVlRwTlz+1lcsJ2sX3Diuodo8BjGUn
         HG+P0CSp/7utla/2T4bm8Y1qOeJiMVjJK7qTU5j4Ke+vVIuPjSnwUSM6UtLH0bMUEzrC
         YfZYF3U+JggsqhEtWgRsMycVyUDwnQvmvUeQcSRNlKuYfkCUGdHRo0bc1nilchfA0vng
         6dOLJ8Aoitge+zyuLAIWScJqU/Pj6zfVSNugXWTqOY5FNvDRHdQsf+knFD1uLtWuG+Z3
         9hZg==
X-Gm-Message-State: AOAM532g1KD6WlVmHSZou+6KuY1GZP/p2pPepMPqeo53nxs8dGKewNDY
        w3rMogi7oGJWul7d3haGMZY0gW3Jd1Iiz7lhhHa9jJKqPI6X
X-Google-Smtp-Source: ABdhPJwTWw7CirGaDkx43so3ouzOe1EA6jOJe4S6hO3mcpQ+BQRZ+SUutV2pg/tqViZW+8JikQFCB9sB0I+HV5rjmZSY8B3qmJh4
MIME-Version: 1.0
X-Received: by 2002:a5e:9612:: with SMTP id a18mr17350653ioq.57.1634631851240;
 Tue, 19 Oct 2021 01:24:11 -0700 (PDT)
Date:   Tue, 19 Oct 2021 01:24:11 -0700
In-Reply-To: <c5a75b9b-bc2b-2bd8-f57c-833e6ca4c192@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d4f64205ceb06259@google.com>
Subject: Re: [syzbot] divide error in usbnet_start_xmit
From:   syzbot <syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file drivers/net/usb/usbnet.c
patch: **** unexpected end of file in patch



Tested on:

commit:         c03fb16b Merge 5.15-rc6 into usb-next
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
dashboard link: https://syzkaller.appspot.com/bug?extid=76bb1d34ffa0adc03baa
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1149aaf0b00000

