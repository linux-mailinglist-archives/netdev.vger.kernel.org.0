Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8012CF37EA
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 20:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbfKGTFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 14:05:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30222 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727680AbfKGTFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 14:05:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573153514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HQIJqtluypUAiLIxOurLQsbk6kHNfqorjAZF+SCHp6U=;
        b=QLFBM1hiCoX7W+kiGMp3J3B4ZgNTm/LCDSWfu6uGjjP0HpzUjvwY3ETBzwWTj/JaFcwjZH
        nLTfIKfVE3nnNkPYks/M6KsvCDzhX5VVBc4iZLtaylegU4pPTJBCB2iQ/Nzm8QrE3Cwt/M
        EZXOQK9BvJi5tuEjlu+gbSGaAM0jmgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-74wKPMVCNWeteOLmiaE87w-1; Thu, 07 Nov 2019 14:05:12 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50908800C61;
        Thu,  7 Nov 2019 19:05:11 +0000 (UTC)
Received: from localhost (unknown [10.40.206.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 90B3D19481;
        Thu,  7 Nov 2019 19:05:08 +0000 (UTC)
Date:   Thu, 7 Nov 2019 20:05:06 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Martin Varghese <martinvarghesenokia@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191107200506.04242e5d@redhat.com>
In-Reply-To: <CAF=yD-K9TjhuATs2ERNsgbnDitXTBuV3yirGnwYZ26dOvo0hFA@mail.gmail.com>
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
        <20191107183136.466013d1@redhat.com>
        <CAF=yD-K9TjhuATs2ERNsgbnDitXTBuV3yirGnwYZ26dOvo0hFA@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 74wKPMVCNWeteOLmiaE87w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Nov 2019 13:59:23 -0500, Willem de Bruijn wrote:
> This still needs only one socket, right? Just fall back to inet if
> ipv6 is disabled.

What would happen if IPv6 is disabled while the tunnel is operating?

 Jiri

