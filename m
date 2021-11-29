Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7DC461B3A
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343693AbhK2Ppv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:45:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344774AbhK2Pnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 10:43:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638200433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TLn2yxIMbOGWEiPz+HJ2Hu/T2bIIpVHv8f0+EpmbgeU=;
        b=VsQY2tTiagzPPNhVcZY2doytn1ywZVmFohEoUsrX7AlmAxpv0goe5ZuInYbf5MThJP+WVw
        BsPk+zA4pkaqzJx2wLmvpk4qCvA3ndF0rrEaP5TI+AN7nrOtV9yToELRTKvVJjntufy+PY
        vovbyOr/hZ1sTfaos085mrt0S4NR7Jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-odpWg7MSOnKYUpLGG3RK5g-1; Mon, 29 Nov 2021 10:40:27 -0500
X-MC-Unique: odpWg7MSOnKYUpLGG3RK5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5247C10151E2;
        Mon, 29 Nov 2021 15:40:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A28F45D66;
        Mon, 29 Nov 2021 15:40:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <C11C128D-905C-4406-B144-F1F4ED70647C@nutanix.com>
References: <C11C128D-905C-4406-B144-F1F4ED70647C@nutanix.com> <20211125192727.74360e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <163776465314.1844202.9057900281265187616.stgit@warthog.procyon.org.uk> <2790423.1637913956@warthog.procyon.org.uk>
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Cc:     dhowells@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 29 Nov 2021 15:40:24 +0000
Message-ID: <225608.1638200424@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eiichi Tsukata <eiichi.tsukata@nutanix.com> wrote:

> Thanks, I=E2=80=99ve tested them with my environment. Looks good.

Thanks.

David

