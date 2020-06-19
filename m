Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368DF201DE3
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgFSWNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:13:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23236 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728705AbgFSWNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 18:13:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592604780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2+FgfKVWJ0OmMYlV9X2tHyMUlSlq4J73WMXUePK2hM=;
        b=YW97kTMaqwaHuvLt+QYJHsX/OL1OT8PEkYvnWeLwjv9IHgumsh1TvTaR1eMQHMzeJx2dPM
        0BlRG48Ed3SsHrjyyh5HJm+9tP5YpcokvVLgdDRBsv4fLKZA73fTU12iBi2vh84LunzHUI
        b5XnFGmIagic1PST+sLMf/5VUq2z53A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-BBau2pmlPCC1Al3-ZfRkBg-1; Fri, 19 Jun 2020 18:12:58 -0400
X-MC-Unique: BBau2pmlPCC1Al3-ZfRkBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1B50107ACCA;
        Fri, 19 Jun 2020 22:12:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E27B19C4F;
        Fri, 19 Jun 2020 22:12:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <0000000000009111c005a845c2bc@google.com>
References: <0000000000009111c005a845c2bc@google.com>
To:     syzbot <syzbot+d3eccef36ddbd02713e9@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: net-next test error: KASAN: use-after-free Write in afs_wake_up_async_call
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2214468.1592604774.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 19 Jun 2020 23:12:54 +0100
Message-ID: <2214469.1592604774@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs=
.git 559f5964f95ce6096ae0aa858eaee202500ab9ca

