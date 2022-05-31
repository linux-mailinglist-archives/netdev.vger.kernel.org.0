Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22FF5394B6
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 18:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiEaQI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 12:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233267AbiEaQIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 12:08:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7D42CCA3
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 09:08:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED3C61418
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 16:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D59C385A9;
        Tue, 31 May 2022 16:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654013333;
        bh=F9rWngpEyco46ljS6xELWYNQhagHs++o4oG5+ur7Nbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bXg9gAHqLKM7AbL4fZv0iyjz9T06Fru+t98h9D1O7Gm2b7ssc7wRGIexUUEUyNyrf
         wqLZ8ZI3uybvcoy+PUDjERSQumYnkYNH0YmwyX83cKnqAH7dw+MfqX4Qz0x9ZVjLk5
         8auSUcLE5i/e2S8zERJhTRNX6zgI2iTQBal/KYLNwnBDNWQtFUT5+Pyib+1xjk2v1M
         agJXOS4GfmWbANyAgvk5Lq1W/JB6rEvbvxJL2gZftCcZK3kAuLwR/aFPVQeYl7GwYB
         nZ2OA7I41R4qrXpTViI1au1rY4Dw0fHk9PgL+AvylLTtW/KNGakHfQqBj1UkVkPBtl
         NY7tqr2qa9+QA==
Date:   Tue, 31 May 2022 09:08:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220531090852.2b10c344@kernel.org>
In-Reply-To: <YpY5iKHR073DNF7D@nanopsycho>
References: <Yo9obX5Cppn8GFC4@nanopsycho>
        <20220526103539.60dcb7f0@kernel.org>
        <YpB9cwqcSAMslKLu@nanopsycho>
        <20220527171038.52363749@kernel.org>
        <YpHmrdCmiRagdxvt@nanopsycho>
        <20220528120253.5200f80f@kernel.org>
        <YpM7dWye/i15DBHF@nanopsycho>
        <20220530125408.3a9cb8ed@kernel.org>
        <YpW/n3Nh8fIYOEe+@nanopsycho>
        <20220531080555.29b6ec6b@kernel.org>
        <YpY5iKHR073DNF7D@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 May 2022 17:51:36 +0200 Jiri Pirko wrote:
> Tue, May 31, 2022 at 05:05:55PM CEST, kuba@kernel.org wrote:
> >> Group of what? Could you provide me example what you mean? =20
> >
> >Group of components. As explained component has an existing meaning,
> >we can't reuse the term with a different one now. =20
>=20
> I still don't follow. I don't want to reuse it.
> Really, could you be more specific and show examples, please?

What you had in your previous examples, just don't call it components
but come up with a new term:

$ devlink dev info
pci/0000:01:00.0:
  driver mlxsw_spectrum2
  versions:
      fixed:
        hw.revision A0
        fw.psid MT_0000000199
      running:
        fw.version 29.2010.2302
        fw 29.2010.2302
  groups? sections? subordinates? :                         <=3D here
    lc1:
      versions:
        fixed:
          hw.revision 0
          fw.psid MT_0000000111
        running:
          fw 19.2010.1310
          ini.version 4

Note that lc1 is not a nest at netlink level but user space can group
the attrs pretty trivially.

> >> But to be consistent with the output, we would have to change "devlink=
  =20
> >> dev info" to something like:                                          =
  =20
> >> pci/0000:01:00.0:                                                     =
  =20
> >>   versions:                                                           =
  =20
> >>       running:                                                        =
  =20
> >>         fw 1.2.3                                                      =
  =20
> >>         fw.mgmt 10.20.30                                              =
  =20
> >>         lc 2 fw 19.2010.1310                                          =
    =20
> >
> >Yup. =20
>=20
> Set, you say "yup" but below you say it should be in a separate nest.
> That is confusing me.

Ah, sorry. I hope the above is clear.
                                                 =20
> >> But that would break the existing JSON output, because "running" is an=
 array:
> >>                 "running": {                                          =
  =20
> >>                     "fw": "1.2.3",                                    =
  =20
> >>                     "fw.mgmt": "10.20.30"                             =
  =20
> >>                 },                                                    =
    =20
> >
> >No, the lc versions should be in separate nests. Since they are not
> >updated when flashing main FW mixing them into existing versions would
> >break uAPI. =20
>=20
> Could you please draw it out for me exacly as you envision it? We are
> dancing around it, I can't really understand what exactly do you mean.

Why would I prototype your feature for you? I prefer a separate dl
instance. If you want to explore other options the "drawing out" is
on you :/

> >> So probably better to stick to "lcx.y" notation in both devlink dev in=
fo
> >> and flash and split/squash to attributes internally. What do you think=
? =20
> >
> >BTW how do you intend to activate the new FW? Extend the reload command?=
 =20
>=20
> Not sure now. Extending reload is an option. Have to think about it.

=F0=9F=98=91
