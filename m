Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5198E68A9B3
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 12:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjBDLrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 06:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDLrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 06:47:03 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A161A1C58A;
        Sat,  4 Feb 2023 03:47:00 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DE850240004;
        Sat,  4 Feb 2023 11:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675511219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2MtimoPGK5W+L7BNE+YgGn6mv6E8hpu9Qc7WvUx1WQA=;
        b=FtV2rSPn2aHJmRLrOLa5NZJP3CluEB+xj09xDl08/dLB3YV2r+0uaoZ67KlrvoM0CjMqb4
        EJKmV534Q5Xl+0u/4YhF8jtaIgWjUe4an5+8jGMFYl2YqWbjptHyLjYXUerA8Pl0KlZB3G
        xwsD24kIhjKqpKI+SsQsSsM49mTjgXPVH9NaeUoWY8f6cDiFgl/kLz0qqquz8j7PUYkivu
        EQ/LrO/l5pS2+zDPEesK6+zR7jaAwZEJIzkfTHeP4YcSbF4RR+vpufC76Nywi/O9IAbJ2N
        v0yX8JqQL+q/y0lmbLGtVxSaAcN/OSSOcwsCmhvHBYlmfuH+sE6gBKtm28ekaw==
Date:   Sat, 4 Feb 2023 12:46:56 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>, davem@davemloft.net,
        linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull-request: ieee802154-next 2023-02-02
Message-ID: <20230204124656.470db6b7@xps-13>
In-Reply-To: <20230203202147.56106b5b@kernel.org>
References: <20230202153723.1554935-1-stefan@datenfreihafen.org>
        <20230203202147.56106b5b@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

kuba@kernel.org wrote on Fri, 3 Feb 2023 20:21:47 -0800:

> On Thu,  2 Feb 2023 16:37:23 +0100 Stefan Schmidt wrote:
> > Miquel Raynal build upon his earlier work and introduced two new
> > features into the ieee802154 stack. Beaconing to announce existing
> > PAN's and passive scanning to discover the beacons and associated
> > PAN's. The matching changes to the userspace configuration tool
> > have been posted as well and will be released when 6.3 is ready. =20
>=20
> I left some comments on the netlink part, sorry for not looking=20
> at it earlier.

As I'm not extremely comfortable with all the netlink conventions I
might have squeezed "important" checks, I will try to make the code
more robust as you suggested.

I will do my best to address these, probably next week, do you prefer
to wait for these additional changes to apply on top of wpan-next and
Stefan to rush with another PR before -rc8? Or do you accept to pull the
changes now and to receive a couple of patches in a following fixes
PR? (the latter would be the best IMHO, but it's of course up to you).

Thanks,
Miqu=C3=A8l
