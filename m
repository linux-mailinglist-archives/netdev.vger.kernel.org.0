Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0039441FA9
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhKAR52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:57:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231378AbhKAR51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 13:57:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635789293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=+mqbF+DYWXA4Fj4U2dHhLoC+qgwPcMaIVYMzWrMOSDE=;
        b=In2tGLAr/o1Zz5N6WEezzkTc8IBbB/29omI3C3zob4wi90l017HzuidJjEWVwGuErr/7ro
        JmocLDrD4qJnV9K4T12Dby4GSCjTDOW0i2ukGJxMJPfNv6uv41zj9KJsdRD5Fc0yqct6Zh
        KGDDA2GZxVrydGJeAGynUGfdhBJjpg4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207--u3fxf04NXaBZqFvtcLW-Q-1; Mon, 01 Nov 2021 13:54:50 -0400
X-MC-Unique: -u3fxf04NXaBZqFvtcLW-Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC626801AE3;
        Mon,  1 Nov 2021 17:54:48 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 853C05D9D3;
        Mon,  1 Nov 2021 17:54:45 +0000 (UTC)
Date:   Mon, 1 Nov 2021 18:54:43 +0100
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] MCTP sockaddr padding check/initialisation fixup
Message-ID: <cover.1635788968.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

Padding/reserved fields necessitate appropriate checks in order to be usable
in the future.

Eugene Syromiatnikov (2):
  mctp: handle the struct sockaddr_mctp padding fields
  mctp: handle the struct sockaddr_mctp_ext padding field

 net/mctp/af_mctp.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

-- 
2.1.4

