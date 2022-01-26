Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0774349D2AA
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244519AbiAZTpd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Jan 2022 14:45:33 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:29835 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244510AbiAZTpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:45:33 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-suniphRsPI-elaOtzC5liQ-1; Wed, 26 Jan 2022 14:45:26 -0500
X-MC-Unique: suniphRsPI-elaOtzC5liQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2825344BB;
        Wed, 26 Jan 2022 19:45:25 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.16.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21B55519A1;
        Wed, 26 Jan 2022 19:44:51 +0000 (UTC)
From:   Wen Liang <liangwen12year@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: [PATCH iproute2 v5 0/2] add json support on tc u32
Date:   Wed, 26 Jan 2022 14:44:46 -0500
Message-Id: <cover.1643225596.git.liangwen12year@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

The patches were tested with jq parser.

Wen Liang (2):
  tc: u32: add support for json output
  tc: u32: add json support in `print_raw`, `print_ipv4`, `print_ipv6`

 tc/f_u32.c | 204 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 125 insertions(+), 79 deletions(-)

-- 
2.26.3

