Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CDD2D7EEA
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389338AbgLKSzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:55:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389331AbgLKSyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:54:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607712797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PeLsa0BdFiUfLgPwx0Dy2vwu1H95KYmRhAb+IAaRENc=;
        b=VegkSa5VL28UrIhNd/1A09S7bi5/56VZMMH3NIe2ntIOhJk3mJJeQj/veNKMhhg+nr+n+P
        FKFLNVPEwZFk3dqkjXwM+R+CnNnKIXL+vrFC7lytPUZdgKhJoJ8Kvis89DRkp1EErvZjXW
        Cw9RLvIceNXMtXKGAuNmTW1NLPtZb38=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-NVV4DT9lMa-xKELP2IJsDg-1; Fri, 11 Dec 2020 13:53:15 -0500
X-MC-Unique: NVV4DT9lMa-xKELP2IJsDg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83447107AD4F;
        Fri, 11 Dec 2020 18:53:14 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-114-11.ams2.redhat.com [10.36.114.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6E2D60BE5;
        Fri, 11 Dec 2020 18:53:13 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 0/2] fix two memory leaks
Date:   Fri, 11 Dec 2020 19:53:01 +0100
Message-Id: <cover.1607712061.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes two memory leaks in iproute2,
in tc and devlink code.

Andrea Claudi (2):
  devlink: fix memory leak in cmd_dev_flash()
  tc: pedit: fix memory leak in print_pedit

 devlink/devlink.c | 13 ++++++++-----
 tc/m_pedit.c      |  4 +++-
 2 files changed, 11 insertions(+), 6 deletions(-)

-- 
2.29.2

