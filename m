Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8531BE304
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgD2Pnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgD2Pnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:43:49 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCC6C03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 08:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588175027;
        s=strato-dkim-0002; d=xenosoft.de;
        h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=IbyYYlnr5FtSGNAz7JbGE3sOZMyIiGOk4MJ33ilaEMM=;
        b=C2PzhCLwgohgbExQF4SXrIf3s4tlCbTNrusyFTw8VmXnww30lYtx/6StIDzccEkkWh
        9EGKc0qdSIr1yEVlZFfd40GtAwhy1E6/zUdrdS54VQ0ZIuPvdGamWfEmeX2gbe3LXTkF
        du55qMBCnaOXva/hFoxrf9EySoP1lxRyLrcMOlCoZFd1712QYmJUGe8YFwcHXuwp27w0
        1O/ykD7X/gB+obeMcMkxCOMQ0YUWzENE9MJ5tCs2LBgcayGtn9Yi+dbkAtDdFBUtG7ms
        Q7mf0Spo63LGgGwRzEoz92yyusfOBZPpNZq1Fnb9qREjWVNg76NB02+/TDlDO6cwJQDS
        Athw==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGN0rBVhd9dFr4tFIFSaQ9BwcJz1cfHs="
X-RZG-CLASS-ID: mo00
Received: from [10.39.49.245]
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id I01247w3TFglbIR
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 29 Apr 2020 17:42:47 +0200 (CEST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH dpss_eth] Don't initialise ports with no PHY
Date:   Wed, 29 Apr 2020 17:42:46 +0200
Message-Id: <68BEA58A-DF1D-44B8-91DD-B90BAAB738BE@xenosoft.de>
References: <20200429152224.GA66424@lunn.ch>
Cc:     Darren Stevens <darren@stevens-zone.net>, madalin.bacur@nxp.com,
        netdev@vger.kernel.org, mad skateman <madskateman@gmail.com>,
        oss@buserror.net, linuxppc-dev@lists.ozlabs.org,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        "contact@a-eon.com" <contact@a-eon.com>
In-Reply-To: <20200429152224.GA66424@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: iPhone Mail (17D50)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 29. Apr 2020, at 17:22, Andrew Lunn <andrew@lunn.ch> wrote:
>=20
> =EF=BB=BFOn Wed, Apr 29, 2020 at 03:55:28PM +0200, Christian Zigotzky wrot=
e:
>> Hi Andrew,
>>=20
>> You can find some dtb and source files in our kernel package.
>>=20
>> Download: http://www.xenosoft.de/linux-image-5.7-rc3-X1000_X5000.tar.gz
>=20
> I have the tarball. Are we talking about
> linux-image-5.7-rc3-X1000_X5000/X5000_and_QEMU_e5500/dtbs/X5000_20/cyrus.e=
th.dtb
>=20
> I don't see any status =3D "disabled"; in the blob. So i would expect
> the driver to probe.
>=20
>    Andrew
>=20
>=20

Yes, that=E2=80=99s correct but maybe Darren uses another dtb file.

@Darren
Which dtb file do you use?=
