Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5D41509DA
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgBCPeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:34:24 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726913AbgBCPeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 10:34:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580744062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZukPfAvQnFsmSkjsPlmud6vj0gENxaoW2f8fg5oI6cY=;
        b=Jv1iPSG/6UQjg1DFDy8fjtx6Ow6eOyi/PCB+V+h4t+Rc+ZglTgycZwi3zy8+8/barTnOx1
        337aCq3DX6SCnTaxqrRgisuje+/wDimpxpuYwaZv6b1vbTia6ZTy14nae8A2qsgd/jMK01
        5syIZIXRubwbGVJPwhwVHi5Nsy3pUs0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-Kg5mypiqM7q6MaZyG1pDRw-1; Mon, 03 Feb 2020 10:34:18 -0500
X-MC-Unique: Kg5mypiqM7q6MaZyG1pDRw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC313E495C;
        Mon,  3 Feb 2020 15:34:16 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8019760BE2;
        Mon,  3 Feb 2020 15:34:15 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Roman Mashak <mrv@mojatatu.com>, Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net 0/2] unbreak 'basic' and 'bpf' tdc testcases
Date:   Mon,  3 Feb 2020 16:29:28 +0100
Message-Id: <cover.1580740848.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- patch 1/2 fixes tdc failures with 'bpf' action on fresch clones of the
  kernel tree
- patch 2/2 allow running tdc for the 'basic' classifier without tweaking
  tdc_config.py

Davide Caratti (2):
  tc-testing: fix eBPF tests failure on linux fresh clones
  tc-testing: add missing 'nsPlugin' to basic.json

 .../tc-testing/plugin-lib/buildebpfPlugin.py  |  2 +-
 .../tc-testing/tc-tests/filters/basic.json    | 51 +++++++++++++++++++
 2 files changed, 52 insertions(+), 1 deletion(-)

--=20
2.24.1

