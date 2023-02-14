Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FD2697042
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbjBNWBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbjBNWBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:01:51 -0500
Received: from mail-4022.proton.ch (mail-4022.proton.ch [185.70.40.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D9C16AF1
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:01:49 -0800 (PST)
Date:   Tue, 14 Feb 2023 22:01:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemb.ch;
        s=protonmail; t=1676412106; x=1676671306;
        bh=W1hF1dPLjSse3wlhGXkVExShKiQJ/enasPDR8gjQDnA=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=J+LeFw85t6J8NaJhd5b0hWCRujPoiR3MCsAXaxk4JpgnOsXsJ/CSFvJ6hI1o79Eun
         m8zCfF2fns0ggGFuQpB6F4AD2/f0GxRZaZ0FEk61EEEiE+hnFdqVhkzVYCZHYeWTv1
         ezxiL0zkywCIIoJ6gEqWo07P2HGWXohxhs0IFq7HyEvrCEmvv/dkn5vpWS1OvRQKtf
         2rKaBpiRrbOl4YMlowxZ2yHN4Uxr2JEiJKVhAhHN/CkVXKqyj87mjufiYHGFbDqsVX
         2DWzKlemvxs9wXDJ4r5xgpj2eSNNv+Jjd8ILMbkAc/my5oq8M6lS0rMjGfiWUABC9p
         O+W+l4E3UXS2g==
To:     Denis Kirjanov <dkirjanov@suse.de>
From:   Marc Bornand <dev.mbornand@systemb.ch>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yohan Prod'homme <kernel@zoddo.fr>, stable@vger.kernel.org
Subject: Re: [PATCH v4] Set ssid when authenticating
Message-ID: <Y+wEtf2dy8hXWYA4@opmb2>
In-Reply-To: <13e8e0bb-b2a2-e138-75c0-54e61a5d679e@suse.de>
References: <20230214132009.1011452-1-dev.mbornand@systemb.ch> <13e8e0bb-b2a2-e138-75c0-54e61a5d679e@suse.de>
Feedback-ID: 65519157:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 04:27:27PM +0300, Denis Kirjanov wrote:
>
>
> On 2/14/23 16:20, Marc Bornand wrote:
> > changes since v3:
> > - add missing NULL check
> > - add missing break
> >
> > changes since v2:
> > - The code was tottaly rewritten based on the disscution of the
> >   v2 patch.
> > - the ssid is set in __cfg80211_connect_result() and only if the ssid i=
s
> >   not already set.
> > - Do not add an other ssid reset path since it is already done in
> >   __cfg80211_disconnected()
> >
> > When a connexion was established without going through
> > NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
> > Now we set it in __cfg80211_connect_result() when it is not already set=
.
>
> A couple of small nits
>
> >
> > Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
> > Fixes: 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
> Please add a test description to the fixes tag

What do you mean by "test description" ?

Marc

