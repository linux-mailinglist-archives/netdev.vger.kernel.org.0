Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223F93BE479
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 10:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhGGIgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 04:36:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhGGIgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 04:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625646815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gsCgBjZOBNs8GkUNl/mNs2MJS9/AFWcuZUWnlsWxVR0=;
        b=C6QgBlCyZUUpelWGhLrAdj0BZ/7N9vSBzNf8vgYT00N8UtnelS2fL0qj2PkwCpF0gxN/jo
        zyXrNkMxaAYDymCkzmcerEhOMmuW6Ck/G93tWrdka1pgOu+PzxqIdvco7BAZaD2N1uSTm5
        4vKYQ+Xq98O3P5GEM9zPyHmqWrH1Hnc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-Vyof4_7NMwGm3fArqWxeYw-1; Wed, 07 Jul 2021 04:33:34 -0400
X-MC-Unique: Vyof4_7NMwGm3fArqWxeYw-1
Received: by mail-io1-f72.google.com with SMTP id d9-20020a0566023289b02904f58bb90366so1150261ioz.14
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 01:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gsCgBjZOBNs8GkUNl/mNs2MJS9/AFWcuZUWnlsWxVR0=;
        b=CTTl8FmZYmF5fL6IYl4l0eAfCe5brfWQhbDQtUfzin0J518yKoqRvq5XHY4Pb9xszu
         IrDRCCrkPcRaFr3woAaA0uAyTocyAsYnMAn21NvefiXT7NGgIW3Y2svcYUsNC0mdUeNs
         IQ3EhUFCzVUdBfJqxrWRxDSCUwJV0/Dxh1GYcqEO6rdAviTs6nas8r4lhbEaEN3APzk7
         Ulgo4u/9QFNQIVQaOQKhuvjtIGlLZxriAkV/uk9V0H2q54V2LuYhFbdoAtqNWS+qpH6W
         Y7ws6o0c5MveYM/XphRsbggHeOCA83DKS2ICmdcuwU4zFS+pzGC9roPLjqDK/RcCMn/n
         4shg==
X-Gm-Message-State: AOAM532tAtIQrqSmBHDRHIe/kWHlbdy75eHiHTrlh44f+R14qvSEAD/O
        VpWndPJrXdK/rV6/S08TGGZLRDUarpU8PQsa3ZTnl2wolATcaqDL1oGH8ZpaFtFIYGKfZzex8gf
        vGVGWomuRl8KY5pI9vuZCpzjxph+vS9TD
X-Received: by 2002:a05:6e02:921:: with SMTP id o1mr18424295ilt.57.1625646813915;
        Wed, 07 Jul 2021 01:33:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjADIFFE8x66m44Qg1NdRzaMJgQ7eb1Hz+C+bh0cFgtAJbVgNwE4FSxW0Kh29twnqMKUFm/lNIaXceqGkzzWQ=
X-Received: by 2002:a05:6e02:921:: with SMTP id o1mr18424282ilt.57.1625646813772;
 Wed, 07 Jul 2021 01:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <202107070458.FO35EqwU-lkp@intel.com>
In-Reply-To: <202107070458.FO35EqwU-lkp@intel.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 7 Jul 2021 10:33:22 +0200
Message-ID: <CACT4ouf-v+G7oCAFRqZWYQUqs8o1GdSKRbqJwjjP_cNuPFKvgA@mail.gmail.com>
Subject: Re: drivers/net/ethernet/chelsio/cxgb4/sge.c:2571 cxgb4_ethofld_send_flowc()
 warn: missing error code 'ret'
To:     Dan Carpenter <dan.carpenter@oracle.com>, rajur@chelsio.com
Cc:     kbuild@lists.01.org, lkp@intel.com, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 9:37 AM Dan Carpenter <dan.carpenter@oracle.com> wro=
te:
> 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2564     if (tc !=3D FW_SC=
HED_CLS_NONE) {
> 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2565             if (eosw_=
txq->state !=3D CXGB4_EO_STATE_CLOSED)
> 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05  2566            =
         goto out_free_skb;
>                                                                         ^=
^^^^^^^^^^^^^^^^
>
> Are these error paths?
>
> 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2567
> 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2568             next_stat=
e =3D CXGB4_EO_STATE_FLOWC_OPEN_SEND;
> 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2569     } else {
> 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2570             if (eosw_=
txq->state !=3D CXGB4_EO_STATE_ACTIVE)
> 52bfcdd87e83d9 =C3=8D=C3=B1igo Huguet        2021-05-05 @2571            =
         goto out_free_skb;
>
> Here too
>
> 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2572
> 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2573             next_stat=
e =3D CXGB4_EO_STATE_FLOWC_CLOSE_SEND;
> 0e395b3cb1fb82 Rahul Lakkireddy    2019-11-07  2574     }

I'm not really sure, I just added the skb release in the exit path to
fix a memory leak.

I think it might not be an error path in this case, maybe just no
actions must be done in this specific cases. CCing Raju Rangoju from
Chelsio to see if he can confirm.

--=20
=C3=8D=C3=B1igo Huguet

