Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C546E7A05
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjDSMxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjDSMxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:53:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1455ACF;
        Wed, 19 Apr 2023 05:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=GMorJrZLLq+A5yHykjZ5p7GAZ3slLQEAObJct6E3Vww=; t=1681908781; x=1683118381; 
        b=oWMQO2iM3A4yTIcGWyvx9YyE2ITrvSyn1Do1/E3w+HbV1YcBGDA8rcIRjQsswM880LH59/eAujb
        i+5hGE6nWfdeVsuCRB2thJ16fQEZ1OuHlhlJeoJJ/fyY5iGDji/KOBIrQNr2iCSyfb+7M0qpFYEkW
        BliHOZqUWb2l+zTdJwqE5C6Oz6Dq7c+y+b+zYDESkA9p4yRCSKIMFrGthQX/lBA8OM77dZHGP8OeX
        MmuNYuPhsDFGZnMVshNI4odlITMtceSUTg62WaoYxMfwaQ4iq2o3wUPqmomhcnpZ3DwFHF+m3n6LR
        1WlZv6Urplhg87aLKwl5i73n1neKQBA+rldA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pp7Iw-002YjR-1D;
        Wed, 19 Apr 2023 14:52:58 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH net-next v4 0/3] net: extend drop reasons
Date:   Wed, 19 Apr 2023 14:52:51 +0200
Message-Id: <20230419125254.20789-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's v4 of the extended drop reasons, with fixes to kernel-doc
and checkpatch.

johannes


