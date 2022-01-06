Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F337D486A1B
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242987AbiAFSqJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jan 2022 13:46:09 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:58175 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242980AbiAFSqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 13:46:07 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-ouIHAfhnP3a7LtmMPIDKUw-1; Thu, 06 Jan 2022 13:46:03 -0500
X-MC-Unique: ouIHAfhnP3a7LtmMPIDKUw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8784F102CB2A;
        Thu,  6 Jan 2022 18:46:02 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.8.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB9082E058;
        Thu,  6 Jan 2022 18:46:01 +0000 (UTC)
From:   Wen Liang <liangwen12year@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: [PATCH iproute2 v3 0/2] add json support on tc u32
Date:   Thu,  6 Jan 2022 13:45:50 -0500
Message-Id: <cover.1641493556.git.liangwen12year@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

 tc/f_u32.c | 173 +++++++++++++++++++++++++++++------------------------
 1 file changed, 96 insertions(+), 77 deletions(-)

-- 
2.26.3

