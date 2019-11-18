Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE1741001C3
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 10:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfKRJvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 04:51:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23873 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726898AbfKRJvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 04:51:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574070713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RnkPtrtkzLDiLhVBi6u0mh9f/xmCiH2CgLmKPX7+Qck=;
        b=CGsYHzzMuFeH+Oos5sMyuRwV+i5qpYGqMKrK8wo7GB+IYl094ZmDIs2fRtSDJZ2LXgMzLT
        A5TL4WH7dFtXY33iyuwz7iq2D7Ma0dqgsybnMmQCHKdIxiNSWrvQHUPOejsT8H8NM7Yk32
        egm1fgovSrPB79yKXJ8OwZYzlH+8FvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-tlNJaAxFMeuMcg0GwrRpbQ-1; Mon, 18 Nov 2019 04:51:49 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5120107ACCC;
        Mon, 18 Nov 2019 09:51:47 +0000 (UTC)
Received: from localhost (ovpn-204-195.brq.redhat.com [10.40.204.195])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A7BEC2934D;
        Mon, 18 Nov 2019 09:51:46 +0000 (UTC)
Date:   Mon, 18 Nov 2019 10:51:45 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH bpf] selftests: bpf: fix test_tc_tunnel hanging
Message-ID: <20191118105145.3e576745@redhat.com>
In-Reply-To: <CAF=yD-K53UaChX7S6YzNaCTArYf3RVWGPdskeEd5bEaBfuaonQ@mail.gmail.com>
References: <60919291657a9ee89c708d8aababc28ebe1420be.1573821780.git.jbenc@redhat.com>
        <dc889f46-bc26-df21-bf24-906a6ccf7a12@iogearbox.net>
        <CAF=yD-K53UaChX7S6YzNaCTArYf3RVWGPdskeEd5bEaBfuaonQ@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: tlNJaAxFMeuMcg0GwrRpbQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 17:05:42 -0500, Willem de Bruijn wrote:
> Ah, a typo. This is the SHA1 in my tree, note the aa9d --> aa99d
>=20
> $ git fetch davem-net-next
> $ git log -1 --oneline -- tools/testing/selftests/bpf/test_tc_tunnel.sh
> f6ad6accaa99d selftests/bpf: expand test_tc_tunnel with SIT encap

Indeed, it should have been:

Fixes: f6ad6accaa99 ("selftests/bpf: expand test_tc_tunnel with SIT encap")

Not sure how that happened, I'm sorry for that. Thanks for catching it.
Should I resend with the fixed commit message?

Sorry again,

 Jiri

