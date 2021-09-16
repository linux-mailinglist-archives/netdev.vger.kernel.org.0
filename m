Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD8840D87E
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 13:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbhIPL1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 07:27:44 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:19302 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237446AbhIPL1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 07:27:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1631791579;
    s=strato-dkim-0002; d=heimpold.de;
    h=In-Reply-To:References:Subject:Cc:To:From:Message-ID:Date:Cc:Date:
    From:Subject:Sender;
    bh=DS3mnRRcGXjdmBCBcvU/cxdm6qdEX7sUPpdbKeW8mdU=;
    b=o011rUdQ2rSK4NGDyeAVP/zGedb+PTsOU1RcNK6bHPUZlytRjZNuhFJiQQo5lbvqrJ
    SAWZ2buT545/lH7Cl495TX2IBUFrX5bDyl/OP769AfgEtI5IYHKuGGAbjj+ZJCKy1X9e
    C5suBDob6Yi1hFR6mBNiZWJtPghHUNU1WxWonlZe11DeyIbxhA0G6DwdMJo6hqzCUsly
    QLU/+Swc6EujJmUw3QPZHezsrxoKwamdKjITxHuq4WMVzDfzsNjmtgBRqtv06fzPQtvE
    VhxhFen5LueByl4oxSks8VhQ9n0m7Jan8uiYHTYumhOzt97wDH4BOEQSz2X0HH6/YDXr
    Aa1A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":O2kGeEG7b/pS1EW8QnKjhhg/vO4pzqdNytq77N6ZKUSN7PfdWTGbO3oK8Gj1qrjlHg/zTQ=="
X-RZG-CLASS-ID: mo00
Received: from tonne.mhei.heimpold.itr
    by smtp.strato.de (RZmta 47.33.1 DYNA|AUTH)
    with ESMTPSA id R03356x8GBQJ0YY
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Thu, 16 Sep 2021 13:26:19 +0200 (CEST)
Received: from tonne (localhost [IPv6:::1])
        by tonne.mhei.heimpold.itr (Postfix) with ESMTPS id 64946179882;
        Thu, 16 Sep 2021 13:26:18 +0200 (CEST)
Received: from i5C7537B0.versanet.de (i5C7537B0.versanet.de [92.117.55.176])
 by www.mhei.heimpold.org (Horde Framework) with HTTPS; Thu, 16 Sep 2021
 11:26:18 +0000
Date:   Thu, 16 Sep 2021 11:26:18 +0000
Message-ID: <20210916112618.Horde.UWH1AKpXpmAwqSTq8U1y-WN@www.mhei.heimpold.org>
From:   Michael Heimpold <mhei@heimpold.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] net: vertexcom: Add MSE102x SPI support
References: <20210914151717.12232-1-stefan.wahren@i2se.com>
 <20210914151717.12232-4-stefan.wahren@i2se.com> <YUJi0cVawjyiteEx@lunn.ch>
In-Reply-To: <YUJi0cVawjyiteEx@lunn.ch>
User-Agent: Horde Application Framework 5
Content-Type: multipart/mixed; boundary="=_BSXR-daGI8uzy-NgKF7qpXC"
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This message is in MIME format.

--=_BSXR-daGI8uzy-NgKF7qpXC
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Content-Disposition: inline

Hi Andrew,

Zitat von Andrew Lunn <andrew@lunn.ch>:

>> +static int mse102x_probe_spi(struct spi_device *spi)
>> +{
>
> ...
>
>> +	netif_carrier_off(mse->ndev);
>> +	ndev->if_port = IF_PORT_10BASET;
>
> That is not correct. Maybe you should add a IF_PORT_HOMEPLUG ?

Would a simple IF_PORT_HOMEPLUG be sufficient, or should it be
more precise as for Ethernet (10BASET, 100BASET...), e.g.
IF_PORT_HOMEPLUG_10
IF_PORT_HOMEPLUG_AV
IF_PORT_HOMEPLUG_AV2
IF_PORT_HOMEPLUG_GREENPHY

Thanks,
Michael


--=_BSXR-daGI8uzy-NgKF7qpXC
Content-Type: application/pgp-keys
Content-Description: =?utf-8?b?w5ZmZmVudGxpY2hlciBQR1AtU2NobMO8c3NlbA==?=

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4

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
=B0nQ
-----END PGP PUBLIC KEY BLOCK-----
--=_BSXR-daGI8uzy-NgKF7qpXC--

