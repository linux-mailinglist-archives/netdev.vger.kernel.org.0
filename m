Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D2FB72BB
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 07:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbfISFgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 01:36:23 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:38570 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbfISFgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 01:36:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5F19C20591;
        Thu, 19 Sep 2019 07:36:21 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id b2ZgNklMSnpS; Thu, 19 Sep 2019 07:36:20 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A735E2058E;
        Thu, 19 Sep 2019 07:36:20 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 07:36:20 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3FBC2318016F;
 Thu, 19 Sep 2019 07:36:20 +0200 (CEST)
Date:   Thu, 19 Sep 2019 07:36:20 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     syzbot <syzbot+f39ab8494f6015e62360@syzkaller.appspotmail.com>,
        <ast@kernel.org>, <aviadye@mellanox.com>, <borisp@mellanox.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davejwatson@fb.com>, <davem@davemloft.net>, <ilyal@mellanox.com>,
        <jakub.kicinski@netronome.com>, <john.fastabend@gmail.com>,
        <kafai@fb.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <syzkaller-bugs@googlegroups.com>,
        <yhs@fb.com>
Subject: Re: INFO: task hung in cancel_delayed_work_sync
Message-ID: <20190919053620.GG2879@gauss3.secunet.de>
References: <0000000000001348750592a8ef50@google.com>
 <20190919051545.GB666@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190919051545.GB666@sol.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 10:15:45PM -0700, Eric Biggers wrote:
> 
> Reproducer involves pcrypt, so probably the pcrypt deadlock again...
> https://lkml.kernel.org/linux-crypto/20190817054743.GE8209@sol.localdomain/

I'll submit the patch I proposed here in case noone has a better idea
how to fix this now:

https://lkml.kernel.org/linux-crypto/20190821063704.GM2879@gauss3.secunet.de/

The original patch is from you, I did some modifications to forbid
pcrypt if an underlying algorithm needs a fallback.

May I leave your 'Signed off' on this patch, or just
quote that the initial version is from you?
