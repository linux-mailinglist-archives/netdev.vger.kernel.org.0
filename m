Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A3943E50D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJ1P1p convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 Oct 2021 11:27:45 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:49231 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230017AbhJ1P1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 11:27:45 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-tbYX1gkQMAOIOUMfXCVygw-1; Thu, 28 Oct 2021 11:25:13 -0400
X-MC-Unique: tbYX1gkQMAOIOUMfXCVygw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FF6E8066F5;
        Thu, 28 Oct 2021 15:25:12 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.16.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B7A660843;
        Thu, 28 Oct 2021 15:25:08 +0000 (UTC)
From:   Wen Liang <liangwen12year@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, aclaudi@redhat.com
Subject: [PATCH iproute2 v2 0/2] add json support on tc u32
Date:   Thu, 28 Oct 2021 11:25:00 -0400
Message-Id: <cover.1635434027.git.liangwen12year@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

 tc/f_u32.c | 152 ++++++++++++++++++++++++++---------------------------
 1 file changed, 76 insertions(+), 76 deletions(-)

-- 
2.26.3

