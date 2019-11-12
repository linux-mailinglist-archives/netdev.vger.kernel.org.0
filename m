Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E410BF880E
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 06:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbfKLFgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 00:36:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37595 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725283AbfKLFgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 00:36:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573536978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3/ZY3aqlfsDgahQkTluiqlKhaZSjsXMDLabZmwcujg0=;
        b=FQioxg08JfEB+zTiWJhbScfixqt8PH7bl76HheDI/1bRA2qnbLklcAXxZHTd3PrKfq0n2F
        CwLWroOyLx78JpbEmQXtwTv/YjDCctiBo/YwDOrXlws+Xm4sqOsFMey7lM+KBW7HTtLish
        kqK9Ef0buMx2rAxc2CnMCyLj/wCRkn0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-gByMGhJcOYy7u_7nTzXR3w-1; Tue, 12 Nov 2019 00:36:14 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2C87800686;
        Tue, 12 Nov 2019 05:36:13 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B02086268A;
        Tue, 12 Nov 2019 05:36:12 +0000 (UTC)
Date:   Mon, 11 Nov 2019 21:36:11 -0800 (PST)
Message-Id: <20191111.213611.717067173778554668.davem@redhat.com>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: add support for RTL8117
From:   David Miller <davem@redhat.com>
In-Reply-To: <7f4f2791-dbe4-efda-e430-a61795e1375e@gmail.com>
References: <7f4f2791-dbe4-efda-e430-a61795e1375e@gmail.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: gByMGhJcOYy7u_7nTzXR3w-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 10 Nov 2019 16:13:35 +0100

> Add support for chip version RTL8117. Settings have been copied from
> Realtek's r8168 driver, there however chip ID 54a belongs to a chip
> version called RTL8168FP. It was confirmed that RTL8117 works with
> Realtek's driver, so both chip versions seem to be the same or at
> least compatible.
>=20
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.

