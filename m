Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2368BEB84A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbfJaUOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:14:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44862 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726741AbfJaUOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572552891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6enlVEWNzsxkng+gba8Zw9WUd4kge4ccAV3INBkF1aU=;
        b=eT4SbPj9aPk/uaMylFnwbbkESb3f6yCjzX9DSHSVJ/Hy16lkBOAk8jcGdXX8GFS9ku+Gst
        0CXzEx67reswxVHy9hS+BcZyqo5ehbdo8rf9fbWcL51Y/UPqUu15Km5dIGErdJyEQO5mmd
        3riXB/m9xGuvbjlEHRrJgUpRmgd0x6g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-aL6pfnk6NTqgPXUXlWsiHA-1; Thu, 31 Oct 2019 16:14:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28CA0800D49;
        Thu, 31 Oct 2019 20:14:47 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA29260BE0;
        Thu, 31 Oct 2019 20:14:41 +0000 (UTC)
Date:   Thu, 31 Oct 2019 21:14:40 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Charles McLachlan <cmclachlan@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, brouer@redhat.com
Subject: Re: [PATCH net-next v4 5/6] sfc: handle XDP_TX outcomes of XDP eBPF
 programs
Message-ID: <20191031211440.7b7b5b26@carbon>
In-Reply-To: <4bf23a31-a545-f7e9-81cf-9fb25f6b88f8@solarflare.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
        <4bf23a31-a545-f7e9-81cf-9fb25f6b88f8@solarflare.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: aL6pfnk6NTqgPXUXlWsiHA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 10:24:12 +0000
Charles McLachlan <cmclachlan@solarflare.com> wrote:

> Provide an ndo_xdp_xmit function that uses the XDP tx queue for this
> CPU to send the packet.
>=20
> Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Looks like you fixed up the issues I pointed out, thx.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

