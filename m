Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92865209BC7
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 11:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403809AbgFYJQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 05:16:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56212 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390071AbgFYJQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 05:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593076613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FUa1AyI2kqDlot6NBKg+0cki17bCgQVg4ilWJpXDvsg=;
        b=RJ6HNXDBMfsQB6ETTXySKQtH2h59dgonK/TcBerBB0ghFJhGjqQ4USk46RBsReMG5uXIU3
        7BAOg+LnYWNiEtIqD8l5cpBGEuJyhMglvpG/H0ND84LOEMiRAMUi8c3hpR5eAA46HgM7LV
        sAChtDf3O7hXjiQoAM/NiBl/D8i0wJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-Hk4ugfd9NEKCIHuRW5BQQw-1; Thu, 25 Jun 2020 05:16:50 -0400
X-MC-Unique: Hk4ugfd9NEKCIHuRW5BQQw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBB35800C60;
        Thu, 25 Jun 2020 09:16:49 +0000 (UTC)
Received: from ovpn-115-125.ams2.redhat.com (ovpn-115-125.ams2.redhat.com [10.36.115.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B89F60F8A;
        Thu, 25 Jun 2020 09:16:48 +0000 (UTC)
Message-ID: <74156b9ad8529a3228658165396fd5adb2ccd972.camel@redhat.com>
Subject: Request for net merge into net-next
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Date:   Thu, 25 Jun 2020 11:16:47 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We have a few net-next MPTCP changes depending on:

commit 9e365ff576b7c1623bbc5ef31ec652c533e2f65e
mptcp: drop MP_JOIN request sock on syn cookies
    
commit 8fd4de1275580a1befa1456d1070eaf6489fb48f
mptcp: cache msk on MP_JOIN init_req

Could you please merge net into net-next so that we can post without
causing later conflicts?

Thank you!

Paolo



