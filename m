Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B02A185444
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 04:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCNDgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 23:36:02 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:35059 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgCNDgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 23:36:02 -0400
Received: by mail-il1-f198.google.com with SMTP id c11so2001132ilq.2
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 20:36:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dmWkzx0+VTdDKgiZu8md+VCLESddm4UQfDH67bvRGgw=;
        b=UDh4qBogCb/Mg/eJkI9SpOkX9ZcgBMxspq5qdZ6nw2BFOFy0yFNDA1pkMjvujpIe++
         BNYnNoDOyMa1HNXW5YjDQ3kqTJBTxOCyF+LYxLPoP1t4D/utMHuf7KnkCsHp1SkHldEk
         dmz5qsAz74Szfxd+aDIpL6V8LKfQfBGxBffpPweDUbyIJwk1KSqCGdKN6iCtIJTNbms+
         rNROmra6t6Hm6ouRMC7ZztwT0UjkbaguQAWCblvVFbX+M8m98psfvHKKdDGZsXGKoxQL
         YSQLXsYV9RE7IXQZYPzmNefZEiytERQBAqh+kmcuwwBJVviELG3E9fIh8BzgzoVI77ot
         2mKg==
X-Gm-Message-State: ANhLgQ31kr5plhka1CS/XWUTl9vdaQTo3SIPnXWIsmezcCPIA9Ox4xJx
        l0CIyX20Go9MMYQDYIxhIVBr6867iYVcw7GvS2tn1NjTHYis
X-Google-Smtp-Source: ADFU+vvBMXHPEVzZfO8YFe9kW6MIFkbIJ7hF8kO6rAHH2jV/E0B4uqVQ3pZEgaiV4qVxTOWqsAwD5nlb/2zaCBCJjKUTD8jHWswW
MIME-Version: 1.0
X-Received: by 2002:a02:7b13:: with SMTP id q19mr16145948jac.73.1584156961742;
 Fri, 13 Mar 2020 20:36:01 -0700 (PDT)
Date:   Fri, 13 Mar 2020 20:36:01 -0700
In-Reply-To: <CAM_iQpUBL=P6xvnyZckwVPUnmxReFDXJpfTA-ZtMqeAnh-4XVA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f9286d05a0c848b3@google.com>
Subject: Re: WARNING: ODEBUG bug in route4_change
From:   syzbot <syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger crash:

Reported-and-tested-by: syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com

Tested on:

commit:         29311b74 cls_route: remove the old filter from hashtable
git tree:       https://github.com/congwang/linux.git tcindex
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=f9b32aaacd60305d9687
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Note: testing is done by a robot and is best-effort only.
