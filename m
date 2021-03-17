Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7DA33F2B8
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCQOfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhCQOfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:35:04 -0400
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50F8C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:35:03 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id F30F714056C;
        Wed, 17 Mar 2021 15:35:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1615991701; bh=aSfCZVq6Yvr1iFLWg8vlyU7IowZorbySoFryzrXlSsI=;
        h=Date:From:To;
        b=e08bZCqllKSW6u14uFSe0jiGOoBfsmlWOm2/A+BxHw/3bTAoZAXTC/6WjB47jo6Os
         wOqWyX7Y4l07tmZeJu5ayD+SdsvHGq4RKqsMLoDUcnRE1pcQo5gjhjp9zmv91KzYw9
         tqu0vXkTz6rB7DSWEr2z/vOwatqqu0OUiuYTv4tI=
Date:   Wed, 17 Mar 2021 15:34:33 +0100
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?ISO-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        lkp@intel.com
Subject: Re: [PATCH net-next v17 2/4] net: dsa: mv88e6xxx: wrap
 .set_egress_port method
Message-ID: <20210317153433.5b761964@dellmb.labs.office.nic.cz>
In-Reply-To: <20210317142235.jgkv2q3743wb47wt@skbuf>
References: <20210317134643.24463-1-kabel@kernel.org>
        <20210317134643.24463-3-kabel@kernel.org>
        <20210317142235.jgkv2q3743wb47wt@skbuf>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Mar 2021 16:22:35 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Wed, Mar 17, 2021 at 02:46:41PM +0100, Marek Beh=FAn wrote:
> > There are two implementations of the .set_egress_port method, and
> > both of them, if successful, set chip->*gress_dest_port variable.
> >=20
> > To avoid code repetition, wrap this method into
> > mv88e6xxx_set_egress_port.
> >=20
> > Signed-off-by: Marek Beh=FAn <kabel@kernel.org>
> > Reviewed-by: Pavana Sharma <pavana.sharma@digi.com>
> > --- =20
>=20
> Separately from this series, do you think you can rename the
> "egress_port" into "monitor_port" across the driver? Seeing an
> EGRESS_DIR_INGRESS is pretty strange.

You mean even renaming methods .set_egress_port to .set_monitor_port,
and type
  enum mv88e6xxx_egress_direction
to
  enum mv88e6xxx_monitor_direction?

