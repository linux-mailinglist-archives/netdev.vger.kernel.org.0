Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516BA6E2687
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDNPMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDNPMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:12:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA761ED
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 08:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=fNo2gNspcRsohYWMXyamkRM54ZTjQ7x++CLNwJQTSbI=; t=1681485157; x=1682694757; 
        b=rK23dqln4C8dgPywy0IG43Kg6hXq17SBxpzOeEPwFki33l5GxVbxayRuMirDj99diY1BrG9Ko3x
        u4kejHVZnT+TE3klvpVD9q1j5aPNhZ4aZIYnJCxuEE9O2j3nTQIn8s0A7XS73F/5fsbEOG2Y8jCsU
        uHUkMKh6OFu19x43Azf4bWrG4QkNqug75xZrHzuFxhgKi7vsDlg9pFa/5sxlGaKwVxbw45y6Eu7si
        PTfWx1wAfoBWYkwwP5rBtpa+SR3VyW8cQE7dxU/oT7zzTGqRtuRMI0xiC3ghht+xQx2c17Sjs6sU+
        sDC77GGwRd2DI5AKYKcIjnY/lz+Yayh0nhkg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pnL6J-00Fdii-2C
        for netdev@vger.kernel.org;
        Fri, 14 Apr 2023 17:12:35 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Subject: [PATCH next-next v3 0/3] extend drop reasons
Date:   Fri, 14 Apr 2023 17:12:24 +0200
Message-Id: <20230414151227.348725-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's v3 after the discussions. The first patch is new, to
separate the reasons (needed in a lot of places) from the new
infrastructure (needed only in skbuff.c, drop_monitor and in
mac80211 in the last patch).

johannes


