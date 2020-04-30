Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6E41C0786
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgD3UNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3UNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:13:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9A3C035494;
        Thu, 30 Apr 2020 13:13:23 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jUFYf-002qzz-Ep; Thu, 30 Apr 2020 22:13:21 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/8] netlink validation improvements/refactoring
Date:   Thu, 30 Apr 2020 22:13:04 +0200
Message-Id: <20200430201312.60143-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Alright, this is the resend now, really just changing

 - the WARN_ON_ONCE() as spotted by Jakub;
 - mark the export patch no longer RFC.
   I wasn't actually sure if you meant this one too, and I really
   should dig out and polish the code that showed it in userspace.

johannes


