Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E607959C899
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbiHVTVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238626AbiHVTUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:20:52 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB7750183;
        Mon, 22 Aug 2022 12:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=+7qd52N+R+Sb4ct0/RwuDfez59xnxOcYNoEXOOggkG8=;
        t=1661195987; x=1662405587; b=gHAICJVkWzz3irH3yLRMXjJmfIFhT4+odxyb/DZjOTqgtq/
        roLjB41mFKJYuzUEFosFe5AQVJpEa5cfGGa48OFl+DpWypq6DmUrCX3omFQG0jyaceMG8ZwIPtZlk
        cByPuFcJazv89Nliz8RrVT701jAI8Cbjm67G2j2P+kLYkYwPEItsO46lWr3HX6pUl4j8r9Brp0rSr
        VcQhWTZJ8SXRApPkENOzHoZW7UpJBXl2bR9BILFAyuGGZzLllv6Nz9lnTB1PcjbkDyAPZvwO1YVum
        uLMLRq2zRMtPF2jZOsPJzCaWPf1Hp75Ub/kRuXwCo2Xjt7FqdqLh02N4ukx90/pg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oQCxX-00Edep-2e;
        Mon, 22 Aug 2022 21:19:39 +0200
Message-ID: <7f9a39d1d1557afa09aa8b657a40f0c03e621cfa.camel@sipsolutions.net>
Subject: Re: Aw: Re:  Re: help for driver porting - missing member
 preset_chandef in struct wireless_dev
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 22 Aug 2022 21:19:38 +0200
In-Reply-To: <trinity-94aeced0-7aab-4359-9c74-1616a17464bd-1661187572028@3c-app-gmx-bap06>
References: <trinity-de687d18-b2a2-4cde-9383-a4d6ddba6a77-1661177057496@3c-app-gmx-bap06>
         <b081ef6eb978070740f31f48a1f4be1807f51168.camel@sipsolutions.net>
         <trinity-64c5eed8-8b6b-4b33-9204-89aff4fce7db-1661186571606@3c-app-gmx-bap06>
         <51a1b56a4d9ed825cb47cf364c5bd72f3338a1a6.camel@sipsolutions.net>
         <trinity-94aeced0-7aab-4359-9c74-1616a17464bd-1661187572028@3c-app-gmx-bap06>
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

On Mon, 2022-08-22 at 18:59 +0200, Frank Wunderlich wrote:
> > Gesendet: Montag, 22. August 2022 um 18:43 Uhr
> > Von: "Johannes Berg" <johannes@sipsolutions.net>
>=20
> > On Mon, 2022-08-22 at 18:42 +0200, Frank Wunderlich wrote:
>=20
> > > thanks for response, commented out the use of the member and the
> > > wdev
> > > assignment as it was then unused
> > > can you tell me which api-call this should be?
> > > i just want to make sure this is really done as i up-ported the
> > > driver
> > > from 4.9, so if the api-call was introduced later it is maybe
> > > missing.
> >=20
> > No sorry, I don't know how the driver was/is using it, so I can't
> > tell
> > you how to replace it.
>=20
> can you give me possible calls (if there are multiple candidates)
> which may set the channel (without mesh)
> for me to check or maybe implement?

Well it seems to access it inside the start_ap callback, so it should
just check the configuration instea
