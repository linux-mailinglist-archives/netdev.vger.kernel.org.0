Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E99EB825
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfJaTyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:54:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29093 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727528AbfJaTyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:54:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572551689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6JwtsQhS78NJBwoheKzX3rsafCrvuufM5F4GSmW6XF8=;
        b=aRLTR9gOtXilD5vA3+wjnnFBSReYc9vLcEPISwjC3zGoKgW87eoCumHrZh4XnHJgjPcM8L
        85Cyi64CcMHxLAE+AmERAsk4HnXhTpIObs1FfgdaVFg4e4E6F/wNCQvH70KiK9mgKoUZhm
        uqMqpcf5QK0MFtCed6685M7or2cFYyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-jK9-dpwrOYSZYzNACCvFWQ-1; Thu, 31 Oct 2019 15:54:47 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98C03800D49;
        Thu, 31 Oct 2019 19:54:46 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54D9819C7F;
        Thu, 31 Oct 2019 19:54:42 +0000 (UTC)
Date:   Thu, 31 Oct 2019 20:54:40 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Charles McLachlan <cmclachlan@solarflare.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, brouer@redhat.com
Subject: Re: [PATCH net-next v4 1/6] sfc: support encapsulation of
 xdp_frames in efx_tx_buffer
Message-ID: <20191031205440.54b00a7a@carbon>
In-Reply-To: <c4cb2b0b-ef5f-5d06-a98f-5a52a79494ea@solarflare.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
        <c4cb2b0b-ef5f-5d06-a98f-5a52a79494ea@solarflare.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: jK9-dpwrOYSZYzNACCvFWQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 10:23:10 +0000
Charles McLachlan <cmclachlan@solarflare.com> wrote:

> Add a field to efx_tx_buffer so that we can track xdp_frames. Add a
> flag so that buffers that contain xdp_frames can be identified and
> passed to xdp_return_frame.
>=20
> Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

