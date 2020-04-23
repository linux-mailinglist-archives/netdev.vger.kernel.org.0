Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10FF1B5CB4
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgDWNjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:39:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27288 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726224AbgDWNjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 09:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587649159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pUdVszF1p3MSvbUsfyFbskmNkuT5bRRtn1xtYN/oFTE=;
        b=XEg515rdwxlvD3STVMONwtSka3rrwwBAjfG2y7/L3c0+LGHiTsOFNkSxKLddpL5HBBpdR7
        gWCORS6UPNO8dE4jNvTHKW0Lty4YRCygXa8zaKciyb64dZXfQ/2t0ikOdGENFl9+4gfnAg
        7991StIrGcbJXD8AF1OgmtMrT/uArzg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-0WJYS_1dOlupw86UlHTt8g-1; Thu, 23 Apr 2020 09:39:17 -0400
X-MC-Unique: 0WJYS_1dOlupw86UlHTt8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26B6718FE86A;
        Thu, 23 Apr 2020 13:39:16 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-154.ams2.redhat.com [10.36.114.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08ACB1002380;
        Thu, 23 Apr 2020 13:39:14 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     dcaratti@redhat.com
Subject: [PATCH iproute2-next 0/4] iproute: mptcp support
Date:   Thu, 23 Apr 2020 15:37:06 +0200
Message-Id: <cover.1587572928.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces support for the MPTCP PM netlink interface, allowing admi=
ns
to configure several aspects of the MPTCP path manager. The subcommand is
documented with a newly added man-page.

This series also includes support for MPTCP subflow diag.

Davide Caratti (1):
  ss: allow dumping MPTCP subflow information

Paolo Abeni (3):
  uapi: update linux/mptcp.h
  add support for mptcp netlink interface
  man: mptcp man page

 include/uapi/linux/mptcp.h |  89 ++++++++
 ip/Makefile                |   2 +-
 ip/ip.c                    |   3 +-
 ip/ip_common.h             |   1 +
 ip/ipmptcp.c               | 436 +++++++++++++++++++++++++++++++++++++
 man/man8/ip-mptcp.8        | 142 ++++++++++++
 man/man8/ss.8              |   5 +
 misc/ss.c                  |  62 ++++++
 8 files changed, 738 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/mptcp.h
 create mode 100644 ip/ipmptcp.c
 create mode 100644 man/man8/ip-mptcp.8

--=20
2.21.1

