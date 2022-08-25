Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACDA5A092C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 08:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiHYGv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 02:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236411AbiHYGv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 02:51:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF76A0637
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 23:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Ze8wsywP4VHt6nr4EjsA85VYgSk/IAZKpMwTVDNFXVg=;
        t=1661410315; x=1662619915; b=Wab+wWaglQzzWZrzUaE8SVL1skeIhC1U338o2FTnDGWY4RS
        lPs/chkFs4LgHDAQglZlSj64Wrvyd8wIZc98QVOm/FmhskYr3++5sSLLk0vNTpnCDJs6qnKc0ogO9
        yNZCbh+PhG/H+ujxeDXNjCXhKBm6Noxf9EWY92FyIqAG3gCmjnNi6clY+5tZs+gkxJQEnXEJi9/q4
        R+TrjkLGYHaJOf05LC6nFijrC0/lLmiuw9GjbsWYpIuC83HmsG5xEUDzbGG6nrEdwlR83BeDmdo+j
        uQByuBG+29Vi4kDzgGL1tfjP27VeW8q1XqbnsKsBQcwKU5pw044FHSjxA3t30mFw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oR6iU-00Gw9d-1g;
        Thu, 25 Aug 2022 08:51:50 +0200
Message-ID: <469e6c0d835994b4d1646dbdb5b1c44e9d335e5c.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 0/6] netlink: support reporting missing
 attributes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz
Date:   Thu, 25 Aug 2022 08:51:49 +0200
In-Reply-To: <20220825024122.1998968-1-kuba@kernel.org>
References: <20220825024122.1998968-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-08-24 at 19:41 -0700, Jakub Kicinski wrote:
> This series adds support for reporting missing attributes
> in a structured way. We can't point at things which don't
> exist so we point at the containing nest or preceding
> fixed header
>=20

If you were planning to use the cover letter for anything, then that "or
preceding fixed header" should now be removed :)

Apart from the couple of nits I just sent,

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

(for the whole set)

Thanks for doing this!

johannes

