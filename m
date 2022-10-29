Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690A6612555
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 22:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJ2Uyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 16:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJ2Uyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 16:54:45 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19C312A99;
        Sat, 29 Oct 2022 13:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=CNjyzWt288CCW6R/x1OIEnm0pp7lSqIe3AQITuIYZAI=;
        t=1667076882; x=1668286482; b=YNodu80fxKT6g/wTkEsDPtr3DiBzSZkgaxQMtQuaIClB9Sl
        Yo9J6ElI16mGDFUV66bhiONyBdAay7TD363fxsnTVPBKD5/cvFZ2VtPA1sQYDyXw1Do76zjGLIBZ6
        byLPFdpXq/o2Pe01N+XDHCOq9uLhqLaAPIM5u+nt5cWtqTUuqNCIq3RW54BVrxaGoloZxk0bR+ils
        Sgh0p2tAQS3Z6lqUDMXLwNtc2B57O70mfMaV8sJ6gK31tvRLsUWsWy7b7D0Le+YdOdFFG35Rjx8K4
        wB1DRW8lmpxI3GyrPTgMchM//70Nr8VIggDlzhg7bWNEJgj4YhqtutQg9oIb5kUA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oosql-002VYh-2y;
        Sat, 29 Oct 2022 22:54:40 +0200
Message-ID: <7193d1bcfcff1ea5eb83558923ada5530c8d3c9f.camel@sipsolutions.net>
Subject: Re: pull-request: wireless-next-2022-10-28
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Sat, 29 Oct 2022 22:54:39 +0200
In-Reply-To: <20221028183439.2ff16027@kicinski-fedora-PC1C0HJN>
References: <20221028132943.304ECC433B5@smtp.kernel.org>
         <20221028183439.2ff16027@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-10-28 at 18:34 -0700, Jakub Kicinski wrote:
> >=20
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@@ -1506,7 -1648,7 +1650,7 @@@ ieee802_11_parse_elems_full(struct ieee
> >         const struct element *non_inherit =3D NULL;
> >         u8 *nontransmitted_profile;
> >         int nontransmitted_profile_len =3D 0;
> > -       size_t scratch_len =3D params->len;
> >  -      size_t scratch_len =3D params->scratch_len ?: 2 * params->len;
> > ++      size_t scratch_len =3D params->scratch_len ?: 3 * params->len;
> >=20
> >         elems =3D kzalloc(sizeof(*elems) + scratch_len, GFP_ATOMIC);
> >         if (!elems)
> >=20
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-n=
ext.git/commit/?id=3Ddfd2d876b3fda1790bc0239ba4c6967e25d16e91
> > [2] https://lore.kernel.org/all/20221020032340.5cf101c0@canb.auug.org.a=
u/
>=20
> Thanks! I only saw one conflict FWIW
>=20

Hah. Me too, when I tried this to see what the resolution should be. Git
versions or something?

johannes
