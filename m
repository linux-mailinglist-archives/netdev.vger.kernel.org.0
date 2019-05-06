Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57912145AA
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 09:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfEFH7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 03:59:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50134 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfEFH7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 03:59:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 65982609D4; Mon,  6 May 2019 07:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557129579;
        bh=NMarB24NYlqwYKYppR0+S1WNXUCddPdMFLRiI09z0ms=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mRdZrEdQgxOHHpWSrXDps+CjZWlglNzBgvdBhoe1p8xnQZBr8+/jVP9ICnddMwsFc
         IyIhxHSZhbFFwRn69ER2oH56Jv2rzX/jdWKQCEzJD+I0ndxoVH+5TcLILibOt8KlU6
         aJ6jgfn3sumIJhBY8oba0StcExfqZNxOrBEDzEqU=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (37-136-65-53.rev.dnainternet.fi [37.136.65.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 81E6460770;
        Mon,  6 May 2019 07:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557129578;
        bh=NMarB24NYlqwYKYppR0+S1WNXUCddPdMFLRiI09z0ms=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S9wBSr0a+TQBG7xwfbdOrrv1ahXoiDudhF6XkCXpTt/CW9pqbvjWbczmdmJNR0MYc
         2/kdA7onz3mXKfh302yaLeXlkLoadd0mBVlhFR31R7df8rrS/KzZ3SWKRPkQrlBzc7
         xx7pQXs+bEF84B2H5G/cwYWGPraloPEoHiQfWWA4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 81E6460770
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v4 07/10] net: wireless: support of_get_mac_address new ERR_PTR error
References: <1556893635-18549-1-git-send-email-ynezz@true.cz>
        <1556893635-18549-8-git-send-email-ynezz@true.cz>
Date:   Mon, 06 May 2019 10:59:29 +0300
In-Reply-To: <1556893635-18549-8-git-send-email-ynezz@true.cz> ("Petr
        \=\?utf-8\?Q\?\=C5\=A0tetiar\=22's\?\= message of "Fri, 3 May 2019 16:27:12 +0200")
Message-ID: <878svkvwri.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr =C5=A0tetiar <ynezz@true.cz> writes:

> There was NVMEM support added to of_get_mac_address, so it could now retu=
rn
> ERR_PTR encoded error values, so we need to adjust all current users of
> of_get_mac_address to this new fact.
>
> Signed-off-by: Petr =C5=A0tetiar <ynezz@true.cz>
> ---
>
>  Changes since v3:
>
>   * IS_ERR_OR_NULL -> IS_ERR
>
>  drivers/net/wireless/ath/ath9k/init.c          | 2 +-
>  drivers/net/wireless/mediatek/mt76/eeprom.c    | 2 +-
>  drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Via which tree is this supposed to go? In case something else than my
wireless-drivers-next:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

--=20
Kalle Valo
