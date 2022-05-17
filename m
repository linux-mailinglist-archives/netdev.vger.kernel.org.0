Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B67352A9DA
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351733AbiEQSDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351728AbiEQSDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:03:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168FC3F88C;
        Tue, 17 May 2022 11:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=q+RecylktAwR687l+V8VNYANCujHqskNlwbFHpY2uCU=;
        t=1652810602; x=1654020202; b=pUYgcEv6JAzhUOkPiO+Rxmrd7kELI0HHCl7LzF+O0bNUOb7
        KKYba32EuvCQjfBjk7iY+gH90O86oOpFHDbSKNEs18avlp243PbTBjuvAC3Cs+n8qK6laIcqmrXPn
        F/eq+sj9XAZfDvfttm0opCCNgzPPi9F+Q1xA5/jHibnsB4rM4fsC6z8tNa/Rz1yg+3i+Mm0O34ci+
        jnbfFEIx76fKj3Oc1BkMElAHi+PKIHUYLfOyMPETuht4NwZJoH7AUksf57k4I/y/rLRmtnIGIzpHS
        XKesGAAWMzsa7Ogq5FHhJs7hcY0O0ZQBNn7Vw2ZlK7R1fqscjRm17Q+qyphQNrqg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nr1XG-00EVCp-Hm;
        Tue, 17 May 2022 20:03:06 +0200
Message-ID: <8e2b5378a073006e99d46f648c0cacd31daf2e2c.camel@sipsolutions.net>
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct
 net_device
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, alex.aring@gmail.com, stefan@datenfreihafen.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan@vger.kernel.org
Date:   Tue, 17 May 2022 20:03:05 +0200
In-Reply-To: <20220517104443.68756db3@kernel.org>
References: <20220516215638.1787257-1-kuba@kernel.org>
         <8b9d18e351cc58aed65c4a4c7f12f167984ee088.camel@sipsolutions.net>
         <20220517104443.68756db3@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
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

On Tue, 2022-05-17 at 10:44 -0700, Jakub Kicinski wrote:
>=20
> Would you be willing to do that as a follow up?=C2=A0
>=20

Sure.

> Are you talking about
> wifi only or all the proto pointers?

Well it only makes sense if at least two protocols join forces :-)

> As a netdev maintainer I'd like to reduce the divergence in whether=20
> the proto pointers are ifdef'd or not.
>=20
Sure, no objection to the ifdef.

johannes

