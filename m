Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A9A48C3CE
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 13:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353092AbiALMOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 07:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238443AbiALMOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 07:14:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC269C06173F;
        Wed, 12 Jan 2022 04:14:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CED1618C2;
        Wed, 12 Jan 2022 12:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7EAC36AE9;
        Wed, 12 Jan 2022 12:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641989653;
        bh=QOw9mjKrUhdFLq+aqixvaYpTbivRVrm6xPbrSyuS6cA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=keT2ISvWVQwMZpjmj8yQBAFJRHOcZnLatdTj+fKDt5uyzg94gSxO72qYzoZmNrEEW
         9oZEZZPE/L3fTX5Nma8gV5LkjA/PJXrEf0X6cC0b/kqoNS/cnx5lHjLEwoi+8PYGrW
         ZR+nOYafp2QQomJcdhafLIvmQ+4FlHe6McKmtf1jZr/n+mlUkCWng7NN9a1EEE/Z86
         q/Q90BZGkDtj0BmIQtyseH8MjINrWAqLEEKxr0d20n2zXLye9ubhHyNrVohDS4ucvR
         b0K3tgfdc1AKf2Wd1O9WAyKz3nGbUQINDNQjUHwh63PGzf6W58Drz7tqCcZyma65Ac
         Y3LA6EV6sRNZg==
Received: by pali.im (Postfix)
        id 3E5A1768; Wed, 12 Jan 2022 13:14:11 +0100 (CET)
Date:   Wed, 12 Jan 2022 13:14:11 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-mmc@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v9 08/24] wfx: add bus_sdio.c
Message-ID: <20220112121411.qq2egpoujtsvswla@pali>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
 <20220111171424.862764-9-Jerome.Pouiller@silabs.com>
 <20220112105859.u4j76o7cpsr4znmb@pali>
 <42104281.b1Mx7tgHyx@pc-42>
 <20220112114332.jadw527pe7r2j4vv@pali>
 <Yd7EOcx/zHJFeJUv@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yd7EOcx/zHJFeJUv@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 12 January 2022 13:06:17 Greg Kroah-Hartman wrote:
> On Wed, Jan 12, 2022 at 12:43:32PM +0100, Pali Rohár wrote:
> > Btw, is there any project which maintains SDIO ids, like there is
> > pci-ids.ucw.cz for PCI or www.linux-usb.org/usb-ids.html for USB?
> 
> Both of those projects have nothing to do with the kernel drivers or
> values at all, they are only for userspace tools to use.
> 
> So even if there was such a thing for SDIO ids, I doubt it would help
> here.

Why do you doubt? For sure if would help! Just checking comments if some
user reported different card with this id would tell us how broken it is
and how sane it is to define macro for particular id.
