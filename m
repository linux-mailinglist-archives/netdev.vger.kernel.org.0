Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A23710A23A
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 17:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbfKZQfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 11:35:31 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:9682 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfKZQfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 11:35:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574786129;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=dvRE7iW4nslKimTeHHXOFKiaMi1OxnuR2EOi0LyJSk8=;
        b=TzG0FCgESYWwa0SZtM2YL61Xv9K60aZptlqOv9YNkBY/Zx/fLUm5IXwEdeNkJ+66tc
        UiOCMc6cnyV2A1dOk1LjU4FuKKhX/X3LN9CXTqphJjriEKLtmOxBeK3OK2HPExmnzz4J
        Q1BYOOlyCCYCzfHVK07uvJHe4jt7ujY/DrGSJED1cbQEiPAZt4pf3zfyBVQm32EYEG22
        kvS9uIjJ/BnGXHYIrM68mvUDjYgJJgH40wN17qaYL3DzYbDvfA6o+9gvYHlGy9SRmqRb
        9L1RnLDl8EqPdk5djV7dlPkcemiB78tutsQxwG0+/OJL7QjxL2pq8MZBhVEWVxXtfuK7
        Nysw==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGH/PuwDOspXA="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 45.0.2 DYNA|AUTH)
        with ESMTPSA id y07703vAQGZL8b2
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Tue, 26 Nov 2019 17:35:21 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH 2/2] net: wireless: ti: wl1251: sdio: remove ti,power-gpio
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <0101016ea86aaa23-4980977b-7718-4ce8-9089-ae7936f60eee-000000@us-west-2.amazonses.com>
Date:   Tue, 26 Nov 2019 17:35:21 +0100
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
Message-Id: <D80F1342-0BCE-415F-82E0-7FA53E334E54@goldelico.com>
References: <cover.1574591746.git.hns@goldelico.com> <e1f18e0f1401a0d8b07ccb176732a2e3f3a5732a.1574591746.git.hns@goldelico.com> <0101016ea86aaa23-4980977b-7718-4ce8-9089-ae7936f60eee-000000@us-west-2.amazonses.com>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 26.11.2019 um 16:53 schrieb Kalle Valo <kvalo@codeaurora.org>:
> 
> "H. Nikolaus Schaller" <hns@goldelico.com> writes:
> 
>> Remove handling of this property from code.
>> Note that wl->power_gpio is still needed in
>> the header file for SPI mode (N900).
>> 
>> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> ---
>> drivers/net/wireless/ti/wl1251/sdio.c | 30 ---------------------------
>> 1 file changed, 30 deletions(-)
> 
> Please use "wl1251: " as title prefix, no need to have the full
> directory structure there.

Ok, noted for v2.

BR and thanks,
Nikolaus

