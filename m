Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95211B48A1
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDVPaE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Apr 2020 11:30:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726006AbgDVPaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:30:04 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-RrDA-pjeMMSq7xBD4rd3EA-1; Wed, 22 Apr 2020 11:29:59 -0400
X-MC-Unique: RrDA-pjeMMSq7xBD4rd3EA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ACB5800EB5;
        Wed, 22 Apr 2020 15:29:58 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F3681000079;
        Wed, 22 Apr 2020 15:29:55 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Girish Moodalbail <girish.moodalbail@oracle.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 0/2] net: vxlan/geneve: use the correct nlattr array for extack
Date:   Wed, 22 Apr 2020 17:29:49 +0200
Message-Id: <cover.1587568231.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ->validate callbacks for vxlan and geneve have a couple of typos
in extack, where the nlattr array for IFLA_* attributes is used
instead of the link-specific one.

Sabrina Dubroca (2):
  vxlan: use the correct nlattr array in NL_SET_ERR_MSG_ATTR
  geneve: use the correct nlattr array in NL_SET_ERR_MSG_ATTR

 drivers/net/geneve.c | 2 +-
 drivers/net/vxlan.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.26.1

