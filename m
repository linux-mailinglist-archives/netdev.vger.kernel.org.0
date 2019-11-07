Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85490F35BD
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbfKGRbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:31:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26938 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbfKGRbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:31:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573147904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZPiNW8AdtRaaZOWwSLWIVB9FHIEa2J8TCeWkGqtAxMA=;
        b=AUKI4bPI2WuIwY5fEoFvjfAXIVEJz42PdxOJ9wjpZz8Wi4r9++P0UIdq+M0F16lkBk0Ibz
        owhaNLAYa8PBjjPQV2IUFofG9nKK4oh93DQoDM3bjr8bR+J58X0YpbFJsn3RVydP80qLii
        5xAqcigLMrcqaQGZl4ZEV+uJtCDxVNA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-zIY8uxfrODynvlEP3Zf58Q-1; Thu, 07 Nov 2019 12:31:41 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C0AF8017DD;
        Thu,  7 Nov 2019 17:31:39 +0000 (UTC)
Received: from localhost (unknown [10.40.206.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E6A4319481;
        Thu,  7 Nov 2019 17:31:37 +0000 (UTC)
Date:   Thu, 7 Nov 2019 18:31:36 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Martin Varghese <martinvarghesenokia@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191107183136.466013d1@redhat.com>
In-Reply-To: <CAF=yD-JeCV-AW2HO9inJt-yePUrBGQ9=M58fYr8f2CDHdNNpaA@mail.gmail.com>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
        <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
        <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
        <20191017132029.GA9982@martin-VirtualBox>
        <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
        <20191018082029.GA11876@martin-VirtualBox>
        <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
        <20191107133819.GA10201@martin-VirtualBox>
        <CAF=yD-JX=juqj2yrpZ6MjksLDqF8JVjTsruu2yVh5aXL6rou5g@mail.gmail.com>
        <20191107161238.GA10727@martin-VirtualBox>
        <CAF=yD-JeCV-AW2HO9inJt-yePUrBGQ9=M58fYr8f2CDHdNNpaA@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: zIY8uxfrODynvlEP3Zf58Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Nov 2019 11:35:07 -0500, Willem de Bruijn wrote:
> If the bareudp device binds to a specific port on all local addresses,
> which I think it's doing judging from what it passes to udp_sock_create
> (but I may very well be missing something), then in6addr_any alone will
> suffice to receive both v6 and v4 packets.

This will not work when IPv6 is disabled, either by the kernel config
or administratively. We do need to have two sockets.

 Jiri

