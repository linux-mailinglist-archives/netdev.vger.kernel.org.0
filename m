Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455D3201DBC
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgFSWEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:04:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24444 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728731AbgFSWEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 18:04:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592604252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I79nPb0pXt8/3dgBW2qv/EZDlPMjoeNKQYFohhTmzfU=;
        b=ZNKt9skdz1BarAoYIBy8rM+O1mvGeiVRiXZvse93B7psq9pRGWW2dsvFQUDHkZRSYymc/4
        Dj125476m2WU7wAPUV36UWVK2eqAuCtJVhIXyVgFTfuj9MYjZZiU6lqrwGHLenewfhJNwB
        kghg/fqMyRbWiQnODzPzHD98o+3jFDg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-eGOpVFd0NVKlaCyOXDIiqw-1; Fri, 19 Jun 2020 18:04:11 -0400
X-MC-Unique: eGOpVFd0NVKlaCyOXDIiqw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D008464;
        Fri, 19 Jun 2020 22:04:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-114-66.rdu2.redhat.com [10.10.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2DFD5EE0E;
        Fri, 19 Jun 2020 22:04:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <0000000000006fc0b705a85afe83@google.com>
References: <0000000000006fc0b705a85afe83@google.com>
To:     syzbot <syzbot+39eaecb9eee28d41da93@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: bpf-next test error: KASAN: use-after-free Write in afs_wake_up_async_call
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2213226.1592604246.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 19 Jun 2020 23:04:07 +0100
Message-ID: <2213227.1592604247@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz dup: net-next test error: KASAN: use-after-free Write in afs_wake_up_=
async_call

