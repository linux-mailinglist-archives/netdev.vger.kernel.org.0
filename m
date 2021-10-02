Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E58041FDC5
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 20:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhJBSt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 14:49:29 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:11584 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbhJBSt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 14:49:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1633200463; x=1664736463;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1yufmRtHN7r9R8GWOTbEyide2oF85zYuwpBmwCHWCSw=;
  b=t0EH4gUrDPrwvGML3yhZ++RK3qkY2Zs65oK8m5SVNDsz4DpDPP9UDmog
   NV2Htz0I7o6HpaTCTdvPRTpyBaX5StkWkB61ESMEnR91gGRP/8uxJvONO
   MMo6Fa22WZniDb/A38zlcgh1QwM4ObKtOrKjC7+wM3ZRBLTFmeqLVsWgY
   o=;
X-IronPort-AV: E=Sophos;i="5.85,342,1624320000"; 
   d="scan'208";a="144931730"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 02 Oct 2021 18:47:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-72dc3927.us-west-2.amazon.com (Postfix) with ESMTPS id EDCB2418D7;
        Sat,  2 Oct 2021 18:47:40 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 2 Oct 2021 18:47:39 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 2 Oct 2021 18:47:36 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <alx.manpages@gmail.com>
CC:     <benh@amazon.com>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-man@vger.kernel.org>, <mtk.manpages@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] unix.7: Add a description for ENFILE.
Date:   Sun, 3 Oct 2021 03:47:33 +0900
Message-ID: <20211002184733.62758-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <84a95c03-43e6-36b8-fdd3-fbb3d74dcd0e@gmail.com>
References: <84a95c03-43e6-36b8-fdd3-fbb3d74dcd0e@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.146]
X-ClientProxiedBy: EX13D27UWB001.ant.amazon.com (10.43.161.169) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Date:   Sat, 2 Oct 2021 20:12:48 +0200
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
> Patch applied!

Thank you!

Best regards,
Kuniyuki


> 
> Thanks,
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
