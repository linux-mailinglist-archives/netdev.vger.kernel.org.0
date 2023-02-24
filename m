Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B886A1C5E
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjBXMqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjBXMqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:46:00 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BA24FCB7;
        Fri, 24 Feb 2023 04:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=7LqROShLiEiGgJd+sksOC4qxoyGKc04CZsj56hdSrq8=; t=1677242758; x=1678452358; 
        b=WFbimiGAZpXnOVI0j2S5xv/4g3Zs229MbP8jUwF93tEsyQvXGjW59p/3Z7HrabpT7GQmXqSV1TJ
        oMKEb+9fk3Jah/T7M4wEF7P0C2Pcdmg/Hv3gQQRKYgYCsXmTnYrGplmwdoq5kHKGCpYVRSbc0igYD
        2pnTFrMs/q9uLo8UN3esk3HcNV2aZdk6yF6UPhd9eaCZWDW4/MqXzUtCeF5o09zKkFnemQGHq5FYl
        ubQKoGMVUQUN4sv2qgC/GNwglojerjz7WkB3AuC/olH73A86CSagb5XvSyrMaAjvD30rdUfh+C1fY
        2N0a23//SvXLc2AJ/CCnU2GHU05KRO/5aN6g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pVXSX-004CAe-0A;
        Fri, 24 Feb 2023 13:45:57 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 0/2] net: netlink: full range policy improvements
Date:   Fri, 24 Feb 2023 13:45:51 +0100
Message-Id: <20230224124553.94730-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sending this as an RFC since we're in the middle of the merge window,
and patches depend on an nl80211 patch that isn't in the tree yet.

But I think it's worthwhile doing this later.

johannes


