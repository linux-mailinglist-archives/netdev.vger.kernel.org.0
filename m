Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFCF3C2297
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 13:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhGILNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 07:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhGILNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 07:13:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D563061206;
        Fri,  9 Jul 2021 11:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625829047;
        bh=SVgriyeFWdjQ15TjzhSzoQsASOWuvYO30wIKTiQXGms=;
        h=From:To:Cc:Subject:Date:From;
        b=Bv7zWQW0OLYQBEbHQ6BRhValx4liGXw9FxXPWL7ShDelDUJeEQyrev/DRzBMwTGx9
         1Lz3Ul2Ta+TWuhPY9t66ZeEI7xY2bpFF6Y4TRt7mWNc1gLcOEw4pmb/LswDOiVvrqq
         to3dhUukTuvUdhi+F1Y6aRhLYg+VcOrdjv/p6ue0ZzJh9xTjOUaxydkGmBAoiPVCGA
         qvIMbRZ8t3MJag8lmbKRSxjYj7d6gd04reutbB923kX6WO9xAiRihhHWLuJ3xyHOgk
         B6VkdRKfml8k8tzqderdVTM1UdVXjvKR5kB8lYhtCS767pN/3Z9mswFxgxnoSVBzwP
         81pcgZNC+bRSQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, alexander.duyck@gmail.com, brouer@redhat.com,
        echaudro@redhat.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH bpf-next 0/2] Add xdp_update_skb_shared_info utility routine
Date:   Fri,  9 Jul 2021 13:10:26 +0200
Message-Id: <cover.1625828537.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_update_skb_shared_info routine to update frags array metadata
from a given xdp_buffer/xdp_frame.
Add xdp_frags_tsize field to skb_shared_info.

Lorenzo Bianconi (2):
  net: skbuff: add xdp_frags_tsize field to skb_shared_info
  net: xdp: add xdp_update_skb_shared_info utility routine

 drivers/net/ethernet/marvell/mvneta.c | 29 +++++++++++++++------------
 include/linux/skbuff.h                |  2 ++
 include/net/xdp.h                     |  3 +++
 net/core/xdp.c                        | 27 +++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 13 deletions(-)

-- 
2.31.1

