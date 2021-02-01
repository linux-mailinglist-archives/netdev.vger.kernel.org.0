Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE9830A62B
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 12:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhBALGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 06:06:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233256AbhBALGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 06:06:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612177512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+e7K9zmH1YQLSHSNSQ8EPzaF2MyiJvBlQom3QHfUjF8=;
        b=Wgf6ghfEn6e2J6G4ihtpAd5nzU7IvNpWRetgw4oyNi5vGbB/bClT9qy+Cv8gkLl+CG3L1t
        IiIJkypC/hkAZ7UgJsbf8gYXa1cqAGLzsoppXHp5y+uh8SP+7wJRtJc2yDgCDjVxCMWXiT
        a+lBOzh+w+lcu74Jwbxg9f1ByVjZKBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-kxIzar6QMFqRw1mHEy0ggQ-1; Mon, 01 Feb 2021 06:05:10 -0500
X-MC-Unique: kxIzar6QMFqRw1mHEy0ggQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BEA819251A0;
        Mon,  1 Feb 2021 11:05:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31C3F7216C;
        Mon,  1 Feb 2021 11:05:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <0000000000007b460105ba41c908@google.com>
References: <0000000000007b460105ba41c908@google.com>
To:     syzbot <syzbot+174de899852504e4a74a@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, Hillf Danton <hdanton@sina.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in rxrpc_send_data_packet
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4151791.1612177504.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 01 Feb 2021 11:05:04 +0000
Message-ID: <4151792.1612177504@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs=
.git 7ef09ba11b33e371c9a8510c1f56e40aa0862c65

