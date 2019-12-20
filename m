Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004EE12800C
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbfLTPv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:51:59 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57476 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727362AbfLTPv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:51:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576857118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RNzUXdHPbC9QG5PI7iEnbaTNbG0U51Xojbeo3Jhjtz4=;
        b=R2tjS6AcOaZ19oxpbtIG49KN8wMYWrMF54fXP3Th9xnrdkT+eWZYt09Er0FHS5MA4AAf4K
        CqVyNb3yYo2Bs4tbO1veJ6wcsBdJHthKNgl7K4Wd4A4bPULAi1jUSHtOactdgQPYL9TlaN
        CxNb7wXKJSfCucFL2KAZ/85+G7QZ/To=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-lftL74DuPQiVy_45GraklA-1; Fri, 20 Dec 2019 10:51:54 -0500
X-MC-Unique: lftL74DuPQiVy_45GraklA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 154CE1005502;
        Fri, 20 Dec 2019 15:51:53 +0000 (UTC)
Received: from ovpn-116-246.ams2.redhat.com (ovpn-116-246.ams2.redhat.com [10.36.116.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E537B5DA2C;
        Fri, 20 Dec 2019 15:51:50 +0000 (UTC)
Message-ID: <581ec29dccd8d499d7cb2041218c1fcca90da29a.camel@redhat.com>
Subject: Re: [PATCH net-next v2 00/15] Multipath TCP part 2: Single subflow
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Fri, 20 Dec 2019 16:51:49 +0100
In-Reply-To: <1eb6643d-c0c1-1331-4a32-720240d4fd25@gmail.com>
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
         <20191218.124244.864160487872326152.davem@davemloft.net>
         <1eb6643d-c0c1-1331-4a32-720240d4fd25@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-12-20 at 07:03 -0800, Eric Dumazet wrote:
> 
> On 12/18/19 12:42 PM, David Miller wrote:
> > From: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > Date: Wed, 18 Dec 2019 11:54:55 -0800
> > 
> > > v1 -> v2: Rebased on latest "Multipath TCP: Prerequisites" v3 series
> > 
> > This really can't proceed in this manner.
> > 
> > Wait until one patch series is fully reviewed and integrated before
> > trying to build things on top of it, ok?
> > 
> > Nobody is going to review this second series in any reasonable manner
> > while the prerequisites are not upstream yet.
> > 
> 
> Also I want to point that for some reasons MPTCP folks provide
> patch series during the last two weeks of the year.
> 
> I don't know about you, but I try to share this time with my family.
> So this does not make me being indulgent about MPTCP :/

We are sorry if our course of action is perceived as aggressive or
worse.

The idea was to share our progress giving enough context to get a more
complete picture.

We tried to reply to the feedback in a timely manner to demonstrate
collaborative behavior and not with the goal to hard press anyone!  We
are very sorry if we gave a different impression!

We understand the time of the year is unfortunate, we have been a bit
delayed by several related an unrelated issues - idea was to post v1
just after net-next re-open.

We appreciate a lot all the feedback received, which helped improving
the code significantly.

I understand you prefer we will have the next iteration in the new
year, am I correct?

Thank you!

Paolo

