Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450EB12A5C
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfECJZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:25:12 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51640 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfECJZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 05:25:12 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMURL-0005qF-6r
        for netdev@vger.kernel.org; Fri, 03 May 2019 11:25:11 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Subject: [PATCH v2 0/8] netlink policy export and recursive validation
Date:   Fri,  3 May 2019 11:24:53 +0200
Message-Id: <20190503092501.10275-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's (finally, sorry) the respin with the range/range_signed assignment
fixed up.

I've now included the validation recursion protection so it's clear that
it applies on top of the other patches only.

johannes


