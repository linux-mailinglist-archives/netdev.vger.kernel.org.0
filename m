Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CACEF1416
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbfKFKib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:38:31 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:22034 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfKFKib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 05:38:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573036708;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=H/gXvm9wd8N5UvB6u2YceLRjv7pAzT9N6eVU7C7taNY=;
        b=I65uUudbWMfPFIuAqoijC+HnX7zl2eQF7mqihdbvlZe4HTqkGH4FHu+Zw8O7nqIHpK
        kNrinF5K/cMKU5cibEcZ5f0tfpdZ5UQKegLxSaWSY2KviO19tn73XNpzci+5Rz2EQW6P
        gK6CMjK5GwAXc/QQHt6Iu7aQ0Y3cA/2H7pFNAUEdW6SSrF9pB0+3z9JnCJMClBx7trHm
        yPKWi/ZiF7PBaHZlGN1apeHX7TcqhG8354xqPw2jad0lGI7KuT1zpixGmQcDrVsqB+w6
        0jWhW8RfZ9OSPBStJkCc3rPHeisD0pLHqUvGS41531cBa1CT7Ebq/21zGzdHl33OPBZt
        fDIA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGH/PgwDCpPU0="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vA6AcPXrZ
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 6 Nov 2019 11:38:25 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Long Delay on startup of wl18xx Wireless chip
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <87sgn1z467.fsf@codeaurora.org>
Date:   Wed, 6 Nov 2019 11:38:24 +0100
Cc:     Linux-OMAP <linux-omap@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7BC95BF7-0E1D-4863-AB71-37BB6E8E297E@goldelico.com>
References: <CAHCN7xJiJKBgkiRm-MF9NpgQqfV4=zSVRShc5Sb5Lya2TAxU0g@mail.gmail.com> <CAHCN7xK0Y7=Wr9Kq02CWCbQjWVOocU02LLEB=QsVB22yNNoQPw@mail.gmail.com> <87sgn1z467.fsf@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>, Adam Ford <aford173@gmail.com>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 06.11.2019 um 11:32 schrieb Kalle Valo <kvalo@codeaurora.org>:
>=20
> Adam Ford <aford173@gmail.com> writes:
>=20
>> On Tue, Nov 5, 2019 at 12:25 PM Adam Ford <aford173@gmail.com> wrote:
>>>=20
>>> I am seeing a really long delay at startup of the wl18xx using the =
5.4 kernel.
>>>=20
>>=20
>> Sorry I had to resend.  I forgot to do plaintext.  Google switched
>> settings on me and neglected to inform me.
>>=20
>>=20
>>> [ 7.895551] wl18xx_driver wl18xx.2.auto: Direct firmware load for
>>> ti-connectivity/wl18xx-conf.bin failed with error -2
>>> [ 7.906416] wl18xx_driver wl18xx.2.auto: Falling back to sysfs
>>> fallback for: ti-connectivity/wl18xx-conf.bin
>>>=20
>>> At this point in the sequence, I can login to Linux, but the WL18xx =
is unavailable.
>>>=20
>>> [   35.032382] vwl1837: disabling
>>> [ 69.594874] wlcore: ERROR could not get configuration binary
>>> ti-connectivity/wl18xx-conf.bin: -11
>>> [   69.604013] wlcore: WARNING falling back to default config
>>> [   70.174821] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
>>> [ 70.189003] wlcore: WARNING Detected unconfigured mac address in
>>> nvs, derive from fuse instead.
>>> [   70.197851] wlcore: WARNING This default nvs file can be removed =
from the file system
>>> [   70.218816] wlcore: loaded
>>>=20
>>> It is now at this point when the wl18xx is available.
>>>=20
>>> I have the wl18xx and wlcore setup as a module so it should load
>>> after the filesystem is mounted. I am not using a wl18xx-conf.bin,
>>> but I never needed to use this before.
>>>=20
>>> It seems to me unreasonable to wait 60+ seconds after everything is
>>> mounted for the wireless chip to become available. Before I attempt
>>> to bisect this, I was hoping someone might have seen this. I am also
>>> trying to avoid duplicating someone else's efforts.
>>>=20
>>> I know the 4.19 doesn't behave like this.
>=20
> Try disabling CONFIG_FW_LOADER_USER_HELPER, that usually causes a 60
> second delay if the user space is not setup to handle the request. (Or
> something like that.)

I can confirm that I have it disabled in our config which seems to work.

BR,
Nikolaus

