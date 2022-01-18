Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB044919A5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345622AbiARCzW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Jan 2022 21:55:22 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:55885 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347653AbiARCma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:42:30 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-VVAdah2gOfGnYIN9tIjptg-1; Mon, 17 Jan 2022 21:42:26 -0500
X-MC-Unique: VVAdah2gOfGnYIN9tIjptg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12C1F83DD24;
        Tue, 18 Jan 2022 02:42:25 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.32.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 678BB6AB85;
        Tue, 18 Jan 2022 02:42:24 +0000 (UTC)
From:   Wen Liang <liangwen12year@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: [PATCH iproute2 v4 0/2] add json support on tc u32
Date:   Mon, 17 Jan 2022 21:42:19 -0500
Message-Id: <cover.1642472827.git.wenliang@redhat.com>
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

From: Wen Liang <wenliang@redhat.com>

This adds support for json output on tc u32.
- The first patch is replacing with proper json functions in `u32_print_opt()`
- The second patch is fixing the json support in u32 `print_raw()`, `print_ipv4()`
  and `print_ipv6()`

The patches were tested with jq parser.

Wen Liang (2):
  tc: u32: add support for json output
  tc: u32: add json support in `print_raw`, `print_ipv4`, `print_ipv6`

 tc/f_u32.c | 197 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 119 insertions(+), 78 deletions(-)

-- 
2.26.3

