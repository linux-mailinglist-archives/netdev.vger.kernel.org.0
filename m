Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4768E10A234
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 17:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfKZQfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 11:35:10 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:23242 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfKZQfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 11:35:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574786108;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=2as8WnxFO+tmi1fJ1uyawkpBUkNpCEuFJl0NIZl4N98=;
        b=aXlbzUUhVS3MUzCqbY+9yPSGDVyjt/lN5YMlZXiOS6vjn+3Qt6SWrMGJUleItuumGP
        rDQUKTBy+IfaRvaeg9d62c6dXbeS7mFKhwR2BtJprqN/1zULhnpZ489dnmGVYbS4LiWX
        rbZoV3OqvHLovzDDxlrWthjqp3JV06roUlbdP3NLi+Eurjielyiyf99loZIA0rrfsPHJ
        seNscK/MRCE8o/cSrlirFl64vz3KsYx1O4o4U8a2OgQqY1GhbGIYH0QAXQNY9B9vAOhI
        GvSx3E71dFkHiOjuVhGIm8e+MdF0COukaf1esrd0i5ckLJbd9yo9eVAoIx98jhW2SsIv
        /ySQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGH/PuwDOspXA="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 45.0.2 DYNA|AUTH)
        with ESMTPSA id y07703vAQGYv8av
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Tue, 26 Nov 2019 17:34:57 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH 0/2] net: wireless: ti: wl1251: sdio: remove ti,power-gpio
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <0101016ea86910ca-f8c93455-c4de-4906-a10a-bba6be6ff35a-000000@us-west-2.amazonses.com>
Date:   Tue, 26 Nov 2019 17:34:56 +0100
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Content-Transfer-Encoding: 7bit
Message-Id: <835C8FFB-48CA-4B7E-968C-E5781E0A6792@goldelico.com>
References: <cover.1574591746.git.hns@goldelico.com> <0101016ea86910ca-f8c93455-c4de-4906-a10a-bba6be6ff35a-000000@us-west-2.amazonses.com>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 26.11.2019 um 16:51 schrieb Kalle Valo <kvalo@codeaurora.org>:
> 
> "H. Nikolaus Schaller" <hns@goldelico.com> writes:
> 
>> The driver has been updated to use the mmc/sdio core
>> which does full power control. So we do no longer need
>> the power control gipo.
>> 
>> Note that it is still needed for the SPI based interface
>> (N900).
>> 
>> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
>> Tested by: H. Nikolaus Schaller <hns@goldelico.com> # OpenPandora 600MHz
>> 
>> H. Nikolaus Schaller (2):
>>  DTS: bindings: wl1251: mark ti,power-gpio as optional
>>  net: wireless: ti: wl1251: sdio: remove ti,power-gpio
>> 
>> .../bindings/net/wireless/ti,wl1251.txt       |  3 +-
>> drivers/net/wireless/ti/wl1251/sdio.c         | 30 -------------------
>> 2 files changed, 2 insertions(+), 31 deletions(-)
> 
> Via which tree are these planned to go? Please always document that in
> the cover letter so that maintainers don't need to guess.

Well, how should I know that better than maintainers?

I don't know who manages which trees and who feels responsible.
So I have to guess even more.

I just use the get_maintainer.pl script to address everybody listed by it,
assuming that it does the right thing.

If the script doesn't do a good enough job it should be improved.

BR and thanks,
Nikolaus

