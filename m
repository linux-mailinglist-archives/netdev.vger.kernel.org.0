Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187231E0BEA
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 12:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389824AbgEYKhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 06:37:37 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:15607 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389819AbgEYKhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 06:37:36 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590403056; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=Xa+V2K2B+f2/pjJ0gvv7y9F+pJuL30zRLv90omb/sWY=; b=Lg+ICOqNOej0XIWMRskryECb1V4IxPNlLybnr/1DrwEmXGVNXI85RZ4fkvx95g9NuG4DCJdb
 QbonvseLKGMHWStBq2ugPeWcJhBHuN307bx+kFQ5k/BKOrfDIfnaf0ApjiZGDLM0mrm57iKA
 M071bss1OYoAqoRjOLJhPloEaxA=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5ecb9fdd67bb73a129912e3a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 May 2020 10:37:17
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1BC66C433C6; Mon, 25 May 2020 10:37:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7DCD1C433C9;
        Mon, 25 May 2020 10:37:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7DCD1C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Yuehaibing <yuehaibing@huawei.com>
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
        <87a720b7p7.fsf@codeaurora.org>
        <cf5a8e36-2fc6-3f3a-823f-a2fac6c11d30@huawei.com>
Date:   Mon, 25 May 2020 13:37:10 +0300
In-Reply-To: <cf5a8e36-2fc6-3f3a-823f-a2fac6c11d30@huawei.com>
        (yuehaibing@huawei.com's message of "Fri, 22 May 2020 19:34:28 +0800")
Message-ID: <87k1109u7d.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yuehaibing <yuehaibing@huawei.com> writes:

> On 2020/5/22 18:11, Kalle Valo wrote:
>> YueHaibing <yuehaibing@huawei.com> writes:
>>=20
>>> In file included from ./include/linux/firmware.h:6:0,
>>>                  from drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:4:
>>> In function =E2=80=98__mt7915_mcu_msg_send=E2=80=99,
>>>     inlined from =E2=80=98mt7915_mcu_send_message=E2=80=99 at drivers/n=
et/wireless/mediatek/mt76/mt7915/mcu.c:370:6:
>>> ./include/linux/compiler.h:396:38: error: call to =E2=80=98__compiletim=
e_assert_545=E2=80=99 declared with attribute error: BUILD_BUG_ON failed: c=
md =3D=3D MCU_EXT_CMD_EFUSE_ACCESS && mcu_txd->set_query !=3D MCU_Q_QUERY
>>>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER_=
_)
>>>                                       ^
>>> ./include/linux/compiler.h:377:4: note: in definition of macro =E2=80=
=98__compiletime_assert=E2=80=99
>>>     prefix ## suffix();    \
>>>     ^~~~~~
>>> ./include/linux/compiler.h:396:2: note: in expansion of macro =E2=80=98=
_compiletime_assert=E2=80=99
>>>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER_=
_)
>>>   ^~~~~~~~~~~~~~~~~~~
>>> ./include/linux/build_bug.h:39:37: note: in expansion of macro =E2=80=
=98compiletime_assert=E2=80=99
>>>  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>>>                                      ^~~~~~~~~~~~~~~~~~
>>> ./include/linux/build_bug.h:50:2: note: in expansion of macro =E2=80=98=
BUILD_BUG_ON_MSG=E2=80=99
>>>   BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>>>   ^~~~~~~~~~~~~~~~
>>> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:280:2: note: in expansi=
on of macro =E2=80=98BUILD_BUG_ON=E2=80=99
>>>   BUILD_BUG_ON(cmd =3D=3D MCU_EXT_CMD_EFUSE_ACCESS &&
>>>   ^~~~~~~~~~~~
>>>
>>> BUILD_BUG_ON is meaningless here, chang it to WARN_ON.
>>>
>>> Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based c=
hipsets")
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>=20
>> I'm curious why I don't see this build error? I was about to send a pull
>> request to Dave, should I hold off the pull request due to this problem?
>
> The config is attached
>
> gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)

Thanks, I was able to reproduce the error with gcc-10 using your config
but didn't have time to investigate what was different in my config and
why I didn't see it.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
