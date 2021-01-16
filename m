Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4D82F8D01
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 11:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbhAPKpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 05:45:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbhAPKpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 05:45:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610793864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=+Y0Xj399Rzv5eZQdey8dpfuEebgTVvxEKp+NUUMhBME=;
        b=eQ7medPoZRKpsfBBu5QK+M8CM46wuAwknVJxxOnRagpEm/ShDwKva9FkBDg4oaazs7/Ndx
        ErrPwRVW3nzZH9DBy9VB5MV7uNBjHfm3Iwm8f0ChLpfVhtzHyB8Ukyf3XTDqKFb3nW2lwB
        J/W9k8EgBBhM41RUh5eVuPMC20y2YcM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-9uuapIFjMBmpt3INZJBQGw-1; Sat, 16 Jan 2021 05:44:23 -0500
X-MC-Unique: 9uuapIFjMBmpt3INZJBQGw-1
Received: by mail-wr1-f70.google.com with SMTP id j5so5428157wro.12
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 02:44:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=+Y0Xj399Rzv5eZQdey8dpfuEebgTVvxEKp+NUUMhBME=;
        b=KMJXufwbzz82zRB7FhJzMwQPKFxs9fp06OKCiuTINlFw1cSyUVHs13wquvM2YGlHyZ
         8hfqF9s72GDm1x/J2dxlmKmJQZhBzAa06PH+/j6adEPCXo3cfDDlbKXz7npEIBrFDHcz
         SUsHzOhq2Fv1C1qDtdrAeZL5QWzpfQ+NmajzJdh8DJM1Y1n5HbpNuWJ3JIcQaqP9c3XC
         hNH0SwLy0NC02Ii5kS8Md/rjlk0zPkKr+vgH7cmLshIV/JDCXqJnkQkjlXmwkYXX74lq
         /JUqgpH6E0i03z+pWUvotgpAf8CKeLeKHaQ9aMn7Q50ohq8mUBNWRl/vPM5r15RGvERE
         z74A==
X-Gm-Message-State: AOAM533R+nmdqn5iAeHqzONp91/7lydCQc8UFirqmCF6OyWn+BhV7CTU
        7iqxEnMmlz3XcE6YkmsRTHLN9tVoEwnRFEsIjwviMyZSV4+MwxMwaVTWFUYKPS+LPvxxHpThEJ+
        M4jhIf0QB7tnxG9+H
X-Received: by 2002:a1c:40d6:: with SMTP id n205mr12924990wma.0.1610793861798;
        Sat, 16 Jan 2021 02:44:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxxGlYqNYAm8VEm9052Bj8vSbihxcupBb8ZhnZbvxiwFUez6OF+JvqmXjFAK8CQ5Gho5Z1xaQ==
X-Received: by 2002:a1c:40d6:: with SMTP id n205mr12924979wma.0.1610793861624;
        Sat, 16 Jan 2021 02:44:21 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id w8sm18210410wrl.91.2021.01.16.02.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 02:44:20 -0800 (PST)
Date:   Sat, 16 Jan 2021 11:44:18 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [PATCH net 0/2] ipv4: Ensure ECN bits don't influence source address
 validation
Message-ID: <cover.1610790904.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions that end up calling fib_table_lookup() should clear the ECN
bits from the TOS, otherwise ECT(0) and ECT(1) packets can be treated
differently.

Most functions already clear the ECN bits, but there are a few cases
where this is not done. This series only fixes the ones related to
source address validation.

Guillaume Nault (2):
  udp: mask TOS bits in udp_v4_early_demux()
  netfilter: rpfilter: mask ecn bits before fib lookup

 net/ipv4/netfilter/ipt_rpfilter.c | 2 +-
 net/ipv4/udp.c                    | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.21.3

