Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10856817F2
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbjA3RqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbjA3RqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:46:02 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 09:45:58 PST
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3563A5AB
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:45:58 -0800 (PST)
X-KPN-MessageId: d4b8a581-a0c5-11ed-91cc-005056994fde
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
        by ewsoutbound.so.kpn.org (Halon) with ESMTPS
        id d4b8a581-a0c5-11ed-91cc-005056994fde;
        Mon, 30 Jan 2023 18:45:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=xs4all.nl; s=xs4all01;
        h=content-type:mime-version:message-id:subject:to:from:date;
        bh=egecAELvy3fc5Lc2up0e0pNF08ItK3T91uHfd0x1W40=;
        b=BSJ2CHdBwhTV+6piy0EdJkv4SvZJi7InS8HchXX19rr8NxaFIWDYCmNgPaX+cLBRQE7nSswJ4qpFl
         f6s8gCpAb8VG+rYw/SQpGD7ntsYgOIx0kzKSDcv9sFbgsOMqND8MUqumlI5YZZJ9CX0K1fVZlp3Hoo
         bmkTXoYMnHxb4OQz5mXAGrrPQ5JEK0lvnK5E7PtL5X7G7SlihcJGCP2rFEh5VvuLhDclxOPzo/EBnH
         zkjrSAwdUAV3WtFXNA8gSMX7EqlVorBnSB8UwtJFEa+WScoph8M7qcThkArorey1A/7wK3ixjlGyQV
         lngJej4PDL3ijLKe2XGKpZwwOP28atA==
X-KPN-MID: 33|uG2qTDGm7VRaGx01Slvevk6/cYO3HMz3CpCOsWAZc5RWALm+Vla5wEt52Xi+npg
 i0LK87PUO3WYZmOoEbRtknfZJcFfYWs+QFumg9FclCiw=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|ZnsCBYokoh1nSuSGZd8HEje/2t/Ostr0GqRdu/yE2TE4FPP7Mg8uMJafhqfeS9Y
 zeEHTWKYchEZsd5j7+SYCBA==
X-Originating-IP: 86.86.234.244
Received: from wim.fritz.box (86-86-234-244.fixed.kpn.net [86.86.234.244])
        by smtp.xs4all.nl (Halon) with ESMTPSA
        id cd50c40e-a0c5-11ed-9e25-00505699b758;
        Mon, 30 Jan 2023 18:44:53 +0100 (CET)
Date:   Mon, 30 Jan 2023 18:44:52 +0100
From:   Jeroen Roovers <jer@xs4all.nl>
To:     Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?= <j.neuschaefer@gmx.net>
Cc:     netdev@vger.kernel.org, Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: tulip: Fix typos ("defualt" and "hearbeat")
Message-ID: <20230130184452.396762f8@wim.fritz.box>
In-Reply-To: <20230129195309.1941497-1-j.neuschaefer@gmx.net>
References: <20230129195309.1941497-1-j.neuschaefer@gmx.net>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Jan 2023 20:53:08 +0100
Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net> wrote:

> Spell them as "default" and "heartbeat".
>=20
> Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> ---
>=20
> v2:
> - also fix "hearbeat", as suggested by Simon Horman
> ---
>  drivers/net/ethernet/dec/tulip/tulip.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/dec/tulip/tulip.h
> b/drivers/net/ethernet/dec/tulip/tulip.h index
> 0ed598dc7569c..10d7d8de93660 100644 ---
> a/drivers/net/ethernet/dec/tulip/tulip.h +++
> b/drivers/net/ethernet/dec/tulip/tulip.h @@ -250,7 +250,7 @@ enum
> t21143_csr6_bits { csr6_ttm =3D (1<<22),  /* Transmit Threshold Mode,
> set for 10baseT, 0 for 100BaseTX */ csr6_sf =3D (1<<21),   /* Store and
> forward. If set ignores TR bits */ csr6_hbd =3D (1<<19),  /* Heart beat
> disable. Disables SQE function in 10baseT */

If you are going to put "heartbeat" in the title of the patch, you may
want to fix "Heart beat" to match here as well. :-)


Kind regards,
     jer
