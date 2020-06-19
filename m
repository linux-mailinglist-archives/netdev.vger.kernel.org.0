Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38150200429
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731667AbgFSIgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731524AbgFSIgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 04:36:48 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFE0C06174E;
        Fri, 19 Jun 2020 01:36:48 -0700 (PDT)
Received: from [5.158.153.52] (helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jmCVx-0004OO-R0; Fri, 19 Jun 2020 10:36:45 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 6/9] net: dsa: hellcreek: Add debugging mechanisms
In-Reply-To: <20200618173458.GH240559@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-7-kurt@linutronix.de> <20200618173458.GH240559@lunn.ch>
Date:   Fri, 19 Jun 2020 10:36:45 +0200
Message-ID: <875zbnqwo2.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Andrew,

On Thu Jun 18 2020, Andrew Lunn wrote:
> On Thu, Jun 18, 2020 at 08:40:26AM +0200, Kurt Kanzenbach wrote:
>> The switch has registers which are useful for debugging issues:
>
> debugfs is not particularly likes. Please try to find other means
> where possible. Memory usage fits nicely into devlink. See mv88e6xxx
> which exports the ATU fill for example.

OK, I'll have a look at devlink and the mv88e6xxx driver to see if that
could be utilized.

> Are trace registers counters?

No. The trace registers provide bits for error conditions and if packets
have been dropped e.g. because of full queues or FCS errors, and so on.

>
>> +static int hellcreek_debugfs_init(struct hellcreek *hellcreek)
>> +{
>> +	struct dentry *file;
>> +
>> +	hellcreek->debug_dir = debugfs_create_dir(dev_name(hellcreek->dev),
>> +						  NULL);
>> +	if (!hellcreek->debug_dir)
>> +		return -ENOMEM;
>
> Just a general comment. You should not check the return value from any
> debugfs call, since it is totally optional. It will also do the right
> thing if the previous call has failed. There are numerous emails from
> GregKH about this.

OK.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7seR0ACgkQeSpbgcuY
8Kb+qQ/+IjbOx2bG9yRnwH5A2kCYuKF4WCx01ZRX0ETEQBbIYFyH+FTVZi8gPTM3
XPyQQv4BIMIimAimmmzpdvRSoiXU4GAYRyCALK4H/HbC7Xi0votg6q4ojVOHmjVJ
EuzVqO93+YXQyatv1QhvuX+NfVua2ByRabPjJtAZPxUNKsUR5l3WGYHm7H5ykxdP
qrIreJXVc9J2mY0+PtZryOd8dNmtx0XTH6x3PGrCBXfurPPnmUj8GQNghgnicq2t
l2w6GxobQmDGWNE0fHPsypp4ZE6JddgVq/TKYwkljsUFC7NVvJIKJESu/7GUrjKm
2OFcRgUlwJjJ84XQ92ZeK+4dNIW4D3+I/AKdnuUcMOToaTaeKGvzHIkTJeTsE+iP
P6shpCD3eWes2fzTSSLfj9dVb2NSeuHZyXFa/r+N3YeofYISW5wIjoSSu80MDeOf
T3vGkKvjbFFXNzETFUEiduVcTanZCjYd3G7qPh/AEjsJC3VyvFUk1AR68haOT5Xl
/HhKN2ziNpO8GmKXmcFEQhZ0xPfQ6JAcNNCf3QSf2eg12nCcl0SxMgh9TROcUSuY
+VdIL0GYm1yguH4V/G1YZbF0u5XCrSuBN/DiwpKT0HotXfA9DL9u3FWlLdjAHJsv
N++9lAV3+FtTztnwWOVhXwg5pcmJ9sbrtkJzfeXQhRJzCb8gmQs=
=8VNm
-----END PGP SIGNATURE-----
--=-=-=--
