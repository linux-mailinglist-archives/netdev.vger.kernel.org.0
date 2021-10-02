Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C3C41FD86
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 19:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhJBR6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 13:58:54 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:14691 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbhJBR6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 13:58:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1633197428; x=1664733428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qYC8+r3qWGM8s+Oe5mJfYpPsI3uuOhdL16fRYsSmiiw=;
  b=f1Rmx/8UXLxGoC8Y7J75N+AOt3HkukAahUFBt9JHn23nctYT9Sh/hHwj
   KFLmkh/zWow4oy75hktBDS7hWO7W3EnvLQx9bDqulNv3bH8vNdawjKjU0
   d6kd6kju4WjuXCpDuDKIOMkDfgKhTZR4m1Xy4tTP23bykJKtNCEAVun//
   U=;
X-IronPort-AV: E=Sophos;i="5.85,342,1624320000"; 
   d="scan'208";a="31378107"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 02 Oct 2021 17:57:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id 43D4241FD0;
        Sat,  2 Oct 2021 17:57:07 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 2 Oct 2021 17:57:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.89) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 2 Oct 2021 17:56:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <alx.manpages@gmail.com>
CC:     <benh@amazon.com>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-man@vger.kernel.org>, <mtk.manpages@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] unix.7: Add a description for ENFILE.
Date:   Sun, 3 Oct 2021 02:56:53 +0900
Message-ID: <20211002175653.58027-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <206a26e5-0515-44b9-39cb-bc46013bfc6c@gmail.com>
References: <206a26e5-0515-44b9-39cb-bc46013bfc6c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.89]
X-ClientProxiedBy: EX13D27UWB003.ant.amazon.com (10.43.161.195) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Date:   Sat, 2 Oct 2021 19:44:52 +0200
> Hello Kuniyuki,
> 
> On 9/29/21 3:38 AM, Kuniyuki Iwashima wrote:
> > When creating UNIX domain sockets, the kernel used to return -ENOMEM on
> > error where it should return -ENFILE.  The behaviour has been wrong since
> > 2.2.4 and fixed in the recent commit f4bd73b5a950 ("af_unix: Return errno
> > instead of NULL in unix_create1().").
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> > Note to maintainers of man-pages, the commit is merged in the net tree [0]
> > but not in the Linus' tree yet.
> > 
> > [0]: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=f4bd73b5a950
> 
> Thanks!
> 
> The patch looks good to me, so could you ping back when this is merged 
> in Linus's tree?

Thanks, sure!
Is that -stable?
The pull-request from net-next hit the Linus' 5.14-rc4 tree few days ago.
https://lore.kernel.org/linux-kernel/20210930163002.4159171-1-kuba@kernel.org/
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4de593fb965fc2bd11a0b767e0c65ff43540a6e4

Best regards,
Kuniyuki


> 
> Cheers,
> 
> Alex
> 
> > ---
> >   man7/unix.7 | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/man7/unix.7 b/man7/unix.7
> > index 6d30b25cd..2dc96fea1 100644
> > --- a/man7/unix.7
> > +++ b/man7/unix.7
> > @@ -721,6 +721,9 @@ invalid state for the applied operation.
> >   called on an already connected socket or a target address was
> >   specified on a connected socket.
> >   .TP
> > +.B ENFILE
> > +The system-wide limit on the total number of open files has been reached.
> > +.TP
> >   .B ENOENT
> >   The pathname in the remote address specified to
> >   .BR connect (2)
> > 
> 
> 
> -- 
> Alejandro Colomar
> Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
> http://www.alejandro-colomar.es/
