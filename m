Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E216B3E8848
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 04:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhHKCyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 22:54:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231634AbhHKCyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 22:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628650425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0kdLwiKhRWb8/lmd3WKpQJNjWUcEVT8MJk8TmyynfXg=;
        b=EK3i7J1w0waXi88Y0MtAJjXd0j49Uo2QbS3FT/6M6GGRe/S06wZn/fKfrPXmFkOizhB+px
        TBC+tJvi3sswQvShux+yJRELSG3yYdo+0530zy/+mYMVzQzccmFyp7D4lKd6z2XhfNY0pq
        vpG2lmf3EONGBnN+C4OwfaA/PSjjQRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-iX8C4sc1OOCsTpDtG0ROcw-1; Tue, 10 Aug 2021 22:53:42 -0400
X-MC-Unique: iX8C4sc1OOCsTpDtG0ROcw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F6A93639F;
        Wed, 11 Aug 2021 02:53:41 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.16.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CC306F97F;
        Wed, 11 Aug 2021 02:53:40 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, joe@perches.com, leon@kernel.org
Subject: [PATCH net-next v2 0/2] bonding: cleanup header file and error msgs
Date:   Tue, 10 Aug 2021 22:53:29 -0400
Message-Id: <cover.1628650079.git.jtoppins@redhat.com>
In-Reply-To: <cover.1628306392.git.jtoppins@redhat.com>
References: <cover.1628306392.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two small patches removing unreferenced symbols and unifying error
messages across netlink and printk.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>

Jonathan Toppins (2):
  bonding: remove extraneous definitions from bonding.h
  bonding: combine netlink and console error messages

 drivers/net/bonding/bond_main.c | 69 ++++++++++++++++++---------------
 include/net/bonding.h           | 12 ------
 2 files changed, 37 insertions(+), 44 deletions(-)

-- 
2.27.0

