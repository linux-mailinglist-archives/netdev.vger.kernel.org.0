Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E01B0C77
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbfILKRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:17:46 -0400
Received: from forward104p.mail.yandex.net ([77.88.28.107]:36603 "EHLO
        forward104p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730454AbfILKRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 06:17:46 -0400
Received: from mxback19o.mail.yandex.net (mxback19o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::70])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id 768E04B00F54;
        Thu, 12 Sep 2019 13:17:43 +0300 (MSK)
Received: from smtp3p.mail.yandex.net (smtp3p.mail.yandex.net [2a02:6b8:0:1472:2741:0:8b6:8])
        by mxback19o.mail.yandex.net (nwsmtp/Yandex) with ESMTP id nBsZZiBuAK-HfFKLkII;
        Thu, 12 Sep 2019 13:17:43 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cloudbear.ru; s=mail; t=1568283463;
        bh=1OrWmgCBOEcc7Ob5Zgorn88c1jPz+PwVD3IBo54AYgc=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=MMRA9c9icxUyWn9Fv/3Ad8vTg6eIql0R3zktqLLa681Spq/IYqTW+YXqppvkvn4/a
         U8vrCwz/9F9o1yNmOkreaNMUWsC6vCQ85T6QZxr7rQ4WAYsQHQez67zjMp/1XdTtid
         hkvQIjOTNtrCnzrYDC3aEVgHFnBrsLrtWBM2glzs=
Authentication-Results: mxback19o.mail.yandex.net; dkim=pass header.i=@cloudbear.ru
Received: by smtp3p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id FCyoj03qUM-Hel4FVqS;
        Thu, 12 Sep 2019 13:17:40 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: Re: [PATCH v4 2/2] net: phy: dp83867: Add SGMII mode type switching
To:     David Miller <davem@davemloft.net>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com, mark.rutland@arm.com,
        andrew@lunn.ch, hkallweit1@gmail.com, tpiepho@impinj.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1568047940-14490-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <1568049566-16708-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <20190912.003754.663480494374990855.davem@davemloft.net>
From:   Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
Message-ID: <83c63a9c-53f4-8f3e-38da-1f230cfca186@cloudbear.ru>
Date:   Thu, 12 Sep 2019 13:17:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190912.003754.663480494374990855.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, David.

Should I patch commit as Trent Piepho suggested? He wrote about using 
phy_modify_mmd() instead.

Vitaly.

On 12.09.2019 1:37, David Miller wrote:
> From: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
> Date: Mon,  9 Sep 2019 20:19:24 +0300
>
>> This patch adds ability to switch beetween two PHY SGMII modes.
>> Some hardware, for example, FPGA IP designs may use 6-wire mode
>> which enables differential SGMII clock to MAC.
>>
>> Signed-off-by: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
> Applied.
