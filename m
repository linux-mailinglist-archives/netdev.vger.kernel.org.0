Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE57636182
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238410AbiKWOVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237973AbiKWOVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:21:16 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66FF67F6F;
        Wed, 23 Nov 2022 06:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=gOnqganAZWQOSIffj8IaCnX60MKAiAAQTQvL8bgR30U=;
        t=1669213254; x=1670422854; b=QvG/HXnOb45MTdkeYAumtgS3nnW7O/7GvsI6COuSqdqq7Gq
        +GPlBolgxeVxYdiLLn5sgXO0EPMre9Nnbk9NuXGkc5STUSgkD6jY8y6N+Qx9bYpOHNYSMVhiTmMTY
        Etlxyi5T6PWHyDAKc7LjIclEGpMejK/Zm+/ArsLtE+IuPkidRMOoql1ZrWhei+B6yvbLPyBeKPZ84
        vFLx1fu2qxiBaeIfHJ38BrKvuZwM7lJteiYtL3Wje0DnVfJIDT2wIPI8qbi5K0WCQcL5/3cMstKZG
        lh/3oWcuoWv43mRJNkKkvZ8XGJzHii03KeQq2kmi8B/Ey42sqVaEf8liR69Kirww==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oxqcA-007Dnn-22;
        Wed, 23 Nov 2022 15:20:38 +0100
Message-ID: <9b78783297db1ebb1a7cd922be7eef0bf33b75b9.camel@sipsolutions.net>
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Date:   Wed, 23 Nov 2022 15:20:36 +0100
In-Reply-To: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
References: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
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

On Wed, 2022-11-23 at 13:46 +0100, Greg Kroah-Hartman wrote:
> The Microsoft RNDIS protocol is, as designed, insecure and vulnerable on
> any system that uses it with untrusted hosts or devices.  Because the
> protocol is impossible to make secure, just disable all rndis drivers to
> prevent anyone from using them again.
>=20

Not that I mind disabling these, but is there any more detail available
on this pretty broad claim? :)

johannes
