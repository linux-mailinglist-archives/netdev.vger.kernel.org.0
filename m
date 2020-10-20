Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF98293F0E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 16:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408443AbgJTOyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 10:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408426AbgJTOyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 10:54:40 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95169C061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 07:54:38 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id n16so1053001pgv.13
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 07:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ZF+EPh4dHYV3F67YcPJQkl8a21uNLnwmlsVSxeCiSt4=;
        b=gmWjKkmPG0WTFdAinAImgOenz60Y2koECIdlmVqDBliIGoCml2+ByYb4h+RdNvSoE1
         8qsaia6BGnpmN73kIT/JMz9aNshWaqkEB9zlpHAblKW1nN3+WgxCFh/VwLZMpmdwgNfb
         GovCeN7rHSGNks6/p7R5fjPLX6q0RCnfScPpzLpCJtEXxIt9ZsetimTze2AlURuaKE99
         0B3cStN4IKykBEr0ROE58LL3j83+7eDET5qxQ+58zhV+5EIkkwLqryTka7hHW7qJr3cn
         AAPoZzkIXjbQBV5yXTHFsq+51oIC9358cfT5NHUhPgzkQSw6nhA75nFCGSQ0dTLrz/+s
         NXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ZF+EPh4dHYV3F67YcPJQkl8a21uNLnwmlsVSxeCiSt4=;
        b=YC4R0/WyHhQbgYhjrp8F8rcbWlUBBvA4dXcueulprtLobErdNyzBSjQH+1F3oGLLpb
         bqxu/9QApKFQgdwK6Pjq08GcjRqhQFbNGLrriZN/TBY4CgITrR71vZlb9M96EBgJiSQ0
         BwrzNBVT5Y4BacXo3gVdUCzdPbPUQqpDBEueQIah44DE1+1Sq9NbRygiYA0CV0pxWsfr
         X4NTOz2cPU0l/dq63ndAHvIHp3op5uUfSxzSmo+9YId7pZT9kByfkg83afwRBmH3wol4
         h8m/eoJ7FsEbIFXoJxGH212SC46Y9dZl9OyDRDgnSw44kcYz3gN3Woho9ZTzkNCZoiY2
         9eUw==
X-Gm-Message-State: AOAM533MUrCNZeejNOIkvcB3zTmF8+Z5Jv7VQFul8OfTfcruCV78U79N
        LaDjLZjOjYxN9jQGAh4r50Z1J3Uq9TKz9Q==
X-Google-Smtp-Source: ABdhPJwCMKIxBUcilmbJm74eHOPvIsFqZ7a4kABEFqjseB9PIdf/+JvQEeFgpgUHAT/43WsuATIGRA==
X-Received: by 2002:a62:6c5:0:b029:158:d0b1:b283 with SMTP id 188-20020a6206c50000b0290158d0b1b283mr2969074pfg.79.1603205677475;
        Tue, 20 Oct 2020 07:54:37 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id lb13sm2033209pjb.5.2020.10.20.07.54.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 07:54:37 -0700 (PDT)
Date:   Tue, 20 Oct 2020 07:54:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 209767] New: Bonding 802.3ad layer2+3 transmits on both
 slaves within single connection
Message-ID: <20201020075429.291c34bb@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 20 Oct 2020 10:42:34 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 209767] New: Bonding 802.3ad layer2+3 transmits on both slaves within single connection


https://bugzilla.kernel.org/show_bug.cgi?id=209767

            Bug ID: 209767
           Summary: Bonding 802.3ad layer2+3 transmits on both slaves
                    within single connection
           Product: Networking
           Version: 2.5
    Kernel Version: 5.8.11-1.el8.elrepo.x86_64 and
                    3.10.0-1127.19.1.el7.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: onno.zweers@surf.nl
        Regression: No

Dear people,

I'm seeing bonding behavior I don't understand and neither do several network
experts I've consulted.

We have two servers, both with two 25 Gbit interfaces in a bond (802.3ad with
layer2+3 hashing). We tuned the systems according to
https://fasterdata.es.net/host-tuning/linux/. I run `iperf3 --server` on server
1 and connect to it with `iperf3 --client server1` from server 2. We notice
that sometimes the connection is good (24.7 Gbit/s, no retransmits) and
sometimes there are many retransmits (sometimes as many as >30,000 in a 10
second run) and then the bandwidth may drop to 15 Gbit/s or even lower. The
servers are idle except for the iperf3 runs. When we bring down one slave on
server 1, the result is always perfect; no retransmits and good throughput.

We have captured traffic with tcpdump on server 1 at the slave level (I'll try
to add the pcap files). To our surprise, we see that the data channel ACK
packets are sometimes sent over one slave and sometimes over the other. We
think this causes packet misordering in the network switches, and thus
retransmits and loss of bandwidth.

Our understanding of layer2+3 hashing is that for a single connection, all
traffic should go over the same slave. Therefore, we don't understand why
server 1 sends ACK packets out over both slaves.

I've read the documentation at
https://www.kernel.org/doc/Documentation/networking/bonding.txt but I couldn't
find the observed behaviour explained there.

We have tested several Centos 7 and Centos 8 kernels, including recent elrepo
kernels, but all show this behaviour. We have tried teaming instead of bonding
but it has the same behaviour. We have tried other hashing algorithms like
layer3+4 but they seem to have the same issue. It occurs with both IPv4 and
IPv6.

Is this behaviour to be expected? If yes, is it documented anywhere? Will it
degrade throughput in real life traffic (with multiple concurrent data
streams)?
If the behaviour is not expected, are we doing something wrong, or might it be
a bug?

Thanks,
Onno

-- 
You are receiving this mail because:
You are the assignee for the bug.
