Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C306475BF2
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243990AbhLOPik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243796AbhLOPij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:38:39 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44A7C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:38:39 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id o4so20988039pfp.13
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=RxEgC4qIi78vTEJJPJ+qSJ7RHA7Xw6V1Vy/24qNT8ko=;
        b=x4gOLiYn0CTMwd/xrKXnjn0dUp5KcV00BQSfRsQzYtJlDv5QV3HvhEWq+WibYgiRPS
         wLdOJ0gf/cHeEWUiIfPxXAy8hWUPlojnZJWig5DfBtH9upWKMy/fikyWodFw9oKmWT2Y
         Kk1BiAaJ6BgqGCSaOweoYHT9oLCFyrSSQWx0QU+ml1zbq7gD6RV/TdjFbeVndkhF29Wl
         c38+6kbdIsU+9tST9dKMChYfKXZzy0BXCQMtncx7pswe1yTQv1ht0/6IcnF9b8HGkXrf
         L50KZOrGdSv8h0rjR3+oVHySfk/BfFK/Hd9aDgDzZvBA74awLlFz5hlV37RvITJvWEGL
         C8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=RxEgC4qIi78vTEJJPJ+qSJ7RHA7Xw6V1Vy/24qNT8ko=;
        b=AFhKvZEFRG3LIyNBD/KXQFxys15QKrd9nhdek/dB34psMZ7bhZO6gNqJN+0/JPXdxM
         zoOqYykqCyWAY75EYQpns55WUZNoZ0qQ/EFb4gBiZs9vUMCgCRsdtHViBpmyEDX1/b6x
         WVVEQP0bGhRFETyfi3QxXaMEDAkxxFnTL7pAnRpoAf5g76lt9RRsk7sjinjiQsvZx2sh
         s7Q95Wlek+hUUGc/3qE5j+Vi14mWu4tSbSsYUV/RMDkvlsRHGWFMeNq2HO6VucgaVcmJ
         hqcgTWn0QHJ40Y4jdE+zrR2izJdJQk95u7xvnfrKWiW6QOOGmw3howwTuJ38r76Bok3X
         GC0A==
X-Gm-Message-State: AOAM532HP2xzIubi7C+7Tb5TFL+EM2ylqOAtLJHpOzCO0SEQ1ZIEqskw
        pNWOHAuLbPl5aQmUI9M6AmLM56HTbrUPvw==
X-Google-Smtp-Source: ABdhPJzsTWhok6X8hhzie6CUEQPZv2nEka2eVg+PXuNbwe26g1BrdvRJ5Vgz3G2lNqOkrY3s5PAqpg==
X-Received: by 2002:a63:e801:: with SMTP id s1mr8268006pgh.543.1639582719177;
        Wed, 15 Dec 2021 07:38:39 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id mi18sm2806650pjb.13.2021.12.15.07.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 07:38:38 -0800 (PST)
Date:   Wed, 15 Dec 2021 07:38:36 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     sgarzare@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 215329] New: The vsock component triggers out of memory
 when sending small packets.
Message-ID: <20211215073807.30c0041d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 15 Dec 2021 03:40:59 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215329] New: The vsock component triggers out of memory when =
sending small packets.


https://bugzilla.kernel.org/show_bug.cgi?id=3D215329

            Bug ID: 215329
           Summary: The vsock component triggers out of memory when
                    sending small packets.
           Product: Networking
           Version: 2.5
    Kernel Version: 4.19.90
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: kircherlike@outlook.com
        Regression: No

The memory usage of the vsock component when sending small packets is much
higher than that when sending large packets. When the VM memory is
insufficient, the out of memory is triggered.

Server=EF=BC=88host=EF=BC=89=EF=BC=9Aiperf3 --vsock -s 2
Client=EF=BC=88guest=EF=BC=89=EF=BC=9Aiperf3 --vsock -c 2 -t 10000 -l 1 -P =
100

Slab information of kernel kmalloc in the 1 KB data packet is sent. The val=
ues
of kmalloc-256 and kmalloc-4096 are significantly higher than those in the
normal environment.

Traffic sending environment:
kmalloc-8192 68 68 8192 4 8 : tunables 0 0 0 : slabdata 17 17 0
kmalloc-4096 1186 1224 4096 8 8 : tunables 0 0 0 : slabdata 153 153 0
kmalloc-2048 965 992 2048 16 8 : tunables 0 0 0 : slabdata 62 62 0
kmalloc-1024 967 1040 1024 16 4 : tunables 0 0 0 : slabdata 65 65 0
kmalloc-512 1120 1120 512 16 2 : tunables 0 0 0 : slabdata 70 70 0
kmalloc-256 19644992 19644992 256 16 1 : tunables 0 0 0 : slabdata 1227812
1227812 0
kmalloc-128 760027 762656 128 32 1 : tunables 0 0 0 : slabdata 23833 23833 0

Normal environment:
kmalloc-8192 68 68 8192 4 8 : tunables 0 0 0 : slabdata 17 17 0
kmalloc-4096 1248 1248 4096 8 8 : tunables 0 0 0 : slabdata 156 156 0
kmalloc-2048 1008 1040 2048 16 8 : tunables 0 0 0 : slabdata 65 65 0
kmalloc-1024 948 960 1024 16 4 : tunables 0 0 0 : slabdata 60 60 0
kmalloc-512 1072 1072 512 16 2 : tunables 0 0 0 : slabdata 67 67 0
kmalloc-256 3199 3264 256 16 1 : tunables 0 0 0 : slabdata 204 204 0
kmalloc-128 761575 762080 128 32 1 : tunables 0 0 0 : slabdata 23815 23815 0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
