Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67519280E76
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgJBIGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:06:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41004 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgJBIGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 04:06:31 -0400
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601625989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TI50F5zFdC+oVVGpGPJUIJU9LOvZDZT7ShM6NFSK0us=;
        b=S+0Xpjq5xFJv+w+KhcBExgoXuyKIybjaMiEEWi0nzpWi+UwWC7yA0hqKHO1PkRLNgQdlJh
        uud2BnuQG37GmBicE5Pm72PlWOZd3e9gYwx9Cc5/4C5n91ugvSrfpM8Solkyw6SgFDE+q8
        FxiPszWMniaOZWxRUhfcXiQdhpYMbal5f8wc0x6S7fPNWMP7XtyLU6LeldPXUH9s1OhfHE
        XIKu3d56/7fgN8Y/DFMXGyWzoJst6fA3COlQ7ijJVacS6ZFoBj14noLtkR2B8upuY4ddIe
        0K/hGe6XWN64Q76yiNRLx1pIZrJPl3KwPoqFjVaGJM/X79yCTM9if3mw4O8FNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601625989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TI50F5zFdC+oVVGpGPJUIJU9LOvZDZT7ShM6NFSK0us=;
        b=CaIiLUsIvrcvEnHtVObatO/fLYbF4VpVo73EAW6JDl8My1V2fpI6DP073LyEJp6M5mGcRC
        jLZ8T0nsburApkBQ==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set configure_vlan_while_not_filtering to true by default
In-Reply-To: <20200908102956.ked67svjhhkxu4ku@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com> <20200907182910.1285496-5-olteanv@gmail.com> <87y2lkshhn.fsf@kurt> <20200908102956.ked67svjhhkxu4ku@skbuf>
Date:   Fri, 02 Oct 2020 10:06:28 +0200
Message-ID: <87o8llrr0b.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

On Tue Sep 08 2020, Vladimir Oltean wrote:
> On Tue, Sep 08, 2020 at 12:14:12PM +0200, Kurt Kanzenbach wrote:
>> On Mon Sep 07 2020, Vladimir Oltean wrote:
>> > New drivers always seem to omit setting this flag, for some reason.
>>
>> Yes, because it's not well documented, or is it? Before writing the
>> hellcreek DSA driver, I've read dsa.rst documentation to find out what
>> callback function should to what. Did I miss something?
>
> Honestly, Documentation/networking/dsa/dsa.rst is out of date by quite a
> bit. And this trend of having boolean flags in struct dsa_switch started
> after the documentation stopped being updated.

Maybe it would be good to document new flags when they're introduced :).

>
> But I didn't say it's your fault for not setting the flag, it is easy to
> miss, and that's what this patch is trying to improve.
>
>> > So let's reverse the logic: the DSA core sets it by default to true
>> > before the .setup() callback, and legacy drivers can turn it off. This
>> > way, new drivers get the new behavior by default, unless they
>> > explicitly set the flag to false, which is more obvious during review.
>>
>> Yeah, that behavior makes more sense to me. Thank you.
>
> Ok, thanks.

Is this merged? I don't see it. Do I have to set
`configure_vlan_while_not_filtering' explicitly to true for the next
hellcreek version?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9234QACgkQeSpbgcuY
8KYjVBAAxhyHhf4E1eiILnrj6Hwnqxiz/ojRHvbSlkiTrbZK1aoufgqrNFZyi1/z
KfXN2U1zwC3keXy05hiWh+KMy40h9mam8JmY/2jSFZ46SLPInCbbkbCeGzZrZrIp
gQmzA5D546GClfqzoVFKmmkhoRfAZTIIDVoure+N2KRfxgrUQgocfLOIty2EmuYs
ZT3aHBL2xo36exDzNYYc8EIMOfBuHqdaCNYcGILIX+6Hu5KMDtade+jyCLtN5YXh
EO15gBs3Fq/SEaC0B6k9/S/wHIAwadGnrZxdnnCK/FW8x3gRXzDfWWxkmHPQwHnW
KKYRdjiIKCMTBl8qgnCdiFECF/ibtgLNlp/PFCDK9KCgS/MDn5q4NTpMjAxvRha9
UFd8ooc64//2GAFHi+Zch6oSuJDo3qQ4yYyvOFlt6bZsizQu4krdto8JjoOUJuWZ
TUICFJkYwdu1k3S2F6eaRnuczFWbf6Z7cSI1KuhmguCYpt/O6bvWeBPthhW0XnJt
m86VxbChW4pXBdsr9OcKpBHsyFmI+oePbgBWRrXY0eURrFwDwxrWDPlFmIjoyqAK
PJc91bjDnw7HobScVThO3Qmge6e0Fyf83G9c6khdUZB5/Bfg4cpIP2gydrSALeTG
G1TljYaHLxggqpnZFBrTIo8kS/ugy3OWfIGEbd1DiM049ZcApWA=
=Oq42
-----END PGP SIGNATURE-----
--=-=-=--
