Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7C02D8748
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 16:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439218AbgLLPce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 10:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLLPc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 10:32:29 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8AEC0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 07:31:43 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id d17so16492854ejy.9
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 07:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=aMMyJF+8p9QPej8J5CWrzbYkiGpmhZ+n45YrKy6JUhM=;
        b=wjPCMKyWrDavbnmdu55/krszJNVEFRFwfEcaR1hxaXhPiw/cE6nBYzNBZH+XwM57IH
         R1dAqFYgS6K4LnXnVFZ3n6upg7PX6kY7JR4wWIcv8hnCFEUcbG8W64nn/FxJg/M6q0LJ
         yufLz6vM3qucJtgXMa+kZICRmxHqjplzbY3cnoKSaK2/4Sw9O+NJDSLu8QJiZ07665UV
         pvNQz8F2BjC4exKH2QF9dVyNVsL70FIQ/6/2PueoEOYwbmoJQ0VcSfbxsNPMvkudFreb
         Q/8pn73zuqiainyagWeLEk5c1+7q+94Rn6ICl75Ki883/+gl1VHVAM+4Js7V/lYDb3RI
         AgbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aMMyJF+8p9QPej8J5CWrzbYkiGpmhZ+n45YrKy6JUhM=;
        b=pCYnjiOtvrN4m1ots5/kikCzYC3LGieNi563Oq74yCVgCOfedgcB/V3gTimNDbXzfv
         0kNeck4PVutB0eiwqTgGcdNBYAxHugrOgTgLz9OEsrR2iAXdqIqUCebO6aTyLpZ7/Fbn
         C7s+qZR/Hox1spMp+YYZQq7TJ/oOLSOUFpmCZk2hFFvaVgYHM3GGv3U3Gfl5/Kn8p3ks
         IaXhQbl1D0Y6nJyBQ+1g5lqFRGcYfcYsYBkHduGOzqW37VCG62XBR9mqJ0dP3Otvkc8E
         YXDK20cCdK8uBhxr2pVgdJCLVZalOT2PYhaXZDGwcN6JbCOg1nyEv6mEqBGDBFfjmm9e
         fq+w==
X-Gm-Message-State: AOAM533TTGgmDNhZclG8P4JuCChvCj4US010YbTWFLaNgNYysjBUgIJj
        Magtakr+eaCf4fM6k9dgTfpKppZV7U9J8tTJWanFrA==
X-Google-Smtp-Source: ABdhPJyhggzsEk20gRi4OKpn78sVVGZIx/AMTRfn7B6QJpqXAL730Irnqzzjc69zTl1TKzkuTtd3ba9sFd1aNlxEJZA=
X-Received: by 2002:a17:906:1e0c:: with SMTP id g12mr15850923ejj.214.1607787102060;
 Sat, 12 Dec 2020 07:31:42 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 12 Dec 2020 15:31:30 +0000
Message-ID: <CAM1kxwgjCJwSvOtESxWwTC_qcXZEjbOSreXUQrG+bOOrPWdbqA@mail.gmail.com>
Subject: [PATCH 0/3] PROTO_CMSG_DATA_ONLY for Datagram (UDP)
To:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RE our conversation on the "[RFC 0/1] whitelisting UDP GSO and GRO
cmsgs" thread...

https://lore.kernel.org/io-uring/CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com/

here are the patches we discussed.

Victor Stewart (3):
   net/socket.c: add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
   net/ipv4/af_inet.c: add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
   net/ipv6/af_inet6.c: add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops

   net/ipv4/af_inet.c
     |   1 +
   net/ipv6/af_inet6.c
    |   1 +
   net/socket.c
       |   8 +-
   3 files changed, 7 insertions(+), 3 deletions(-)
