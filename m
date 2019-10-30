Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85EDE9A44
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 11:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfJ3Knf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 06:43:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60876 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726032AbfJ3Kne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 06:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572432213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9x7ntI7HCmn9LgIoBNAX9wfx9Pj1JvnYX+E7dNtiHvc=;
        b=ItPkNHv/W38h/ClXNci2VIDxnINcKl6WjAhMt6Y+TihwMYY+aj5gPsXhtID/MPUBF2653S
        UPHicHcKF5LdXGX/GXSQFHJtGIDHUCAun2gSmjE1OvR7z2rdo9v9t5t5vZ9wkkA8yxf5Yi
        QsvAfSH5BbLvsj2DjD7b1vZ9NpMXwU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-oMWDKTT_MbqBsSZ8pGLobw-1; Wed, 30 Oct 2019 06:43:30 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73C1B2E9F;
        Wed, 30 Oct 2019 10:43:28 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C09B5D6D6;
        Wed, 30 Oct 2019 10:43:15 +0000 (UTC)
Date:   Wed, 30 Oct 2019 11:43:13 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>
Cc:     brouer@redhat.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Sage <eric@sage.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Compile build issues with samples/bpf/ again
Message-ID: <20191030114313.75b3a886@carbon>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: oMWDKTT_MbqBsSZ8pGLobw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maintainers,

It is annoy to experience that simply building kernel tree samples/bpf/
is broken as often as it is.  Right now, build is broken in both DaveM
net.git and bpf.git.  ACME have some build fixes queued from Bj=C3=B6rn
T=C3=B6pel. But even with those fixes, build (for samples/bpf/task_fd_query=
_user.c)
are still broken, as reported by Eric Sage (15 Oct), which I have a fix for=
.

Could maintainers add building samples/bpf/ to their build test scripts?
(make headers_install && make M=3Dsamples/bpf)

Also I discovered, the command to build have also recently changed:
- Before : make samples/bpf/   or  simply make in subdir samples/bpf/
- new cmd: make M=3Dsamples/bpf  and in subdir is broken

Anyone knows what commit introduced this change?
(I need it for a fixes tag, when updating README.rst doc)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

