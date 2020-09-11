Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCD42663D1
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgIKQZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgIKQZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:25:35 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934ABC061756;
        Fri, 11 Sep 2020 09:25:35 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a9so1966957pjg.1;
        Fri, 11 Sep 2020 09:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EwU8Y8jyLbqhzR3bhbXCQ0ACvEAzu6m47XXNJBX9Eu0=;
        b=SfUAQosCbK7F+CBl7zdFfyy7Qjkzlzjvypp3h40Ri2q0NEVl/DGWoYvfZdf7dNwYZ0
         6B6xVOlk0gV3XYyrHba0XfY7kjOOkUoAEIMopB+FQn8ygUDiQoev3Y9k/nJXlDFz9QRj
         uUimSWYErzEK5C2/KjfjzPBo8zduEKwxDoSiNOYOlpHE/+mCU+CLzFh365uJFlh35ygd
         Gg9F1m55l8xUGHghbggvs/Ns7iKx0lvdHfcXz/3woZSlvyd+1/BxfLeMV29IeiKqCTFO
         SQcfnjeIZhGJSIj/fK6dBl4QeB/0+pkf3cfF7kh0OxsfMn4g5FtTJJnrQWSAY1i64dtI
         Wqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EwU8Y8jyLbqhzR3bhbXCQ0ACvEAzu6m47XXNJBX9Eu0=;
        b=VfYwvcig0S0ONJ4T1BtoxDYI7IzerqSR6FN/atugm7K0m8P9G6d6f9cB9a4H8aZWNi
         tO2cDzlBh94QH+irwssvgrkYkDsAyV3GcGfjszYoZVuwv/HNV1pPGGsxYUs+Zy2FppFo
         7jjrgsFVnX6kWOCom1/mjAssZ+An25FtDaoUxwXGKB2mRAgwuoD5mMViwAeZZPItZvNg
         EDlYZriiHDP4DmX1gBrduT3PM8srwVy5YQm9Nuc3G3JMMQBUoy2WSfAXBqSZLiFMkw5R
         l28RXsh+ANv/Qafr5fkPSfRB91LjOG+g0XKRsw0/a3tqZImYXLpdF5xIjTpH6SQQCdhR
         EvCw==
X-Gm-Message-State: AOAM533fs+4jdhXB/Sv7cUuhD60k2JulM4Tjnstb5l+aJwd36xhPe2Pf
        v/ENtwEADiiBC3j8jRugdqGepeWAtoY=
X-Google-Smtp-Source: ABdhPJwu1Tz3IzRQa+geTq4CMgMqps0FWRGe/wBTmbiN0XYcI0riziAr3xJ7SwNNK4/ShfIMqy2F1w==
X-Received: by 2002:a17:90b:1642:: with SMTP id il2mr2828500pjb.93.1599841534976;
        Fri, 11 Sep 2020 09:25:34 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c4sm645829pjq.7.2020.09.11.09.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 09:25:34 -0700 (PDT)
Subject: Re: [PATCH net-next v5 3/6] dt-bindings: net: dsa: add new MT7531
 binding to support MT7531
To:     Landen Chao <landen.chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        frank-w@public-files.de, opensource@vdorst.com, dqfext@gmail.com
References: <cover.1599829696.git.landen.chao@mediatek.com>
 <b5d44dc310a45dc139639d968350f5888dc7e1ac.1599829696.git.landen.chao@mediatek.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0b414c02-8860-cb0d-2131-de4e04cbf49c@gmail.com>
Date:   Fri, 11 Sep 2020 09:25:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <b5d44dc310a45dc139639d968350f5888dc7e1ac.1599829696.git.landen.chao@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/11/2020 6:48 AM, Landen Chao wrote:
> Add devicetree binding to support the compatible mt7531 switch as used
> in the MediaTek MT7531 switch.
> 
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
