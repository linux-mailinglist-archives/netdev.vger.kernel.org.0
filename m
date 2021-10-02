Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D0741FD40
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 18:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhJBQp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 12:45:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233657AbhJBQpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 12:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633193018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OBOU+LwanABEYWLJd4zWYKL1SL4UtRmo0M/vuP2yuQI=;
        b=LFax5Vgu9CImaT4t5mv/1PbUCak3bLYaahSSAmBffALGNgCGAQb4vViAWOYX2GW7HUjpnX
        EmxY1FSHb4xvsUiFqPFDoUQIcBaKr5vkd6B/zY30771+3qXV7JRcN5ZHzzy9G1FVI1K46v
        pv9PPsFs+PUkJvHLe8hej77tK+qtiHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-JlkWcIAsMFO8L1oQ3riLQw-1; Sat, 02 Oct 2021 12:43:35 -0400
X-MC-Unique: JlkWcIAsMFO8L1oQ3riLQw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA0831006AA2;
        Sat,  2 Oct 2021 16:43:34 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FB065D740;
        Sat,  2 Oct 2021 16:43:33 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: [PATCH 0/2 iproute2] configure: add support for libdir param
Date:   Sat,  2 Oct 2021 18:41:19 +0200
Message-Id: <cover.1633191885.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add support for the libdir parameter in iproute2 configure
system. The idea is to make use of the fact that packaging systems may
assume that 'configure' comes from autotools allowing a syntax similar
to the autotools one, and using it to tell iproute2 where the distro
expects to find its lib files.

The first patch introduce support for the --param=value style on current
params, for uniformity.

The second patch add support for the libdir param to the configure, and
also drops the static LIBDIR var from the Makefile.

Andrea Claudi (2):
  configure: support --param=value style
  configure: add the --libdir param

 Makefile  |  7 ++++---
 configure | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 3 deletions(-)

-- 
2.31.1

