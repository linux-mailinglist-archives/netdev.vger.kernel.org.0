Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC0B5A0457
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 01:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiHXXCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 19:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiHXXCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 19:02:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2230A74DC0
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 16:02:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3A45B825ED
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 23:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D10C433D6;
        Wed, 24 Aug 2022 23:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661382151;
        bh=ET6oW/MKNIUKYULHMZH/EnDvMT/CL90bWYNwNkhP3jI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZMwYcp0t4UNE0FxePWHXHjWexqSzxuOI8tBlFsE8v5+4mfg9iWbrlhlwjgthnwJqa
         Kk3ImuNnWHa3XCOzIQfqqu4KNbeHye8pDdG6PmMpx/XzCYpMeOEWhtefbn6i0cAySW
         N7NuvU1rvjSQkooqFKxiwmDGybs6W0XGwYj603gA8q2Gn98zukBzwKjd6ukUW5ECyC
         10TCMFFCXtwrDypzlMk9CrRfdVT3nKzYo0lOxPqJ7tlWdE1SIIQ+sc+seoXjzr3bck
         DgLJaLy5Q9Q3PwTnqGrbYtLGQnCVfmHyW8ul/mrZALa0VwD78lO/cu7QBuGRnAVrgk
         dFbHr92NEJC2g==
Date:   Wed, 24 Aug 2022 16:02:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Greenwalt, Paul" <paul.greenwalt@intel.com>
Subject: Re: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC
 disabled via ETHTOOL_SFECPARAM
Message-ID: <20220824160230.3c2f06b2@kernel.org>
In-Reply-To: <CO1PR11MB5089262FADDECF5AA21DBFCAD6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <20220823150438.3613327-3-jacob.e.keller@intel.com>
        <20220823151745.3b6b67cb@kernel.org>
        <CO1PR11MB508971C03652EF412A43DD80D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220824154727.450ff9d9@kernel.org>
        <CO1PR11MB5089262FADDECF5AA21DBFCAD6739@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 22:53:44 +0000 Keller, Jacob E wrote:
> > On Wed, 24 Aug 2022 21:29:31 +0000 Keller, Jacob E wrote: =20
> > > Ok I got information from the other folks here. LESM is not a
> > > standard its just the name we used internally for how the firmware
> > > establishes link. I'll rephrase this whole section and clarify it. =20
> >=20
> > Hold up, I'm pretty sure this is in the standard. =20
>=20
> According to the folks I talked to what we have here, we didn't
> understand this as being from a standard, but if it is I'd love to
> read on it.

Table 110C=E2=80=931=E2=80=94Host and cable assembly combinations
in IEEE 802.3 2018, that's what I was thinking of.
