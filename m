Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A210F201DE4
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgFSWNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:13:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:52270 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbgFSWND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 18:13:03 -0400
Received: by mail-io1-f72.google.com with SMTP id p8so7822500ios.19
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 15:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=bDQBVe7l2yqt3mB06iVMiMUl/d4DebrpwMmTezaCnl8=;
        b=h/AtoAv6rCL2dQjKT9fXU0tWwfMGbNp2btZNU5/dVljrEXyYxNiD6a9pSJFGNoR7hk
         HJQI2mMWUcm/YLi1Y67JnSSHgakuS3VbqS/nz97CGNnMZUbHrf5+WQ94Re5HZqyFZJSE
         IRm3WWR1AD1hDakeYkL7dRdZjaPHlzLkHZJwOkUjtRZziVZybUBz06hyeoGX8A6v0i1Z
         o7zk8ayO80eHVXYwcu5mQmymjyVC93z56Z3SSi0X05NcAZhYGPTmS/0Begu6arh8oig8
         QmVRpYQj8tf7D6WNeLxlR32iNYgOB6VQeJ+BgphTHMYl3GsGaUm0eVNmXBFyIGcU02HY
         AteQ==
X-Gm-Message-State: AOAM533A6aMALq6owpVrrZKfiPDkrbsmTAaRyQ5CduJ1tw7qw568l8o0
        rmgzIZz910TRN/kub0gDy6QFqWriyXI24geGdLQDmF8U5wCS
X-Google-Smtp-Source: ABdhPJzjaETVaBpX1f0tHVMK3hsmWaEb1GQ3x0ua3YT2kGO5COxXB6fKHj4VZholdD5EaJS9f8p85/bf/O/linaN08vWq58XmZ7B
MIME-Version: 1.0
X-Received: by 2002:a02:cd89:: with SMTP id l9mr5712504jap.88.1592604782755;
 Fri, 19 Jun 2020 15:13:02 -0700 (PDT)
Date:   Fri, 19 Jun 2020 15:13:02 -0700
In-Reply-To: <2214469.1592604774@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005805de05a87732bf@google.com>
Subject: Re: Re: net-next test error: KASAN: use-after-free Write in afs_wake_up_async_call
From:   syzbot <syzbot+d3eccef36ddbd02713e9@syzkaller.appspotmail.com>
To:     David Howells <dhowells@redhat.com>
Cc:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git 559f5964f95ce6096ae0aa858eaee202500ab9ca

This crash does not have a reproducer. I cannot test it.

>
