Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFD63CFA3B
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbhGTMcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:32:18 -0400
Received: from pop31.abv.bg ([194.153.145.221]:56286 "EHLO pop31.abv.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhGTMb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 08:31:58 -0400
Received: from smtp.abv.bg (localhost [127.0.0.1])
        by pop31.abv.bg (Postfix) with ESMTP id 83F2B1805D3C;
        Tue, 20 Jul 2021 16:12:20 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=abv.bg; s=smtp-out;
        t=1626786740; bh=OT9jddZ9IbYhmTj9W47jx8pGykD1QbU01xlL+GH6IY8=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=Zl8rqIHN8lVTpewuQsOlMos1iBHzyWpCq+LDlUaMP1bh+T9kkBOYDVDfYnKMatArm
         VD4vp0IRZgaVXqLFTq3RvyRRZdy+xwccwd5U+Rrp1D11uZE+tB+MXJ+zV85puHAMLg
         d74L/C+wKOWqazhzGCS8ejDQ3Lyznt8OFTDQtjlw=
X-HELO: smtpclient.apple
Authentication-Results: smtp.abv.bg; auth=pass (plain) smtp.auth=gvalkov@abv.bg
Received: from 212-39-89-148.ip.btc-net.bg (HELO smtpclient.apple) (212.39.89.148)
 by smtp.abv.bg (qpsmtpd/0.96) with ESMTPSA (ECDHE-RSA-AES256-GCM-SHA384 encrypted); Tue, 20 Jul 2021 16:12:20 +0300
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
From:   Georgi Valkov <gvalkov@abv.bg>
In-Reply-To: <YPbHoScEo8ZJyox6@kroah.com>
Date:   Tue, 20 Jul 2021 16:12:06 +0300
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        mhabets@solarflare.com, luc.vanoostenryck@gmail.com,
        snelson@pensando.io, mst@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        corsac@corsac.net, matti.vuorela@bitfactor.fi,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AEC79E3B-FA7F-4A36-95CE-B6D0F3063DF8@abv.bg>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
 <20210720122215.54abaf53@cakuba>
 <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg> <YPa4ZelG2k8Z826E@kroah.com>
 <C6AA954F-8382-461D-835F-E5CA03363D84@abv.bg> <YPbHoScEo8ZJyox6@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you, Greg!

git send-email =
drivers/net/0001-ipheth-fix-EOVERFLOW-in-ipheth_rcvbulk_callback.patch
...
Result: OK

I hope I got right. I added most of the e-mail addresses, and also tried =
adding Message-Id.
I have not received the e-mail yet, so I cannot confirm if it worked or =
not.

Georgi Valkov


> On 2021-07-20, at 3:54 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Tue, Jul 20, 2021 at 03:46:11PM +0300, Georgi Valkov wrote:
>> Yes, I read it, and before my previous e-mail that I also read the =
link from Jakub,
>> which essentially provides the same information.
>>=20
>> There is only one patch =
0001-ipheth-fix-EOVERFLOW-in-ipheth_rcvbulk_callback.patch
>=20
> Great, send that using 'git send-email' and all is good.
>=20
>> The command I used from the example also generated a =
0000-cover-letter, so
>> I included it as well.
>=20
> Why do you need a cover letter for 1 patch?
>=20
> thanks,
>=20
> greg k-h
>=20

