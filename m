Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEAC524FC9
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355199AbiELOSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355200AbiELOSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:18:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF57D7A46C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 07:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652365083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/Y3mN2KfwVbaAJlVgox5bIBKjWXIWldD3blAaTSgulk=;
        b=BS9NgC/eVj5hdw1XNyCxxH9ZLF1KlaHj4nLlDJg3noVxezJ/g4ktXnSZjooyaibBoQMpg0
        xZ6p6bnfXNdvLZd34JRB2atMxY826tkVi9fyOolb4nHoY89Qpi7ekLcsB6fpN6h6qub6LB
        2mC7iyTGDm1OORIK+qI5lcXNIRM5qBY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-zGQycxa4O6uHty7-mwQMPA-1; Thu, 12 May 2022 10:18:01 -0400
X-MC-Unique: zGQycxa4O6uHty7-mwQMPA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D325A3C322EA;
        Thu, 12 May 2022 14:18:00 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BF635744FD;
        Thu, 12 May 2022 14:17:59 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH RESEND iproute2 0/3] Fix some typos in doc and man pages
Date:   Thu, 12 May 2022 16:17:53 +0200
Message-Id: <cover.1652364969.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per description, this series contains some typo fixes on doc and man
pages.

- patch 1/3 fixes a typo in a devlink example
- patch 2/3 fixes typos on some man pages
- patch 3/3 fixes a typo in the tc actions doc

Andrea Claudi (3):
  man: devlink-region: fix typo in example
  man: fix some typos
  doc: fix 'infact' --> 'in fact' typo

 doc/actions/actions-general | 2 +-
 man/man8/dcb-app.8          | 2 +-
 man/man8/dcb-dcbx.8         | 2 +-
 man/man8/devlink-dev.8      | 2 +-
 man/man8/devlink-region.8   | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.35.3

