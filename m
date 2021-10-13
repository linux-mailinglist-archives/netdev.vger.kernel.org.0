Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903A042C146
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 15:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhJMNXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 09:23:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:57326 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbhJMNXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 09:23:54 -0400
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1maeCb-00099y-Uv; Wed, 13 Oct 2021 15:21:50 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net-next 0/3] Minor managed neighbor follow-ups
Date:   Wed, 13 Oct 2021 15:21:37 +0200
Message-Id: <20211013132140.11143-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26321/Wed Oct 13 10:21:20 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor follow-up series to address prior feedback from David and Jakub.
Patch 1 adds a build time assertion to prevent overflows when shifting
in extended flags, patch 2 is a cleanup to use NLA_POLICY_MASK instead
of open-coding invalid flags rejection and patch 3 rejects creating new
neighbors with NUD_PERMANENT & NTF_MANAGED. For details, see individual
patches. Will push out iproute2 series after that. Thanks!

Daniel Borkmann (3):
  net, neigh: Add build-time assertion to avoid neigh->flags overflow
  net, neigh: Use NLA_POLICY_MASK helper for NDA_FLAGS_EXT attribute
  net, neigh: Reject creating NUD_PERMANENT with NTF_MANAGED entries

 net/core/neighbour.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

-- 
2.27.0

