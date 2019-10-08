Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9221CFAFB
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 15:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730848AbfJHNLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 09:11:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730439AbfJHNLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 09:11:09 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CFD9D30832E9;
        Tue,  8 Oct 2019 13:11:09 +0000 (UTC)
Received: from griffin.upir.cz (ovpn-204-214.brq.redhat.com [10.40.204.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 215831001956;
        Tue,  8 Oct 2019 13:11:08 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf 0/2] selftests/bpf: fix false failures
Date:   Tue,  8 Oct 2019 15:10:43 +0200
Message-Id: <cover.1570539863.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 08 Oct 2019 13:11:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test_flow_dissector and test_lwt_ip_encap selftests were failing for me.
It was caused by the tests not being enough system/distro independent.

Jiri Benc (2):
  selftests/bpf: set rp_filter in test_flow_dissector
  selftests/bpf: more compatible nc options in test_lwt_ip_encap

 tools/testing/selftests/bpf/test_flow_dissector.sh | 3 +++
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

-- 
2.18.1

