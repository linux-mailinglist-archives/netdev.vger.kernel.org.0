Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D651B1469
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgDTSYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:24:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26695 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725784AbgDTSYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:24:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587407048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LcnFxEMNLiKP5TIbKhSSCdffl2X3e3gp7tGFyL2Tb1g=;
        b=b6FOj/phrRVfsAI8gD7CwoV6YrqoluXrNJ663LBena/7WRmCU7Ps+TfHY3jYwb16uay4Sx
        TJ9q3FACo+WiBPrCg7Z65ztwNvpXrBp7JEb05FzTuUurxqlmSJzUkxcmdmrGNApQBh4n/Y
        TYtxU2hPdOlTS/djqj4ctzSN6QYzVb4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-J10Z2pWjMeO4HkIGu6IQ3A-1; Mon, 20 Apr 2020 14:24:04 -0400
X-MC-Unique: J10Z2pWjMeO4HkIGu6IQ3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2E2310753FE
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 18:23:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-22.rdu2.redhat.com [10.10.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65284277C8;
        Mon, 20 Apr 2020 18:23:59 +0000 (UTC)
To:     netdev@vger.kernel.org
Cc:     Jan Stancek <jstancek@redhat.com>
From:   Rachel Sibley <rasibley@redhat.com>
Subject: WARNING: CPU: 0 PID: 805 at net/core/dev.c:1595
 dev_disable_lro+0xb2/0xf0
Message-ID: <a47b6a3b-c064-2f53-7cf6-d0d0720e9d99@redhat.com>
Date:   Mon, 20 Apr 2020 14:23:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Apologies if I'm sending to the wrong ML, hopefully this is the right place. During
podman[1] testing in CKI[2](Continuous Kernel Integration), we found a potential kernel
bug when running the "podman images - history output" test. An issue was filed against
libpod project [3], however it was later closed and advised to file a kernel bug instead.
Hoping someone can follow up or point me in the right direction.

Thanks,
Rachel

[1] https://github.com/CKI-project/tests-beaker/tree/master/container/podman
[2] https://cki-project.org/
[3] https://github.com/containers/libpod/issues/5815

