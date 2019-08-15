Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5451A8EAA7
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 13:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbfHOLtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 07:49:42 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36179 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOLtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 07:49:42 -0400
Received: by mail-lf1-f66.google.com with SMTP id j17so1466623lfp.3;
        Thu, 15 Aug 2019 04:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=da+ygSzukrNTt7CGugFq0tsNtlCIMnjE6GGsWB9xJ48=;
        b=ULWFQbqb1jbpzVx+1aLPerK7pAznx9oux6NqXOgUTj05CMUhf8UL09aHq9SUcWDH/7
         fyCQ66Retm6BKIWATv00gcnUqdxgOleDl/caNdRtpM8RzM3OAugjZqZ2AT2UZFikpEOZ
         FfMICKSudqW8XxfCzNRiokJv2XTqFKmjJQV5ahj623DbEE+qOdWUfj9Ss01DYwVPqHHB
         w8rQFgGO7PNV+j4Hg3iXGjFAfqVd8LlIAY9RfW2i7fWU3djm7ML9135c2G4Sr+swCDY5
         YA7BiGmlSTYKvThf2p1orKZaTVbZ5G5eE3/uY9YJ9E6Umhf8TF1QvSmsDrA79GjuUy6O
         ycsQ==
X-Gm-Message-State: APjAAAXN7GRptNQy4CCeuZlogHCPZDwGZC3i++/iSquLxY4VvfE8raF3
        CXAghbZgL5boHQLNmc5JB9iOEVgY+4A=
X-Google-Smtp-Source: APXvYqwVRvo82H3BRDmNsGrNxpyaMFmyB/UEZpBGmA5KjqUAE8xtXTFBPIRocM+Bmgd6DVngJfyaJg==
X-Received: by 2002:ac2:484e:: with SMTP id 14mr2182257lfy.50.1565869780030;
        Thu, 15 Aug 2019 04:49:40 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id f1sm442019ljf.53.2019.08.15.04.49.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 04:49:38 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92)
        (envelope-from <johan@kernel.org>)
        id 1hyEGD-0003qP-7m; Thu, 15 Aug 2019 13:49:41 +0200
Date:   Thu, 15 Aug 2019 13:49:41 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Bob Ham <bob.ham@puri.sm>
Cc:     Johan Hovold <johan@kernel.org>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>, kernel@puri.sm,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: serial: option: Add the BroadMobi BM818 card
Message-ID: <20190815114941.GE32300@localhost>
References: <20190724145227.27169-1-angus@akkea.ca>
 <20190724145227.27169-2-angus@akkea.ca>
 <20190805114711.GF3574@localhost>
 <5fb96703-b174-eef1-5ad1-693e2bbce32f@puri.sm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <5fb96703-b174-eef1-5ad1-693e2bbce32f@puri.sm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 05, 2019 at 03:44:30PM +0100, Bob Ham wrote:
> On 05/08/2019 12:47, Johan Hovold wrote:
> > On Wed, Jul 24, 2019 at 07:52:26AM -0700, Angus Ainslie (Purism) wrote:
> >> From: Bob Ham <bob.ham@puri.sm>
> >>
> >> Add a VID:PID for the BroadModi BM818 M.2 card
> >=20
> > Would you mind posting the output of usb-devices (or lsusb -v) for this
> > device?
>=20
> T:  Bus=3D01 Lev=3D03 Prnt=3D40 Port=3D03 Cnt=3D01 Dev#=3D 44 Spd=3D480 M=
xCh=3D 0
> D:  Ver=3D 2.00 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D2020 ProdID=3D2060 Rev=3D00.00
> S:  Manufacturer=3DQualcomm, Incorporated
> S:  Product=3DQualcomm CDMA Technologies MSM
> C:  #Ifs=3D 5 Cfg#=3D 1 Atr=3De0 MxPwr=3D500mA
> I:  If#=3D0x0 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3D(none)
> I:  If#=3D0x1 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3D(none)
> I:  If#=3D0x2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3D(none)
> I:  If#=3D0x3 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dfe Prot=3Dff Drive=
r=3D(none)
> I:  If#=3D0x4 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3D(none)

I amended the commit message with the above, switched to
USB_DEVICE_INTERFACE_CLASS(), fixed the comment and moved the entry
to the other 0x2020 entries before applying.

Johan

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQHbPq+cpGvN/peuzMLxc3C7H1lCAUCXVVGxwAKCRALxc3C7H1l
CKpnAQC3uoOsq0K+HH2WaIfb4ig3RUodqYlqy2HQxZE7oJQGSgD8DeS8+HJ5TqIG
LVM+pr2Voun/2PPKZJrh+e9HoeiGZAo=
=nOST
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
