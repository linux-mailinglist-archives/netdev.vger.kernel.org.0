Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB66E103FD0
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 16:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732541AbfKTPqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 10:46:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39938 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732399AbfKTPpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 10:45:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574264731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2hG5olfhwZGBM67vgd4bYQYqUBc004Huy5CuuRgdDA=;
        b=YOrZ/LpV2bnI6U97+ulfz+R7rHEFgMQCyx4iYCWvCN4YE7u9/InMC3Y2JyuyHup+xCF8SK
        BTH6wOzGpL4UDlBgB+0/UnD71w4WGRJGWkQvZLh5adhtVBbkkDDd+j4tW0kamrRJYEcNJB
        8Jt2J/HBcSRA1dMxV5nMow+NORVCCp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-DNaWSHkhNkmWcCCHvuJvsg-1; Wed, 20 Nov 2019 10:45:30 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 227171005509;
        Wed, 20 Nov 2019 15:45:29 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FB0F1042B7D;
        Wed, 20 Nov 2019 15:45:21 +0000 (UTC)
Date:   Wed, 20 Nov 2019 16:45:19 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v5 net-next 1/3] net: mvneta: rely on
 page_pool_recycle_direct in mvneta_run_xdp
Message-ID: <20191120164519.219120fb@carbon>
In-Reply-To: <3642c3152a5d8ae30acac1f43097966511c438c2.1574261017.git.lorenzo@kernel.org>
References: <cover.1574261017.git.lorenzo@kernel.org>
        <3642c3152a5d8ae30acac1f43097966511c438c2.1574261017.git.lorenzo@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: DNaWSHkhNkmWcCCHvuJvsg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 16:54:17 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Rely on page_pool_recycle_direct and not on xdp_return_buff in
> mvneta_run_xdp. This is a preliminary patch to limit the dma sync len
> to the one strictly necessary
>=20
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

