Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF38040222D
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 04:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242419AbhIGB7J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Sep 2021 21:59:09 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:53339 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242279AbhIGB7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 21:59:07 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-6muEHAsuPVKA6ZDUPAS_3A-1; Mon, 06 Sep 2021 21:57:58 -0400
X-MC-Unique: 6muEHAsuPVKA6ZDUPAS_3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6314E8C8962;
        Tue,  7 Sep 2021 01:57:57 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.8.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D78B45C1CF;
        Tue,  7 Sep 2021 01:57:56 +0000 (UTC)
From:   Wen Liang <liangwen12year@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: [PATCH iproute2 0/2] add json support on tc u32
Date:   Mon,  6 Sep 2021 21:57:49 -0400
Message-Id: <cover.1630978600.git.liangwen12year@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=liangwen12year@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for json output on tc u32.
- The first patch is replacing with proper json functions in `u32_print_opt()`
- The second patch is fixing the json support in u32 `print_raw()`, `print_ipv4()`
  and `print_ipv6()`

Wen Liang (2):
  tc: u32: add support for json output
  tc: u32: add json support in `print_raw`, `print_ipv4`, `print_ipv6`

 tc/f_u32.c | 138 ++++++++++++++++++++++++-----------------------------
 1 file changed, 62 insertions(+), 76 deletions(-)

-- 
2.26.3

