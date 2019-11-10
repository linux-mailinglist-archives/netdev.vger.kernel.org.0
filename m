Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B51F6A0B
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfKJQNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:13:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44916 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726800AbfKJQNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 11:13:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573402385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DeEcU+OUUfGi87zoTUrvCIzzna0OpY7ziEHJ67ao9MU=;
        b=ImqkK+W1bAEUAmLt1FwDzdWBIzqaiCciMnmzM1SxaIxwFWWYs8+NenuGZKaNsXmLQ9ZJoy
        wstK8bElb7ENUtaPl7i2YmwPxR2WYbcHmsA9fklzCUpqT7oGAqRmB5jlGxGMjyp2LGWyjA
        w9WAzpTI3NCvpOL7Ac+EzmKezv1Lnj4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-P3xD4WhOPhSbi5Kaiyvc0A-1; Sun, 10 Nov 2019 11:13:02 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F8FD107ACC5;
        Sun, 10 Nov 2019 16:13:00 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACDCD6106B;
        Sun, 10 Nov 2019 16:12:54 +0000 (UTC)
Date:   Sun, 10 Nov 2019 17:12:53 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: net --> net-next merge
Message-ID: <20191110171253.63098254@carbon>
In-Reply-To: <20191109.122917.550362329016169460.davem@davemloft.net>
References: <20191109.122917.550362329016169460.davem@davemloft.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: P3xD4WhOPhSbi5Kaiyvc0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 09 Nov 2019 12:29:17 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> Please double check my conflict resoltuion for samples/bpf/Makefile

Looks okay[1] -- I have a patch doing exactly the same adjustment to
Bj=C3=B8rns patch which conflicted with Ivan's patch 10cb3d8706db
("samples/bpf: Use own flags but not HOSTCFLAGS").

[1] https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/diff=
/samples/bpf/Makefile?id=3D14684b93019a2d2ece0df5acaf921924541b928d

Thanks for merging these, as the fixes for samples/bpf/ now seems to
have reached your tree.  I'll send a followup to fix the rest and also
adjust/correct the documentation in samples/bpf/README.rst.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

