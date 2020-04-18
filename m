Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A32D1AF315
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 20:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgDRSLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 14:11:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34214 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbgDRSLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 14:11:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587233462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4MjBHhLWma7Wyo6Y0oaah6/D7fXV7EHmjvl18i27sII=;
        b=fmR27FWL2yLBFrSVJnhvzPFRJwD4ItzBNr6CtBjHA581JHeZypyZpFXr3TxTYPTLAX4oaU
        edStjPyFqd4ryz41FGuZ99C4JGFrQgU5is4SY+F14U+f1OljhHmHhQBDjCT+6OZNwvRX8R
        75u2l9M+DKCVXZLcduJQStJGaZWoKQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-VnSCfK7uOTK_mHQ6IZsLpQ-1; Sat, 18 Apr 2020 14:10:58 -0400
X-MC-Unique: VnSCfK7uOTK_mHQ6IZsLpQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BD3D1005510;
        Sat, 18 Apr 2020 18:10:57 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-112-5.ams2.redhat.com [10.36.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BEF660C05;
        Sat, 18 Apr 2020 18:10:54 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: What's a good default TTL for DNS keys in the kernel
References: <3865908.1586874010@warthog.procyon.org.uk>
        <CAH2r5mv5p=WJQu2SbTn53FeTsXyN6ke_CgEjVARQ3fX8QAtK_w@mail.gmail.com>
Date:   Sat, 18 Apr 2020 20:10:53 +0200
In-Reply-To: <CAH2r5mv5p=WJQu2SbTn53FeTsXyN6ke_CgEjVARQ3fX8QAtK_w@mail.gmail.com>
        (Steve French's message of "Fri, 17 Apr 2020 18:23:53 -0500")
Message-ID: <87a738aclu.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Steve French:

>>> The question remains what the expected impact of TTL expiry is.  Will
>>> the kernel just perform a new DNS query if it needs one?
>
> For SMB3/CIFS mounts, Paulo added support last year for automatic
> reconnect if the IP address of the server changes.  It also is helpful
> when DFS (global name space) addresses change.

Do you have reference to the source code implementation?  Thanks.

Florian

