Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9658EB87
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731716AbfHOM2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:28:30 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35448 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730442AbfHOM23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:28:29 -0400
Received: by mail-lj1-f195.google.com with SMTP id l14so2092031lje.2;
        Thu, 15 Aug 2019 05:28:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mb4ocEB+lsd45gaEhTMvtmBFBk0APZUkoufygZBEO2s=;
        b=CefZpXqVriZZkYRxzlA2O7WQWGOa/kkSwGpZzYpg/3QQnGaPVAX7Gq1XQ3zzg3/dGs
         8/NGY0DaJp794pr8uk1Xk8jTToiE6tImTrclf1CMb8VE2gTkLlnCLrnHdZW28ygCkRJ6
         1JAWErd1gWYQtvWqjyUis0jdUg2evgZhcIn781ZIvBEqDlRq6ZmqdMb9AYUM9dSZXH3R
         /Dldh6aSdBlKOgHQOFoL4KbAlOEgRdtFMmnFuK+My38ePnWITfg1lkyoY1OblkF2xbB4
         UoknhPd0uil6RSlmPoMhNxj+QRzBzALkpbZx68LEg4w+g8iWQxxSGqRgSfEgcAJtFbGO
         q8Cw==
X-Gm-Message-State: APjAAAU7/hlt23qOaml0Ild/P6JZ3l7SaRLm05e+o8gC9aZs4yeGsSFK
        AIV+goaRFrN48/Ff4OxWFyPH80Vp5Kg=
X-Google-Smtp-Source: APXvYqw49OLUyyAs3EPjQSiKfrOy5OikLFbWfbi5PwR9AsLgEKr3K14x84YAdTBo8glkPtNbj5nTEg==
X-Received: by 2002:a2e:995a:: with SMTP id r26mr2550133ljj.107.1565872107347;
        Thu, 15 Aug 2019 05:28:27 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id s21sm465306ljm.28.2019.08.15.05.28.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 05:28:26 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92)
        (envelope-from <johan@kernel.org>)
        id 1hyErj-0005zs-VM; Thu, 15 Aug 2019 14:28:28 +0200
Date:   Thu, 15 Aug 2019 14:28:27 +0200
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
Message-ID: <20190815122827.GF32300@localhost>
References: <20190724145227.27169-1-angus@akkea.ca>
 <20190724145227.27169-2-angus@akkea.ca>
 <20190805114711.GF3574@localhost>
 <5fb96703-b174-eef1-5ad1-693e2bbce32f@puri.sm>
 <20190815114941.GE32300@localhost>
 <57190963-22e2-cb89-bfd0-502f135237c3@puri.sm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <57190963-22e2-cb89-bfd0-502f135237c3@puri.sm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2019 at 01:19:19PM +0100, Bob Ham wrote:
> On 15/08/2019 12:49, Johan Hovold wrote:
> > On Mon, Aug 05, 2019 at 03:44:30PM +0100, Bob Ham wrote:
> >> On 05/08/2019 12:47, Johan Hovold wrote:
> >>> On Wed, Jul 24, 2019 at 07:52:26AM -0700, Angus Ainslie (Purism) wrot=
e:
> >>>> From: Bob Ham <bob.ham@puri.sm>
> >>>>
> >>>> Add a VID:PID for the BroadModi BM818 M.2 card
> >>>
> >>> Would you mind posting the output of usb-devices (or lsusb -v) for th=
is
> >>> device?
> >>
> >> T:  Bus=3D01 Lev=3D03 Prnt=3D40 Port=3D03 Cnt=3D01 Dev#=3D 44 Spd=3D48=
0 MxCh=3D 0
> >> D:  Ver=3D 2.00 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D =
 1
> >> P:  Vendor=3D2020 ProdID=3D2060 Rev=3D00.00
> >> S:  Manufacturer=3DQualcomm, Incorporated
> >> S:  Product=3DQualcomm CDMA Technologies MSM
> >> C:  #Ifs=3D 5 Cfg#=3D 1 Atr=3De0 MxPwr=3D500mA
> >> I:  If#=3D0x0 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Dr=
iver=3D(none)
> >> I:  If#=3D0x1 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Dr=
iver=3D(none)
> >> I:  If#=3D0x2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Dr=
iver=3D(none)
> >> I:  If#=3D0x3 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dfe Prot=3Dff Dr=
iver=3D(none)
> >> I:  If#=3D0x4 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Dr=
iver=3D(none)
> >=20
> > I amended the commit message with the above, switched to
> > USB_DEVICE_INTERFACE_CLASS(), fixed the comment and moved the entry
> > to the other 0x2020 entries before applying.
>=20
> Sorry I should probably have mentioned this before but Angus has been on
> vacation, hence the silence on the other matters.  Regardless, thanks.

Ok, no worries.

Johan

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQHbPq+cpGvN/peuzMLxc3C7H1lCAUCXVVP6AAKCRALxc3C7H1l
CMo1APwMD0VfWrh3KkuyCmDvAanF6P1fbGAWJQAoA/T7CeleCgEA8vDvNG7aMnDc
2kbrNPQBZPa2HBekhnq5EmNdcyDUwAQ=
=Mz5X
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
