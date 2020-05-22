Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCA71DE3BD
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 12:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgEVKLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 06:11:30 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:44286 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728315AbgEVKL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 06:11:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590142288; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=NW8Jsqkb6pnbBs1zr+nqGOErhbAaUKt/K4f9G+vJyjQ=; b=JGoJNkrX7jZ/a1y46Q8C/C65gVdfyGUiwr6VC/7S+c3tDRFVP3gHOYzv1HN8kjUq+6lK7v2N
 PFr/LWcwU0pI5CYJWamm2InpsW68U+bEYD+KWOYjL6zAUmoxiJV9mv2Q3sGbj1bDnTON8pBW
 xWBwykePnv36AAgNtQid7EDAzRg=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5ec7a55082c96b5d3b84f35b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 22 May 2020 10:11:28
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F3B0CC433C6; Fri, 22 May 2020 10:11:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DB89FC433C8;
        Fri, 22 May 2020 10:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DB89FC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <matthias.bgg@gmail.com>, <shayne.chen@mediatek.com>,
        <chih-min.chen@mediatek.com>, <yf.luo@mediatek.com>,
        <yiwei.chung@mediatek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] mt76: mt7915: Fix build error
References: <20200522034533.61716-1-yuehaibing@huawei.com>
Date:   Fri, 22 May 2020 13:11:16 +0300
In-Reply-To: <20200522034533.61716-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Fri, 22 May 2020 11:45:33 +0800")
Message-ID: <87a720b7p7.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> writes:

> In file included from ./include/linux/firmware.h:6:0,
>                  from drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:4:
> In function =E2=80=98__mt7915_mcu_msg_send=E2=80=99,
>     inlined from =E2=80=98mt7915_mcu_send_message=E2=80=99 at drivers/net=
/wireless/mediatek/mt76/mt7915/mcu.c:370:6:
> ./include/linux/compiler.h:396:38: error: call to =E2=80=98__compiletime_=
assert_545=E2=80=99 declared with attribute error: BUILD_BUG_ON failed: cmd=
 =3D=3D MCU_EXT_CMD_EFUSE_ACCESS && mcu_txd->set_query !=3D MCU_Q_QUERY
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                       ^
> ./include/linux/compiler.h:377:4: note: in definition of macro =E2=80=98_=
_compiletime_assert=E2=80=99
>     prefix ## suffix();    \
>     ^~~~~~
> ./include/linux/compiler.h:396:2: note: in expansion of macro =E2=80=98_c=
ompiletime_assert=E2=80=99
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>   ^~~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:39:37: note: in expansion of macro =E2=80=98c=
ompiletime_assert=E2=80=99
>  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                      ^~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:50:2: note: in expansion of macro =E2=80=98BU=
ILD_BUG_ON_MSG=E2=80=99
>   BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>   ^~~~~~~~~~~~~~~~
> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:280:2: note: in expansion=
 of macro =E2=80=98BUILD_BUG_ON=E2=80=99
>   BUILD_BUG_ON(cmd =3D=3D MCU_EXT_CMD_EFUSE_ACCESS &&
>   ^~~~~~~~~~~~
>
> BUILD_BUG_ON is meaningless here, chang it to WARN_ON.
>
> Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chi=
psets")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

I'm curious why I don't see this build error? I was about to send a pull
request to Dave, should I hold off the pull request due to this problem?

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
