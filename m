Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410AB58938C
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbiHCUuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 16:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237566AbiHCUuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 16:50:09 -0400
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03525C96C
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 13:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aBvjrsh7bci5Or2hOoB9FhGmm/Gk7jePZjF9hIymSkk=; b=AjQL01gQ3x3voRybk+y00rHiJN
        U+ZT06IEuxtVQcY80PRwyGv+cNADYLTFqb8HMpGUjsgPykQ49en7wl1c2CkphZ5w9dtmEwziowkNw
        bGBWrbI7p56QMFaCN2WZfn/bBdf7/Q8hKMRN/P5sQC+I225WTVriGhmyevBCX7frQ6Uc=;
Received: from [88.117.54.219] (helo=hornet.engleder.at)
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oJLJX-0001TF-51; Wed, 03 Aug 2022 22:49:59 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 0/6] tsnep: Various minor driver improvements
Date:   Wed,  3 Aug 2022 22:49:41 +0200
Message-Id: <20220803204947.52789-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During XDP development some general driver improvements has been done
which I want to keep out of future patch series. Additionally, the
kernel test robot told me to fix a warning.

Gerhard Engleder (6):
  tsnep: Add loopback support
  tsnep: Fix unused warning for 'tsnep_of_match'
  tsnep: Improve TX length handling
  tsnep: Fix tsnep_tx_unmap() error path usage
  tsnep: Support full DMA mask
  tsnep: Record RX queue

 drivers/net/ethernet/engleder/tsnep.h      |   1 +
 drivers/net/ethernet/engleder/tsnep_main.c | 121 +++++++++++++++------
 2 files changed, 90 insertions(+), 32 deletions(-)

-- 
2.30.2

