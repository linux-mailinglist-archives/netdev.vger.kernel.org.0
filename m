Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861B43CF9D8
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 14:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhGTMGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:06:32 -0400
Received: from pop31.abv.bg ([194.153.145.221]:52826 "EHLO pop31.abv.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238265AbhGTMGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 08:06:18 -0400
Received: from smtp.abv.bg (localhost [127.0.0.1])
        by pop31.abv.bg (Postfix) with ESMTP id 63D6A1805D3D;
        Tue, 20 Jul 2021 15:46:33 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=abv.bg; s=smtp-out;
        t=1626785193; bh=3n+oId2CcuiY7DARlUQCYAgosiVIv3DRNqh5ePKuPW0=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=VtfzwQisc+8A4Ov4xUN8PZpgmEG4NFE8oXQss9vBcGS3w5OOVAeD9ijRIUbrpcyTJ
         dsYqs/CCU3Hu4RvY282vwL+DdPUVKxeOOtuI3v2ywSNVs0movGQO1cvUC56uefkqTY
         xfmNlKD6D1JPjPFrCiVPNbPxHLMzE0gQTVBPNdR4=
X-HELO: smtpclient.apple
Authentication-Results: smtp.abv.bg; auth=pass (plain) smtp.auth=gvalkov@abv.bg
Received: from 212-39-89-148.ip.btc-net.bg (HELO smtpclient.apple) (212.39.89.148)
 by smtp.abv.bg (qpsmtpd/0.96) with ESMTPSA (ECDHE-RSA-AES256-GCM-SHA384 encrypted); Tue, 20 Jul 2021 15:46:33 +0300
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
From:   Georgi Valkov <gvalkov@abv.bg>
In-Reply-To: <YPa4ZelG2k8Z826E@kroah.com>
Date:   Tue, 20 Jul 2021 15:46:11 +0300
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        mhabets@solarflare.com, luc.vanoostenryck@gmail.com,
        snelson@pensando.io, mst@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        corsac@corsac.net, matti.vuorela@bitfactor.fi,
        stable@vger.kernel.org,
        =?utf-8?B?0JPQtdC+0YDQs9C4INCT0LXQvtGA0LPQuNC10LIg0JLRitC70LrQvtCy?= 
        <gvalkov@abv.bg>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C6AA954F-8382-461D-835F-E5CA03363D84@abv.bg>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
 <20210720122215.54abaf53@cakuba>
 <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg> <YPa4ZelG2k8Z826E@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, I read it, and before my previous e-mail that I also read the link =
from Jakub,
which essentially provides the same information.

There is only one patch =
0001-ipheth-fix-EOVERFLOW-in-ipheth_rcvbulk_callback.patch
The command I used from the example also generated a 0000-cover-letter, =
so
I included it as well.

I still have no clue what exactly I should do. Can you please help me?

Georgi Valkov

> On 2021-07-20, at 2:49 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Tue, Jul 20, 2021 at 02:39:49PM +0300, Georgi Valkov wrote:
>> I am doing this for the first time, so any help would be appreciated!
>=20
> Have you read Documentation/process/submitting-patches.rst yet?  If =
not,
> please do so.
>=20
> And look at examples on this list, you have to send individual =
patches,
> not everything all crammed into one email.
>=20
> thanks,
>=20
> greg k-h
>=20

