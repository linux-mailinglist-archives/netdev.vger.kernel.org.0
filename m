Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A687297372
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750315AbgJWQUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:20:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750279AbgJWQTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 12:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603469985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=9EGrxKtjQ9ilV8o4tlp69vDV7/fso4Ay+SJaaWwWPeg=;
        b=AslGKHJN9PvSmZPPuVrYwn5rXwHlQRSpLzdMZsim7FZMZx6pMICF4yQsDOKin7LPtoLFa8
        eBdytti1EcHSAnpb9FlbG1ChQxD/wyupeleJ2UVOaPXHm6wBTvkUA92NDy7o7p0fLK5Zl9
        +9nqkVUSfBykNnjr+41ctfvpKixEixo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-aaFx9VWmMhaaNdU342SbGA-1; Fri, 23 Oct 2020 12:19:43 -0400
X-MC-Unique: aaFx9VWmMhaaNdU342SbGA-1
Received: by mail-wr1-f69.google.com with SMTP id j15so757481wrd.16
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=9EGrxKtjQ9ilV8o4tlp69vDV7/fso4Ay+SJaaWwWPeg=;
        b=gU9qoawjIi+aBPo/WmbRzZVanyE7pBYEP5wYVtw6babduw4bDmLhjq3MfKjxoCGip9
         U1z0WRxrWL6lsszqfy/PxcsERvTDGQP6UmnPqd4wVqC+jshjeB+uC64Bj/XOLwQIHtgk
         rfJ+8HgAbRMSWDxeGMxINmhQVUdY8k1R/+28C+Rht0N6Ll3wrhxwoXabxXN7YiCOly7F
         pt2tIKKK2vT7lNG2o4qk/oNQTxEBQX+DlCai8TXi3mCiKBlB3spHYuql/sGMTjsKKfIF
         TNWxMD2Y/OxkMsc8jXaSEz5cftwgrylFY11rcT7Njy4qK4KodkrpTOB1zWx+zXtLiAC1
         BaLw==
X-Gm-Message-State: AOAM531njNff6AJg1FT9VFreqmdWEn5E7L3IaeX4cktBYQaOjGwTN+EO
        9193GLOxHuiZzgvXKvDC3V1M/XJRoRTNpBMZsEXhGy8+LP1tgsqAyqUzLTex7Tni6OZesfJ5wGj
        pr4OkseztsceXQCZr
X-Received: by 2002:a5d:49cc:: with SMTP id t12mr3693886wrs.342.1603469982097;
        Fri, 23 Oct 2020 09:19:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJys3dJfaIby5+r5nJU84dm/ESZVvwxMEA+vGiZ9gtIphJV0LSyqrG6AN8FhP3KC+0s/7xdOww==
X-Received: by 2002:a5d:49cc:: with SMTP id t12mr3693859wrs.342.1603469981795;
        Fri, 23 Oct 2020 09:19:41 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id y5sm4130996wrw.52.2020.10.23.09.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 09:19:41 -0700 (PDT)
Date:   Fri, 23 Oct 2020 18:19:39 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 0/2] mpls: fix dependencies on mpls_gso.ko
Message-ID: <cover.1603469145.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit b7c24497baea ("mpls: load mpls_gso after mpls_iptunnel"),
mpls_iptunnel tries to load mpls_gso. Therefore, we need to build
mpls_gso when mpls_iptunnel is selected (patch 1).

There's also the act_mpls module that can push MPLS headers on GSO
packets. This module also depends on mpls_gso (patch 2).

Guillaume Nault (2):
  mpls: Make MPLS_IPTUNNEL select NET_MPLS_GSO
  net/sched: act_mpls: Add softdep on mpls_gso.ko

 net/mpls/Kconfig     | 1 +
 net/sched/Kconfig    | 2 ++
 net/sched/act_mpls.c | 1 +
 3 files changed, 4 insertions(+)

-- 
2.21.3

