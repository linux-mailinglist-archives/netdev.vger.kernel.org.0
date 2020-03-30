Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF0319806A
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbgC3QDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:03:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:56110 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729973AbgC3QDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:03:38 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIwsz-000742-At; Mon, 30 Mar 2020 18:03:37 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     jannh@google.com, yhs@fb.com, john.fastabend@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 0/3] Fix __reg_bound_offset32 handling
Date:   Mon, 30 Mar 2020 18:03:21 +0200
Message-Id: <20200330160324.15259-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25767/Mon Mar 30 15:08:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix for the verifier's __reg_bound_offset32() handling, please see individual
patches for details.

Thanks!

Daniel Borkmann (1):
  bpf: Undo incorrect __reg_bound_offset32 handling

Jann Horn (2):
  bpf: Fix tnum constraints for 32-bit comparisons
  bpf: Simplify reg_set_min_max_inv handling

 kernel/bpf/verifier.c | 227 +++++++++++++++++-------------------------
 1 file changed, 90 insertions(+), 137 deletions(-)

-- 
2.20.1

