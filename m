Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4CD482563
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 18:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhLaRWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 12:22:49 -0500
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:59815 "EHLO ofcsgdbm.dwd.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhLaRWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Dec 2021 12:22:49 -0500
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn4.dwd.de (Postfix) with ESMTP id 4JQX5g1z2Dz3xjP
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 17:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dwd.de; h=
        content-type:content-type:mime-version:references:message-id
        :in-reply-to:subject:subject:from:from:date:date:received
        :received:received:received:received:received:received:received;
         s=dwd-csg20210107; t=1640971367; x=1642180968; bh=/E3Nf3b5/7q1g
        28Y+5mQdMAMVH4upffmo9Df5OkJJ0M=; b=WXdnI+d3C86JDftvzV8NjEqV1zTTh
        IfOGdLg6nnofF0J5C2gwKbKLq6LVoBZOzRjkLxWbfryGnt5nzZNB5S2iKSniwEKK
        0x+5//jUPSN+gcKlT+NRhho1Ed1QcAahMLkfBKMooF8J/dO23LS5D+KtQBlGTq2B
        gUBq+JZJdFgwCEywQIXdInQgI1zLYu0Hx+3NabNnRtd2K8sv2rbZglY0QTWI7gx8
        U2QQfQ8SGwZr2MfKW7X9r4TEtwC4gDL8o+ZJF07iQQw6oeCuiMN/IJobO+E2uyma
        S4BqsHPo0nydCLQtahSzrKApZXJ+XggHcRuJmI/cKao4xAcyRCC9ShcBA==
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2ctev2.dwd.de ([172.30.232.68])
        by localhost (ofcsg2dn4.dwd.de [172.30.232.27]) (amavisd-new, port 10024)
        with ESMTP id jcXzgfMusncx for <netdev@vger.kernel.org>;
        Fri, 31 Dec 2021 17:22:47 +0000 (UTC)
Received: from ofcsg2ctev2.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 1442D5E11C1
        for <root@ofcsg2dn4.dwd.de>; Fri, 31 Dec 2021 17:22:47 +0000 (UTC)
Received: from ofcsg2ctev2.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 026885E11AD
        for <root@ofcsg2dn4.dwd.de>; Fri, 31 Dec 2021 17:22:47 +0000 (UTC)
X-DDEI-TLS-USAGE: Unused
Received: from ofcsgdbm.dwd.de (unknown [172.30.232.27])
        by ofcsg2ctev2.dwd.de (Postfix) with ESMTP
        for <root@ofcsg2dn4.dwd.de>; Fri, 31 Dec 2021 17:22:46 +0000 (UTC)
Received: from ofcsgdbm.dwd.de by localhost (Postfix XFORWARD proxy);
 Fri, 31 Dec 2021 17:22:47 -0000
Received: from ofcsg2dvf1.dwd.de (ofcsg2dvf1.dwd.de [172.30.232.10])
        by ofcsg2dn4.dwd.de (Postfix) with ESMTPS id 4JQX5f6bp5z3xjM;
        Fri, 31 Dec 2021 17:22:46 +0000 (UTC)
Received: from ofmailhub.dwd.de (ofmailhub.dwd.de [141.38.39.208])
        by ofcsg2dvf1.dwd.de  with ESMTP id 1BVHMk4V012222-1BVHMk4W012222;
        Fri, 31 Dec 2021 17:22:46 GMT
Received: from diagnostix.dwd.de (diagnostix.dwd.de [141.38.44.45])
        by ofmailhub.dwd.de (Postfix) with ESMTP id A0D2645283;
        Fri, 31 Dec 2021 17:22:46 +0000 (UTC)
Date:   Fri, 31 Dec 2021 17:22:46 +0000 (GMT)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: bpfilter: write fail messages with 5.15.x and centos 7.9.2009
 (fwd)
In-Reply-To: <CAADnVQJ5MxGkq=ng214aYoH-NmZ1gjoS=ZTY1eU-Fag4RwZjdg@mail.gmail.com>
Message-ID: <b91d87a-2e74-70ce-8a87-1b596717c7e3@diagnostix.dwd.de>
References: <a12e914c-4be1-85d9-5242-34855f9eeac@diagnostix.dwd.de> <CAADnVQJ5MxGkq=ng214aYoH-NmZ1gjoS=ZTY1eU-Fag4RwZjdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-FE-Policy-ID: 2:2:1:SYSTEM
X-TMASE-Version: DDEI-5.1-8.6.1018-26626.001
X-TMASE-Result: 10--3.248400-10.000000
X-TMASE-MatchedRID: lORh06tOiKjmLzc6AOD8DfHkpkyUphL9wJ63yQFkSDahvH9IigX45syg
        Al+yObRO6C9j1zI13BBVdMFscFLE5WcyGVjSWZt/jrVn4cme+w59LQinZ4QefHXA+T8YcZkDiCF
        ykZQ+I/rkwjHXXC/4I7I7zVffJqTz2J5XpNMiCocBjz25oa8FcDRicvt9EIGoauYOzFUmv3C843
        Z7+YZfIQnoQr0aJHnc0egPf++T1T/YdbOkPFfd3QbC42epSz89
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-DDEI-PROCESSED-RESULT: Safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Dec 2021, Alexei Starovoitov wrote:

> On Fri, Dec 31, 2021 at 1:23 AM Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>>
>> Hello,
>>
>> hope I am now sending it to the correct list.
>>
>> Please, what else can I do to solve this?
>
> Turn that kconfig off. It shouldn't be used in production kernels.
>
Correct. This is what I did when I noticed it was not used at all.

Many thanks!

Holger
