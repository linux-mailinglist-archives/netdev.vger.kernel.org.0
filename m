Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90EC3B9444
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 17:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393501AbfITPmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 11:42:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36128 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391417AbfITPmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 11:42:12 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BBE210C0930;
        Fri, 20 Sep 2019 15:42:12 +0000 (UTC)
Received: from asgard.redhat.com (ovpn-112-68.ams2.redhat.com [10.36.112.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4662D5DC1B;
        Fri, 20 Sep 2019 15:42:09 +0000 (UTC)
Date:   Fri, 20 Sep 2019 17:41:47 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net v2 0/3] net/smc: move some definitions to UAPI
Message-ID: <cover.1568993930.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Fri, 20 Sep 2019 15:42:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

As of now, it's a bit difficult to use SMC protocol, as significant part
of definitions related to it are defined in private headers and are not
part of UAPI. The following commits move some definitions to UAPI,
making them readily available to the user space.

Changes since v1[1]:
 * Patch "provide fallback diagnostic codes in UAPI" is updated
   in accordance with the updated set of diagnostic codes.

[1] https://lkml.org/lkml/2018/10/7/177

Eugene Syromiatnikov (3):
  uapi, net/smc: move protocol constant definitions to UAPI
  uapi, net/smc: provide fallback diagnostic codes in UAPI
  uapi, net/smc: provide socket state constants in UAPI

 include/uapi/linux/smc.h      | 32 +++++++++++++++++++++++++++++++-
 include/uapi/linux/smc_diag.h | 17 +++++++++++++++++
 net/smc/smc.h                 | 22 ++--------------------
 net/smc/smc_clc.h             | 22 ----------------------
 4 files changed, 50 insertions(+), 43 deletions(-)

-- 
2.1.4

