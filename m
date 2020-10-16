Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8469D290675
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 15:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408338AbgJPNmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 09:42:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408328AbgJPNmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 09:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602855743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cbJxc+II0u6UP+GUu2KXn2UU9q29Ru3OPZf8OkjfGbk=;
        b=FQLRU3rjyKgl0ds8i9fDTj/U2I2nePylrVQTfSlSio8dD4/XKAQi9rUNRYqwZSj/6fOlMw
        aw1EaJr5mZ9PNa8NoRuOBn4rEcwJ4KS1rO675Ptt08TnALFtktjy7Z0sLOK/nda/RZYZo6
        581QxWrTB8RdHcXKlwk+qmw8mqH88hU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-QGqHxhTANqSNKjJtY0fl-A-1; Fri, 16 Oct 2020 09:42:18 -0400
X-MC-Unique: QGqHxhTANqSNKjJtY0fl-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5172B18A0737;
        Fri, 16 Oct 2020 13:42:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-70.rdu2.redhat.com [10.10.120.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B75C16EF58;
        Fri, 16 Oct 2020 13:42:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000b9f2ac05b05ae349@google.com>
References: <000000000000b9f2ac05b05ae349@google.com>
To:     syzbot <syzbot+b994ecf2b023f14832c1@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net,
        hchunhui@mail.ustc.edu.cn, ja@ssi.bg, jmorris@namei.org,
        kaber@trash.net, kuznet@ms2.inr.ac.ru,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Subject: Re: WARNING: proc registration bug in afs_manage_cell
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1423870.1602855728.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 16 Oct 2020 14:42:08 +0100
Message-ID: <1423871.1602855728@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs=
.git 7530d3eb3dcf1a30750e8e7f1f88b782b96b72b8

