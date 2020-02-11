Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4222E1598B4
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgBKSeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 13:34:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22795 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727361AbgBKSeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 13:34:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581446045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H52uUIII4a2pWWKUmVDRNDHxPBKEt4OPzv++iKY3M4w=;
        b=d+DzDlPD9rRdk1iLVzq6OpTcC8xhel01ieHRpebShO6f5y21rP0PaqSL+DSd1sNrBCgc3+
        k9b16yAbt0K45Lm9bm8vrHNN3XwvA5YKzwYQE6sTu0T7pIP89S79z/x5+3fZ1Hhfv6GjSu
        bjTS8wTGazhuuwHWq73MsQKiXp5KHmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-wxEH4LOuMMuk7ZY4HmbmgA-1; Tue, 11 Feb 2020 13:34:03 -0500
X-MC-Unique: wxEH4LOuMMuk7ZY4HmbmgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E671F1005513;
        Tue, 11 Feb 2020 18:34:01 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96335100EBA4;
        Tue, 11 Feb 2020 18:34:00 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Amir Vadai <amir@vadai.me>, Yotam Gigi <yotamg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/2] add missing validation of 'skip_hw/skip_sw'
Date:   Tue, 11 Feb 2020 19:33:38 +0100
Message-Id: <cover.1581444848.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ensure that all classifiers currently supporting HW offload
validate the 'flags' parameter provided by user:

- patch 1/2 fixes cls_matchall
- patch 2/2 fixes cls_flower

Davide Caratti (2):
  net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS
  net/sched: flower: add missing validation of TCA_FLOWER_FLAGS

 net/sched/cls_flower.c   | 1 +
 net/sched/cls_matchall.c | 1 +
 2 files changed, 2 insertions(+)

--=20
2.24.1

