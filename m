Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE10547EBA
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 06:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbiFMEiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 00:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiFMEhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 00:37:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40339B1D0
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 21:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655095071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4V5EX5/9YZHbip5AGwxSlpLttI5vo9T1PLZKNwkf2f4=;
        b=P+szS140RUvY7jsuhUlWHiU3gh6BvehP1zZpNt4mXJfx2GA14cfdqx5jjzXPmPGFr6OrDI
        6W5Cmc17+rwAHvZT14Pb3cDJ2qBwCHUBKQi+EcyK8LRUTh+5AD50w3XbXl5ACIQpsyIhcg
        7tMEkQWvkZlOv2F2UToT4oB+yAHhmgw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-9-SAt39FMvO80KnZPsInsQ-1; Mon, 13 Jun 2022 00:37:46 -0400
X-MC-Unique: 9-SAt39FMvO80KnZPsInsQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B7ED29AA383;
        Mon, 13 Jun 2022 04:37:46 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D798E492CA2;
        Mon, 13 Jun 2022 04:37:45 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        miquel.raynal@bootlin.com, aahringo@redhat.com
Subject: [PATCHv2 wpan-next 0/2] mac802154: atomic_dec_and_test() fixes
Date:   Mon, 13 Jun 2022 00:37:33 -0400
Message-Id: <20220613043735.1039895-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I was wondering why nothing worked anymore. I found it...

changes since v2:

 - fix fixes tags in mac802154: util: fix release queue handling
 - add patch mac802154: fix atomic_dec_and_test checks got somehow
   confused 2 patch same issue

Alexander Aring (2):
  mac802154: util: fix release queue handling
  mac802154: fix atomic_dec_and_test checks

 net/mac802154/tx.c   | 4 ++--
 net/mac802154/util.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.31.1

