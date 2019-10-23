Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34697E22A1
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389787AbfJWSkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:40:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38434 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729043AbfJWSkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 14:40:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571856003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DgLKF411en1dpfMUuEMeMWFCxen/DsaqYFwkNzQIu9o=;
        b=QpmvRYCrjEW3ZhDQi8RyAs6qleQv6y6jWCEPV2dcN5HhNX1TRQj1PwQ4CkPG7iDsEIXYhR
        tzzWSeNn+E4CFavKTtt4DfZBoADQP+Xz0bn1dj2o4vhjN2eDaQgQFqAHHZ4FObQSVhD+y+
        hbq45DJIsy5Rd0HPyVtf2ODDWDKuHo4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-AkEu5MbsNCWuufIdK4-WKA-1; Wed, 23 Oct 2019 14:39:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D42A107AD31;
        Wed, 23 Oct 2019 18:39:57 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF23F546E0;
        Wed, 23 Oct 2019 18:39:49 +0000 (UTC)
Date:   Wed, 23 Oct 2019 20:39:47 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     William Tu <u9012063@gmail.com>
Cc:     netdev@vger.kernel.org, bjorn.topel@intel.com,
        daniel@iogearbox.net, ast@kernel.org, magnus.karlsson@intel.com,
        brouer@redhat.com
Subject: Re: [PATCH net-next] xsk: Enable AF_XDP by default.
Message-ID: <20191023203947.764cdc1a@carbon>
In-Reply-To: <1571788711-4397-1-git-send-email-u9012063@gmail.com>
References: <1571788711-4397-1-git-send-email-u9012063@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: AkEu5MbsNCWuufIdK4-WKA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 16:58:31 -0700
William Tu <u9012063@gmail.com> wrote:

> The patch enables XDP_SOCKETS and XDP_SOCKETS_DIAG used by AF_XDP,
> and its dependency on BPF_SYSCALL.
>=20
> Signed-off-by: William Tu <u9012063@gmail.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

