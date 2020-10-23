Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636E6297226
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465720AbgJWPWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S461976AbgJWPWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 11:22:13 -0400
X-Greylist: delayed 335 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Oct 2020 08:22:13 PDT
Received: from confino.investici.org (confino.investici.org [IPv6:2a00:c38:11e:ffff::a020])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AA7C0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 08:22:13 -0700 (PDT)
Received: from mx1.investici.org (unknown [127.0.0.1])
        by confino.investici.org (Postfix) with ESMTP id 4CHnrJ6Vb2z12mW;
        Fri, 23 Oct 2020 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1603466192;
        bh=zwyYFuxvaBt4KIpY975rk0ZV3MFjtqKqJl69cm8F9Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrNAQiY8Vzy9yksym1IOUQIIyp3S4A741LOBsNSFLt5K+QUh5YD7m91j20AqsYhYk
         UCDHAcpnevssHa9enJPXG60YeLTRxt+EvPxsLMZ76roqYzcb7Q7Cf3UGKNItzg+9U6
         MnojlPS/BeRcVfIWVkGQpn3kRXg9oC3ElOaVYGDg=
Received: from [212.103.72.250] (mx1.investici.org [212.103.72.250]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CHnrJ55Rbz12lk;
        Fri, 23 Oct 2020 15:16:32 +0000 (UTC)
From:   Francis Laniel <laniel_francis@privacyrequired.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [RFC][PATCH v3 3/3] Rename nla_strlcpy to nla_strscpy.
Date:   Fri, 23 Oct 2020 17:16:32 +0200
Message-ID: <6007556.b03v0mpVyF@machine>
In-Reply-To: <20201022160551.33d85912@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201020164707.30402-1-laniel_francis@privacyrequired.com> <202010221302.5BA047AC9@keescook> <20201022160551.33d85912@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le vendredi 23 octobre 2020, 01:05:51 CEST Jakub Kicinski a =E9crit :
> On Thu, 22 Oct 2020 13:04:32 -0700 Kees Cook wrote:
> > > > > From: Francis Laniel <laniel_francis@privacyrequired.com>
> > > > >=20
> > > > > Calls to nla_strlcpy are now replaced by calls to nla_strscpy whi=
ch
> > > > > is the
> > > > > new name of this function.
> > > > >=20
> > > > > Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
> > > >=20
> > > > The Subject could also be: "treewide: Rename nla_strlcpy to
> > > > nla_strscpy"
> > > >=20
> > > > But otherwise, yup, easy mechanical change.
> > >=20
> > > Should I submit a v4 for this change?
> >=20
> > I'll say yes. :) Drop the RFC, bump to v4, and send it to netdev (along
> > with all the other CCs you have here already), and add the Reviewed-bys
> > from v3.
>=20
> Maybe wait until next week, IIRC this doesn't fix any bugs, so it's
> -next material. We don't apply anything to net-next during the merge
> window.

I will wait for next Friday to submit the v4.



