Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9352B4A03D2
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343822AbiA1WiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:38:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51328 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiA1WiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:38:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1130B8271B;
        Fri, 28 Jan 2022 22:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FCFC340E7;
        Fri, 28 Jan 2022 22:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643409501;
        bh=VhDag0BlwSgL18JQLAGYtC7PmOJGwW0NRPadhluNNiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aYeWH6I6REkKhtsWk95ArhyD2YJYro3oj6janFB8FcQxHcIEx1t59R0zG8W3GtiB4
         jgDx4UI2KhxpbUZ2WybIOwUPb7WLG2OmatzEeOxSVOwq93MgjNPjjuZqaQ1YSAxyNp
         NGZBXc9l8qWkU/1shoLx8FeHthYfK0Zl1gqye/rpIUQLZBxfgSmtqgQAUP9mujwLUY
         HKMzcjT0uanxKCJZcUyWiwlqohHfSjE2bJathedUKwdrB/PHNDcZxIRDeIO2V/V9c+
         721T7OQTUOQQAQy9yqVbHrZfdBxynsfTJAXbvo6iOGTskbLZ3HPH0690zko6yM9kcE
         Cvlh1Zu3NGBOw==
Date:   Fri, 28 Jan 2022 14:38:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        BlueZ <linux-bluetooth@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: pull request: bluetooth 2022-01-28
Message-ID: <20220128143820.21025a4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <11903531-644D-434D-95CB-6F679368475C@holtmann.org>
References: <20220128205915.3995760-1-luiz.dentz@gmail.com>
        <20220128134951.3452f557@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <11903531-644D-434D-95CB-6F679368475C@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 23:30:14 +0100 Marcel Holtmann wrote:
> > Thanks for fixing the warnings! :)
> >=20
> > I presume this is for the net-next given the name of your tree, but=20
> > a lot of patches here have fixes tags. What's your methodology on
> > separating fixes from new features?
> >=20
> > I think it may be worth adjusting the filter there and send more=20
> > stuff earlier to Linus's tree. Especially fixes with the right mix=20
> > of confidence and impact or pure device ID additions.
> >=20
> > To be clear - happy to pull this PR as is, I was meaning to ask about
> > this for a while. =20
>=20
> we started to add Fixes: tag whenever you can identify a faulty commit or
> can track down the original issue. This way we can later easily go back
> and check. It have to note that a lot of vendor trees cherrypick patches
> and this helps them picking the right ones.

Thumbs up for that!

> I reviewed the list of patches again, and frankly none of them are super
> critical to go to Linus right away.=20

My concern is that GregKH will start asking us why we hold onto trivial
fixes like 5201d23cc8e5 until the merge window, I think this merge
window has overflown his patch ID scheme ;) The risk of pushing fixes
in early -rc's should be pretty low. But your call at the end of the
day!

> So if you don=E2=80=99t mind, please pull.

Sure thing, done! :)
