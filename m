Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C3C398416
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhFBIa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhFBIa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:30:28 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FA5C061574;
        Wed,  2 Jun 2021 01:28:45 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1loMF1-000xxd-LP; Wed, 02 Jun 2021 10:28:43 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     m.chetan.kumar@intel.com, loic.poulain@linaro.org
Subject: [RFC v2 0/5] generic WWAN framework interface creation
Date:   Wed,  2 Jun 2021 10:28:35 +0200
Message-Id: <20210602082840.85828-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Spin two, with a new patch (IFLA_PARENT_DEV_NAME) and reworked
to use the existing struct wwan_device that I missed entirely.

Still includes the IOSM patches for reference, so the IOSM bits
here apply only with this set also applied:
https://lore.kernel.org/r/20210520140158.10132-1-m.chetan.kumar@intel.com

johannes


