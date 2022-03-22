Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528EB4E4164
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiCVOdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiCVOdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:33:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B3F96E787
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647959540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KZCbYnTtFDReR335j89Tcl6LYEvBu8p/PABhz0kU3N8=;
        b=Nb7iHn7xs7GMrbMOSsb98a3otrRrGwvirCK04CakHnDXyxN+3uZN/sEw5wmV7bEsfdb23H
        SPcu7EpeMzsFbF2DGFmEuDZzIdAdCCi8qVZNJuxYyuEzPKyHyU9M6/U5qJCqmR3Uf9LwRk
        wgjQe2DKXrU62fu9Fb23mkeQwuvNZjU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-WksC3sbZOTKTi58_NzbsTw-1; Tue, 22 Mar 2022 10:32:17 -0400
X-MC-Unique: WksC3sbZOTKTi58_NzbsTw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 087BD1C0904A;
        Tue, 22 Mar 2022 14:32:17 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.196.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CEF24B8D42;
        Tue, 22 Mar 2022 14:32:16 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 3/3] doc: fix 'infact' --> 'in fact' typo
Date:   Tue, 22 Mar 2022 15:32:05 +0100
Message-Id: <64ea6c8ac75e0d273bb4fe5842f9a62dc935ea49.1647955885.git.aclaudi@redhat.com>
In-Reply-To: <cover.1647955885.git.aclaudi@redhat.com>
References: <cover.1647955885.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spell 'infact' correctly as 'in fact'

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 doc/actions/actions-general | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/actions/actions-general b/doc/actions/actions-general
index 407a514c..a0074a58 100644
--- a/doc/actions/actions-general
+++ b/doc/actions/actions-general
@@ -72,7 +72,7 @@ action police mtu 4000 rate 1500kbit burst 90k
 2)In order to take advantage of some of the targets written by the
 iptables people, a classifier can have a packet being massaged by an
 iptable target. I have only tested with mangler targets up to now.
-(infact anything that is not in the mangling table is disabled right now)
+(in fact anything that is not in the mangling table is disabled right now)
 
 In terms of hooks:
 *ingress is mapped to pre-routing hook
-- 
2.35.1

