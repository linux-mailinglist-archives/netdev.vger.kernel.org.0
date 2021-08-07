Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFEF3E32FA
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 05:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhHGDb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 23:31:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45768 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230236AbhHGDbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 23:31:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628307068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xTZ6nnfDg5SLxfzo7CSr56OTmTl6Ayl69N1Ny1XZvVk=;
        b=DwN4VKN6hl7SEhz+heiBXeGyNQDe18jc6tDYKd+Jzs4uS3J0b/C+UINs8bOyPzNx0oWB18
        ujKIdY323cpVcbcipYL8Wr3ovmfPgoxcc+O/NiXpDDxlUQbZ1EQGn+b7qKEGCluEUnZRLg
        4p+SUryARG1guYqQhLAB3yGhDJ5y/3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-_y7MjwM7O5Gh6hEjPBfI2Q-1; Fri, 06 Aug 2021 23:31:06 -0400
X-MC-Unique: _y7MjwM7O5Gh6hEjPBfI2Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EE76871803
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 03:31:06 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.8.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7DBA19C59
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 03:31:05 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] bonding: cleanup header file and error msgs
Date:   Fri,  6 Aug 2021 23:30:53 -0400
Message-Id: <cover.1628306392.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two small patches removing unreferenced symbols and unifying error
messages across netlink and printk.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>

Jonathan Toppins (2):
  bonding: remove extraneous definitions from bonding.h
  bonding: combine netlink and console error messages

 drivers/net/bonding/bond_main.c | 45 ++++++++++++++++++---------------
 include/net/bonding.h           | 12 ---------
 2 files changed, 25 insertions(+), 32 deletions(-)

-- 
2.27.0

