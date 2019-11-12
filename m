Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F647F8858
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLGB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:01:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50713 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725775AbfKLGB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:01:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573538518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYYT0994bHu8juu59m/84Rec9drmaoPnh3tNU/8up4w=;
        b=XV8W0daOH/DJ+PoSXfzuwK01Tib/hXispEBLw6QQ8Y50V/rRyJilAxijQddtHuA0ow+bbD
        H3Unpv6M2iIDr8gJS/EjonHXQkPupbIYtQ0lkMwVJz0740w6LcGd9Hdy9vKX0lwzOlGzGe
        o9FSp64fXykR/ustRfOWYXQzbkCFOrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-h8du2rVbPdmER2fgei-JVw-1; Tue, 12 Nov 2019 01:01:55 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C412800C72;
        Tue, 12 Nov 2019 06:01:54 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3325361071;
        Tue, 12 Nov 2019 06:01:52 +0000 (UTC)
Date:   Mon, 11 Nov 2019 22:01:51 -0800 (PST)
Message-Id: <20191111.220151.1774638899132375551.davem@redhat.com>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] dpaa2-eth: free already allocated channels on
 probe defer
From:   David Miller <davem@redhat.com>
In-Reply-To: <1573465255-31409-1-git-send-email-ioana.ciornei@nxp.com>
References: <1573465255-31409-1-git-send-email-ioana.ciornei@nxp.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: h8du2rVbPdmER2fgei-JVw-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Mon, 11 Nov 2019 11:40:55 +0200

> The setup_dpio() function tries to allocate a number of channels equal
> to the number of CPUs online. When there are no enough DPCON objects
> already probed, the function will return EPROBE_DEFER. When this
> happens, the already allocated channels are not freed. This results in
> the incapacity of properly probing the next time around.
> Fix this by freeing the channels on the error path.
>=20
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Please add an appropriate Fixes: tag and resubmit.

