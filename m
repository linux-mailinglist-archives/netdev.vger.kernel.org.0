Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545952740AE
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIVLW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgIVLW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 07:22:59 -0400
Received: from mail.kernel.org (ip5f5ad5bc.dynamic.kabel-deutschland.de [95.90.213.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E4162399A;
        Tue, 22 Sep 2020 11:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600773778;
        bh=BXOV2/wMUecYDuk+Af/OccQnwb4IQj2Pi9tGe6aNU2k=;
        h=From:To:Cc:Subject:Date:From;
        b=vFvk7ZwMV6SNdK/3/D+GYOTYKMsfFwsEDIpY1YZWRtuwIjGgoM01CI+twtVBrkE1o
         ImTeDXXYTEEAdCBHATt7CH8ZrUNKFR7nR+ipw45ihTn14l6sTrLZNtKds8OZBLMzxD
         SuWdjRDzeBW3XbNWO76zax0qQH/EZxjmRrWby0nc=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kKgNr-0010Ke-Kx; Tue, 22 Sep 2020 13:22:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Lyude Paul <lyude@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org
Subject: [PATCH 0/3] Fix Kernel-doc warnings introduced on next-20200921
Date:   Tue, 22 Sep 2020 13:22:51 +0200
Message-Id: <cover.1600773619.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few new warnings were added at linux-next. Address them, in order for us
to keep zero warnings at the docs.

The entire patchset fixing all kernel-doc warnings is at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=doc-fixes

Mauro Carvalho Chehab (3):
  net: fix a new kernel-doc warning at dev.c
  drm/dp: fix kernel-doc warnings at drm_dp_helper.c
  drm/dp: fix a kernel-doc issue at drm_edid.c

 drivers/gpu/drm/drm_dp_helper.c | 5 +++++
 drivers/gpu/drm/drm_edid.c      | 2 +-
 net/core/dev.c                  | 4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.26.2


