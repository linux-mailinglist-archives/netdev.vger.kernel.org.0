Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0AC5955B2
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiHPI5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiHPI5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:57:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558FDA4B2D;
        Tue, 16 Aug 2022 00:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=u2PBVMAPAV+XXqMRAYTwrHZEIjBBg3a7hXM7iFoy2Q8=;
        t=1660633653; x=1661843253; b=l5mvFx+dN2ndKiYOHsAUq4qi6h85d19GZdmC6urT9W/1dIP
        xhv95QXYYRsb2lAJ6a7Njt0GN6/m218WwlIPlyAAW3KjSZOm+lov0u7Wgv6Ty1XdyBTga4RrdD7hK
        eljJKLbVayWszauFLcizi7w148DZw3gZLgAFemBGP1IwuwqUMKDRbJnuiXrX0r6Q6Dq85i6tUOQVl
        yftKQ8hWleF4dHttxtFuAVBcwdsFRyyRjshKorAMzTEeoEZ2AD1aetVGfW0EVD30oBs/q4NTQkrCG
        KikBwb74M+WKy3VJW3qFH5gqI2bBrTP7ZiruollLpuqr0ZAZK0k/eSMfuQd7jLOQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oNqfT-009NUz-1M;
        Tue, 16 Aug 2022 09:07:15 +0200
Message-ID: <b5f64bfb0bcb70b0ac89143b8aabb3e383e362c3.camel@sipsolutions.net>
Subject: Re: [RFC net-next 1/4] ynl: add intro docs for the concept
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Date:   Tue, 16 Aug 2022 09:07:14 +0200
In-Reply-To: <20220815173254.1809b44a@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
         <20220811022304.583300-2-kuba@kernel.org>
         <273db0bc09c0e074a8875679e5e07ea047b61c27.camel@sipsolutions.net>
         <20220815173254.1809b44a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-08-15 at 17:32 -0700, Jakub Kicinski wrote:
> On Mon, 15 Aug 2022 22:09:29 +0200 Johannes Berg wrote:
> > On Wed, 2022-08-10 at 19:23 -0700, Jakub Kicinski wrote:
> > >=20
> > > +Note that attribute spaces do not themselves nest, nested attributes=
 refer to their internal
> > > +space via a ``nested-attributes`` property, so the YAML spec does no=
t resemble the format
> > > +of the netlink messages directly. =20
> >=20
> > I find this a bit ... confusing.
> >=20
> > I think reading the other patch I know what you mean, but if I think of
> > this I think more of the policy declarations than the message itself,
> > and there we do refer to another policy?
> >=20
> > Maybe reword a bit and say
> >=20
> >    Note that attribute spaces do not themselves nest, nested attributes
> >    refer to their internal space via a ``nested-attributes`` property
> >    (the name of another or the same attribute space).
> >=20
> > or something?
>=20
> I think I put the cart before the horse in this looong sentence. How
> about:
>=20
>   Note that the YAML spec is "flattened" and is not meant to visually
>   resemble the format of the netlink messages (unlike certain ad-hoc docu=
mentation
>   formats seen in kernel comments). In the YAML spec subordinate attribut=
e sets
>   are not defined inline as a nest, but defined in a separate attribute s=
et
>   referred to with a ``nested-attributes`` property of the container.
>=20
Yeah, that makes sense.

Like I said, I was already thinking of the policy structures (and the
policy advertisement to userspace) which is exactly the same way, so I
didn't see this as much different - but of course it _is_ different from
the message itself.

johannes
