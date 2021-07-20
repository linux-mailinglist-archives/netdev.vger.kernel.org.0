Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1F43CFAB2
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbhGTMyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237431AbhGTMvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:51:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B496C0613DC
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 06:31:31 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626787888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gnf4wt/fRNLh29Psx6SbOcCwSnqeK7/okOlgwebj71g=;
        b=tJtwJ4MpnnaIsDRDa+RMzsn/MhU6gWGLo1dlICBXfqvWORcpx0B2+8TDfbfFbQp0Qanedk
        GOkWcaLTdQD8bUaGx61ywP0KtdJBIOlwxJxj3eVnLp4WLRjXsImEarxLDgHeKetR0+pA5m
        MmbAu3nMGxB6907A4g3SPkbe0dD1A7G/81JL/dO+1ap1gBpqDglnhGxSnzA9SnsvIWwJmP
        VZMLYVS/6U0riWM9mbuyiy4zLltGfhu+mo/BQOxZfWOyGT3YGKd3THvgKDD+3pJNzwldfd
        zOc3dFwy7bbfu4m+wMRgQ8PFEWM2IXv6BM0e5jsJlIdplah7HUy6UfRbUPde6w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626787888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gnf4wt/fRNLh29Psx6SbOcCwSnqeK7/okOlgwebj71g=;
        b=b1fAtq7O/N/8sEND4H78ykDJ41kRfEYAmmrSnYSVM8eNT/N8q654yA8pk6RGLrBEwq3grK
        ZarQOvo2fkY00rCw==
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
In-Reply-To: <80801305-c0fa-8b6f-a30e-083608149a4c@intel.com>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <80801305-c0fa-8b6f-a30e-083608149a4c@intel.com>
Date:   Tue, 20 Jul 2021 15:31:27 +0200
Message-ID: <87pmvd9knk.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon Jul 19 2021, Jesse Brandeburg wrote:
> On 7/16/2021 2:24 PM, Tony Nguyen wrote:
>> From: Kurt Kanzenbach <kurt@linutronix.de>
>>
>> Each i225 has three LEDs. Export them via the LED class framework.
>>
>> Each LED is controllable via sysfs. Example:
>>
>> $ cd /sys/class/leds/igc_led0
>> $ cat brightness      # Current Mode
>> $ cat max_brightness  # 15
>> $ echo 0 > brightness # Mode 0
>> $ echo 1 > brightness # Mode 1
>>
>> The brightness field here reflects the different LED modes ranging
>> from 0 to 15.
>>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>
> Just a few hours ago, Kurt sent a revert for this patch, we should just=20
> drop it from this series.

Yes, I'll revisit this patch with the feedback received. Drop it for now.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmD20C8THGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpgEsD/428/TRquFQA88VetfTH0dLaEKItjd9
eC+FGPXDYtUKinzbtodN7SBCqAQWXYHC11tiIGZKd+kB47HJ+ibbprz/iCHCMufe
7+U4ELBO8Nw5DdyRx+ZiUWTrWfBJ5VqdQwgMM6c+HM+9or/Llb3QZMWccKVRipkS
9j55dIvwKtZ1qh94xYs0MdS8amvb5veKJ1GoAp4OwWsRJWtBS88dsmiTWxmWDNFY
KKi5/YqVyF0EkO0kqvmTtmyNFCHyF0lp93JP2rVBLCB9beFZCBIFQM/JWX5EV0Cm
UaU45QaQGSj86aCNid28mnanRXjhRgJAb5JloJKdVJ+LdxHkb5uPg2sZi1qJ09fg
f0pG8j0FsdI12oS2Yg3NGW5W4yUkzZ4HNXjLQTVD7whOPo4CY5oFkuMn7PYUhLM9
VPJU0BehNg7Xdu07GOMeYqIWxYXKuf8c4o0Yzo5R92rCij3+juWQ1RKYtrJAMvVu
2qq+YG6RObqsLllVF8BZaievHxtMAggX4ELWeuy+1yWyjAwz067X33UnDeOjhkpR
SrvZEtjJb2qMeNbSn/oziYPs9/xQ0x6mfuv7v1Tn5NUL6ibHgb9JbBx/ubIN1ip1
nFiIMPjhVVFAB/pmoESwi+plbzj20SrrsKuhRFyt20RMLEgDNG5D/DjUHPiJ07AR
T9LhOExEnWftgw==
=rNes
-----END PGP SIGNATURE-----
--=-=-=--
