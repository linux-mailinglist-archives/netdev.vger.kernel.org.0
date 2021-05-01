Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF163707EE
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhEAQpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:45:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhEAQpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 12:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619887466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XoXXZO+05wocBr+Gbu0Dfu/XBqnPK1FAnPUdBXeJJVg=;
        b=PTacjnKQamNmWGk9WfTDOxnnM8vafPtA4pqQ9+iycXRaIpj0iyCZgUINU9H7qFWr0CHxo3
        TaEtMpdfT4Xun78uLQLOWHxXJSB5SLwyE3zHWZB/OtTWmvzVCwKm03SnxWQPIbdAiFz6yP
        Bwsa5cNSnM9/QVruHeVdMOCeP4PSLec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-Ai-kHAHkNhqxM-EBpx0xwg-1; Sat, 01 May 2021 12:44:25 -0400
X-MC-Unique: Ai-kHAHkNhqxM-EBpx0xwg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 303031898297;
        Sat,  1 May 2021 16:44:24 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D4C660BE5;
        Sat,  1 May 2021 16:44:23 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 0/2] dcb: some misc fixes
Date:   Sat,  1 May 2021 18:39:21 +0200
Message-Id: <cover.1619886883.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes two issues on dcb code:
- patch 1 fixes an incorrect return value in dcb_cmd_app_show() if an
  incorrect argument is provided;
- patch 2 is a trivial fix for a memory leak when "dcb help" is
  executed.

Andrea Claudi (2):
  dcb: fix return value on dcb_cmd_app_show
  dcb: fix memory leak

 dcb/dcb.c     | 3 ++-
 dcb/dcb_app.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.30.2

