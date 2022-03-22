Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48BF4E4162
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237395AbiCVOdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237267AbiCVOdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:33:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EBA86A07A
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647959536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=018YLwsfYAW9jC5Fkg7eDftLo30xU64uzzIwA+xgMQM=;
        b=Gz25gSwX8yojQeQSHFmoT2PzMgSuajo3f1bM5OpZCv8xcpEA+2DVP+G2PiAM0wGHD834Yx
        KjrTeSEXOzJYCbWQvMZT49tVOao2/YzsTTiQNNQDUd6UHSFHSDhPMCaroJ8lotIcw/vU0N
        t8EVeIo/vkfm7WV56KieAdVgMQRDSGk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-BRzLJJshNRepwgEHWywuTw-1; Tue, 22 Mar 2022 10:32:14 -0400
X-MC-Unique: BRzLJJshNRepwgEHWywuTw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E52418A6584;
        Tue, 22 Mar 2022 14:32:14 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.196.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 902CC4B8D42;
        Tue, 22 Mar 2022 14:32:13 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 0/3] Fix some typos in doc and man pages
Date:   Tue, 22 Mar 2022 15:32:02 +0100
Message-Id: <cover.1647955885.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per description, this series contains some typo fixes on doc an man
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
2.35.1

