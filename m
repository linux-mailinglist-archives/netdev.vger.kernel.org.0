Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2696B7242
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCMJOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjCMJON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:14:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA7B1A495;
        Mon, 13 Mar 2023 02:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=yJeJWbveb2PUrxFaZSQJ/Gk+d74Lqp5j3cfm1n65T98=;
        t=1678698830; x=1679908430; b=vzvn+aU01y6eaV7t79cO0u1K9+GN3rc5oGoe5wuK8e9Xzkk
        4384MCE7xapZ8DSF65jDQWiJG7MkwAufnUwPZNb6snEVzytfktHFKAg0zBK3cq1f78LOSfyOE5jw0
        3yI6mRebDvcHx1Zo7ppWdyAp496a8pufS6Ow6Tzd5Ld5I+XAEOxrgpFiL6yB2LhOQJkw9v/kcnuoA
        gv6/MfdApLdxumnkGuaRH+xJn9ttxq+9FchAH4MnVcY7BtqaDisdSkG6/IJ4s8FI1ykV7pm9WAtTl
        ELBWIiBTCiSsFeCFcyBDvaiJrj4nm+LdSinlYqXrfjY61DKeyragZoTGmM61Zt5A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pbeFR-0026zs-3B;
        Mon, 13 Mar 2023 10:13:42 +0100
Message-ID: <27fdfff6029bc3b8c9ee822a16596e2bac658359.camel@sipsolutions.net>
Subject: Re: pull-request: wireless-2023-03-10: manual merge
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 13 Mar 2023 10:13:41 +0100
In-Reply-To: <be8f3f53-e1aa-1983-e8fb-9eb55c929da5@tessares.net>
References: <20230310114647.35422-1-johannes@sipsolutions.net>
         <be8f3f53-e1aa-1983-e8fb-9eb55c929da5@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
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

On Mon, 2023-03-13 at 09:04 +0100, Matthieu Baerts wrote:
> FYI, we got a small conflict when merging -net in net-next in the MPTCP
> tree due to this patch applied in -net:
>=20
>   b27f07c50a73 ("wifi: nl80211: fix puncturing bitmap policy")
>=20
> and this one from net-next:
>=20
>   cbbaf2bb829b ("wifi: nl80211: add a command to enable/disable HW
> timestamping")
>=20

Right, overlapping changes/additions.

I suspect there isn't much I can do about it at this point, other than
merging wireless into wireless-next and then sending a pull request for
that, but that seems a bit pointless?

Jakub, any preferences?

johannes
