Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661F3221DE6
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgGPIJf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jul 2020 04:09:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37583 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726882AbgGPIJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 04:09:34 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-lL8W-13QMq27gS4TKYys5Q-1; Thu, 16 Jul 2020 04:09:32 -0400
X-MC-Unique: lL8W-13QMq27gS4TKYys5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07D251800D42;
        Thu, 16 Jul 2020 08:09:31 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B68B9710A0;
        Thu, 16 Jul 2020 08:09:29 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec 0/3] xfrm: a few fixes for espintcp
Date:   Thu, 16 Jul 2020 10:09:00 +0200
Message-Id: <cover.1594287359.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Cagney reported some issues when trying to use async operations
on the encapsulation socket. Patches 1 and 2 take care of these bugs.

In addition, I missed a spot when adding IPv6 support and converting
to the common config option.

Sabrina Dubroca (3):
  espintcp: support non-blocking sends
  espintcp: recv() should return 0 when the peer socket is closed
  xfrm: policy: fix IPv6-only espintcp

 net/xfrm/espintcp.c    | 31 +++++++++++++++++--------------
 net/xfrm/xfrm_policy.c |  4 ++--
 2 files changed, 19 insertions(+), 16 deletions(-)

-- 
2.27.0

