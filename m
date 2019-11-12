Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73520F885F
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfKLGFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:05:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37627 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725298AbfKLGFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573538745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8tOanLl7QbFn0dSrip+KdTPSybewknYJ8kGjOr0qWiE=;
        b=KefvLL5GUsu+IbcG2aQR65fUC9xEKuvqrwK+p6enE656xEnVuTU+0Ob0LbuenqY7NKWk50
        i3erRNFdZoABDWoffIdHKGxPQ78r2XFHUnuHSLjYtr5AREEVPWac7tGobHQPkMOWkAxzZ9
        abhkwwliafSWxk3jz42/ZGlqXePQj58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-YKQFgGKMMU2oSE1XZkk2SQ-1; Tue, 12 Nov 2019 01:05:41 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A63F800C61;
        Tue, 12 Nov 2019 06:05:40 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62DD461071;
        Tue, 12 Nov 2019 06:05:38 +0000 (UTC)
Date:   Mon, 11 Nov 2019 22:05:37 -0800 (PST)
Message-Id: <20191111.220537.2202321483530744698.davem@redhat.com>
To:     colin.king@canonical.com
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] cxgb4: remove redundant assignment to hdr_len
From:   David Miller <davem@redhat.com>
In-Reply-To: <20191111124413.68782-1-colin.king@canonical.com>
References: <20191111124413.68782-1-colin.king@canonical.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: YKQFgGKMMU2oSE1XZkk2SQ-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon, 11 Nov 2019 12:44:13 +0000

> From: Colin Ian King <colin.king@canonical.com>
>=20
> Variable hdr_len is being assigned a value that is never read.
> The assignment is redundant and hence can be removed.
>=20
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.

