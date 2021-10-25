Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A8743A48B
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhJYU0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:26:36 -0400
Received: from mout.gmx.net ([212.227.17.21]:45897 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234465AbhJYU0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1635193435;
        bh=/gKvEpquA5aR5ZOHHcEDKAS6FjerAsQEl5z4uJ25bK4=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=gTSDyJy44IyL3RCtOnkTJ9myDddUH5HaLFGZGNB+XAee6dUYD6aqMo7fhLZQQsdnC
         JtUzzTCCKFBZpVax9610JkVbZiEfXEGTrk6UEZgkXfli1p6Kcs/3S1zirKUrx+ZcGE
         si69sH/5EIvUxjvrIU273NyMIQ3x23CtHV6BhBM8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [91.64.35.151] ([91.64.35.151]) by web-mail.gmx.net
 (3c-app-gmx-bap58.server.lan [172.19.172.128]) (via HTTP); Mon, 25 Oct 2021
 22:23:55 +0200
MIME-Version: 1.0
Message-ID: <trinity-50d23c05-6cfa-484b-be21-5177fcb07b75-1635193435489@3c-app-gmx-bap58>
From:   Robert Schlabbach <Robert.Schlabbach@gmx.net>
To:     netdev@vger.kernel.org
Subject: ixgbe: How to do this without a module parameter?
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 25 Oct 2021 22:23:55 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:VOPrQiA9CsT//cUPAp3V2OGE6pA2x/Y8osgW5WrbrHDBE2Ier70FQ5+5zxv/3RXIOXoUp
 45pfnyArZmuG79IIKkfjEMMve22N8sdX4O3NdPhi9ujX//S5k9VRD9C73VfjNDxoloG++FuWlIuW
 0NmyGHoZIcQlbTLAjkSa3N0ou5irUF8SFtfeF9rYVeUFRbfgU1zHA3/+Kbeet/oZZ0a+jCtnWS3u
 DPT0W2SGt2vNn15USrSCZxzsrROf/nZO5TTwDM31qsXP+aD4/jPIdZ6myCOeFMsE2q/bvHZwZjyD
 EM=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HKh9wM+VhBc=:QJpCrCc4XJF3iL6/k0wRL6
 zk6bJJbeLVKFKo4WMKJhglR01VjiEBk7iiGssdXV3YlAtBMDt8M1GQg5mk5zRrj7vnK5A2m3c
 9VKzeWyVGQUuLWBajYVU8Ws114odVrH8I5C2IR6+SjRfRPqQ/hqyAJl8CdZ9hNY9Emkf0m1bC
 gj5iCMUbZKbBVJ1okfm6zco5r6x0jxWoBVjBQU9/wIA0DGWdbiF+jPNtGkffncawwF8vbNb1I
 TeAMllXF3Ykx2CqU4uQhqUrwMwX/tnvwLt6Ltl/cjXZ8cPP4d1QN+do/lLHWmSfvkEPsmRnWi
 FzLjV4lmhlU9xAF/+zXkVEs8JIt6xE2XSdajEBQI1eo21M5wfA3Jz1CCNXwxpRdbn8jzPdnZx
 wDElrpqye5II1c9s/EuhxRodnf6hYhdeWuscC+tdkCsV4CWaOacAjrMr5H+IWMcaYt0p0uLEC
 ogC3n9mtpVE/PE5b6TLgKxXJcIUx/emLKQQ58Z0xA2j2Ne+shvRG/SflpJt9/Uhx98YbG+ueE
 DBu/aQxiHb727pQT4HNoKWBRvPFpbTVc12aH11By4Ry3byWRtj8idbHLFwwoNjVkR6fG0soeV
 Bi/vNDyXaE1HxaOb8XKBMfgyk2RmhxxIEvEJsZTG77nPw0WSiLxKJy31nK8VPYUzSVRmipADo
 t1J8Shti4fqcFa5YWZRUV0SgSfVSvkzPC7+FmO8H7+4W6zW6zwEn+pufeG5hh/3Wg0BxoB2QN
 XSVPetjopB2yV6Qo2V4ckzUg22dX/Ny+VCo78yJl6suS98VBEnUMoKpVMXfA2pLhGLuENX9jV
 VUUHzeb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A while ago, Intel devs sneaked a hack into the ixgbe driver which disables
NBASE-T support by default:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c?id=a296d665eae1e8ec6445683bfb999c884058426a

Only after a user complaint, Intel bothered to reveal their reason for this:

https://www.mail-archive.com/e1000-devel@lists.sourceforge.net/msg12615.html

But this comes at the expense of NBASE-T users, who are left wondering why their
NIC (which Intel sells as supporting NBASE-T) only comes up with GbE links. To
fix this, I submitted this patch:

https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20211018/026326.html

However, Intel devs pointed out to me that private module parameters would no
longer be accepted. Indeed, after some search I found this in the archive:

https://lore.kernel.org/netdev/20170324.144017.1545614773504954414.davem@davemloft.net/

The reason given there is that a module parameter is the "worst user experience
possible". But I think the absolutely worst user experience possible is having
to figure out a complex script that:

- compiles a list of all net devices provided by the ixgbe module
- retrieves the supported link speeds and converts them to a hex mask
- ORs the NBASE-T speeds into this hex mask
- finally runs ethtool to set the hex mask of the speeds to advertise

Even as a developer with 10 years experience with Linux, I would have to spend
quite a while writing such a script, and then figuring out how to have it
executed at the right time during startup. I suppose the vast majority of
Linux admins would be overwhelmed with that.

In contrast, explaining how to set the module parameter to control NBASE-T
support is a two-liner, see my patch above where I added that to the ixgbe.rst
module documentation. I think that's feasible for most Linux admins.

So my question is: Can anyone come up with a solution allowing to control
NBASE-T support in the ixgbe module in a way that's feasible for most Linux
admins, that works without a module parameter?

If not, could an exception be made for this patch to allow an extra parameter
for the ixgbe module?

Or does anyone have an even better idea?

Best regards,
-Robert Schlabbach

