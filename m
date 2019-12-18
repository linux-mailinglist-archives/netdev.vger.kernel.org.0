Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA1123F1E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 06:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfLRF3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 00:29:24 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:15025 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRF3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 00:29:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576646962;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=4MfOYdK0kNe3iT6Mf6IFJeefHPNu6zhom3oMosGYjO0=;
        b=lAF6+cSc5Q+hElnQoR9+1keOStZNSkX6klJBnVlK4TqlhsoUfrxJ5B7dXDRY/zRUP+
        qs0IIguOWVEJRUd5bccUWrLPmWz3Ob9cbdHuYu5dt8UnsFA35qeUf9scalAhQ8iMksJf
        DfK8BQ9sBAGxSiTfjhMGAtXzGfN35cPL0oAxcW2cHqn/EPw1hxCj0s8xQz8FZYa8iLK+
        1cpfZBn0VZwxfjudZhdaKUhtWbp9dRE82D6t0o9EgjQydjw7MY8eHl18GMb3A6XK10+d
        Z3bIZNEpHYoVLAnah7sneMbe+WIblKNWpFbb96n/LtiyUf9rldrn8SBUtB1sffVStLs9
        sBMg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGH/vrwDarcQ=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.0.7 SBL|AUTH)
        with ESMTPSA id q020e2vBI5TB42y
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Wed, 18 Dec 2019 06:29:11 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v2 1/2] DTS: bindings: wl1251: mark ti,power-gpio as optional
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20191218024450.GA5993@bogus>
Date:   Wed, 18 Dec 2019 06:29:10 +0100
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Content-Transfer-Encoding: 7bit
Message-Id: <B4283D7C-6B42-4C59-8B44-CFC7599E510B@goldelico.com>
References: <cover.1576606020.git.hns@goldelico.com> <de42cdd5c5d2c46978c15cd2f27b49fa144ae6a7.1576606020.git.hns@goldelico.com> <20191218024450.GA5993@bogus>
To:     Rob Herring <robh@kernel.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 18.12.2019 um 03:44 schrieb Rob Herring <robh@kernel.org>:
> 
> On Tue, 17 Dec 2019 19:06:59 +0100, "H. Nikolaus Schaller" wrote:
>> It is now only useful for SPI interface.
>> Power control of SDIO mode is done through mmc core.
>> 
>> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> ---
>> Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>> 
> 
> Please add Acked-by/Reviewed-by tags when posting new versions. However,
> there's no need to repost patches *only* to add the tags. The upstream
> maintainer will do that for acks received on the version they apply.
> 
> If a tag was not added on purpose, please state why and what changed.

Sorry, I just forgot to add. There was no change.


