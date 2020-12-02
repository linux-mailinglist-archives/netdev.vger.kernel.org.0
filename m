Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222B22CC3FC
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbgLBRkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:40:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730836AbgLBRkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:40:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606930722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8TiWbriXrZZuTOrLZobdmyNLOdlddB0EM17NQtdgrTk=;
        b=cnnB3A/qg7zFDYzDKpzvDKTqHIDCbyFiLxJpjHL22+rGKZq63+pDEMJQg9FkaRXQ+vkH8a
        7v6agr+GmqJqQqGMzgJE5uZ9gS/WFZFOYUROViyqzhs+lINWRPiDc3KSGzCTRfAJnfwTVt
        dajzlsnXU63KTNqPNB9VXmoBOdkVMZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-p7dGsJJPMCupxjPMB4AXdQ-1; Wed, 02 Dec 2020 12:38:40 -0500
X-MC-Unique: p7dGsJJPMCupxjPMB4AXdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87FE61006C98;
        Wed,  2 Dec 2020 17:38:39 +0000 (UTC)
Received: from ovpn-112-254.ams2.redhat.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABB1A1A353;
        Wed,  2 Dec 2020 17:38:37 +0000 (UTC)
Message-ID: <c68ff2ed5dd3292c4cf6e5f60d2b39d0f29be2ae.camel@redhat.com>
Subject: Re: [PATCH net-next] mptcp: avoid potential infinite loop in
 mptcp_recvmsg()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
Date:   Wed, 02 Dec 2020 18:38:36 +0100
In-Reply-To: <20201202171657.1185108-1-eric.dumazet@gmail.com>
References: <20201202171657.1185108-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-02 at 09:16 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> If a packet is ready in receive queue, and application isssues
> a recvmsg()/recvfrom()/recvmmsg() request asking for zero bytes,
> we hang in mptcp_recvmsg().
> 
> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>

Tested-by: Paolo Abeni <pabeni@redhat.com>

Thanks Eric!


