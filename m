Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54816103EE3
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 16:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfKTPhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 10:37:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39072 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727928AbfKTPhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 10:37:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574264240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NZr37fjEW074Uq422TDUze0z91YD2cn4ujSqGqXNpI=;
        b=AW57KsyqMbpY9xJezwHNUMCc7uiAGAaX0G801BVSOkV7Zx/2ymJPrDQX6w91Tf9z0xTsh0
        11wPLk/sSPSjzdxm+FGjK3GAPZffBjtB9ScJB7GD4LFwNSVgwgxmwUgX7vjKYiX/W/xMpL
        +2UCSIu4GqiD7Zr5T2eYeQ/Psmp6BYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-4i7NU4FpNqm-6eOaK_gwdw-1; Wed, 20 Nov 2019 10:37:18 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50D39801FA1;
        Wed, 20 Nov 2019 15:37:17 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9843E2AA92;
        Wed, 20 Nov 2019 15:37:09 +0000 (UTC)
Date:   Wed, 20 Nov 2019 16:37:08 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v5 net-next 0/3] add DMA-sync-for-device capability to
 page_pool API
Message-ID: <20191120163708.3b37077a@carbon>
In-Reply-To: <cover.1574261017.git.lorenzo@kernel.org>
References: <cover.1574261017.git.lorenzo@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 4i7NU4FpNqm-6eOaK_gwdw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 16:54:16 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Do not change naming convention for the moment since the changes will
> hit other drivers as well. I will address it in another series.

Yes, I agree, as I also said over IRC (freenode #xdp).

The length (dma_sync_size) API addition to __page_pool_put_page() is
for now confined to this driver (mvneta).  We can postpone the API-name
discussion, as you have promised here (and on IRC) that you will
"address it in another series".  (Guess, given timing, the followup
series and discussion will happen after the merge window...)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

