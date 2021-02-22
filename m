Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FEA32106A
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBVFZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhBVFZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:25:47 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE1DC061786
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:25:07 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id k1so425070oop.0
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r/HtVIHAQfytbp52XL64b8xtv78rRZf2vo32q/8i/E0=;
        b=VrHSzb/j/ajUUcyobfqvAUAoiquh6i3asyMfe3sela5aNEu1W9JBC1b3Frg2U7zrc7
         2IQuBMkFE3uotMEQ8KkBOLcsUdBwnIXRRF2V6rFu+q+dyA40sC1ReKfLJCRBz3R+ik1j
         Ek2lppxuyxXo3D1NSu7efGsT+CmZzE+0jIbijin6VZZMYNkkrXk2rm2LbYSV/zTe68GJ
         ROfJMScUsUPxyzMqrMCok7hIIhjae6QRrZ/5aCKA+LzbbRNu5WPiJ6k+D5UioVqAwWML
         p098wLAimm31/BGmxylBQ0kf745gmsoXk0o9TM6qQev3aLQb4h48SgAYWRHdKwWJyeTf
         5IcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r/HtVIHAQfytbp52XL64b8xtv78rRZf2vo32q/8i/E0=;
        b=oaW/cKhVljAg4lmYiyW0YlzIX0rLIx03fg+wemRmRD+ahcx7aNMgmekWmtGYe2ba+c
         rEop+WNGaCNZQfM8YdB40oh0LRQ4s/9+FYPZ6qYAfPmyv/pqNcg3LmBAhe2yjqCvvTAr
         wie35vPX2X3iUGxriv+NBWTTu9MXYd2AofjblIsKie1W4Yoe/v58AjerHufLKrTQhOGd
         ImJAK+W4yVt8dqQzBE9ARwn/VYcBWP+RTScBUaJXSJl43K7nUBq+MJvpoXjByfsg9Xd5
         soCKYYEqoTLf/2oc3wq+nUbwBnb5vpqXH7kLRfeMQ7RXjsNy8RKBX7JeMfFMPEGI6hBt
         QksQ==
X-Gm-Message-State: AOAM531NjU1sRHFdt8MxvmXK0map44AFGz1s9pMilbpJiFDyB2b8jJeh
        T4zniKFecFNmJf32+V4UO6c=
X-Google-Smtp-Source: ABdhPJyict2Sl3G1B1W56krGa2VhGFM2UPEU47S+2YT0dBiusUKx9TJXM6vlYK3Xwv+ruTG35+U5KA==
X-Received: by 2002:a4a:be01:: with SMTP id l1mr10369655oop.89.1613971507070;
        Sun, 21 Feb 2021 21:25:07 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id 7sm3450028oth.38.2021.02.21.21.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:25:06 -0800 (PST)
Subject: Re: [RFC PATCH net-next 12/12] Documentation: networking: switchdev:
 fix command for static FDB entries
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-13-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c618cb02-9ae8-06ac-8883-0397bdb035c4@gmail.com>
Date:   Sun, 21 Feb 2021 21:24:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-13-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The "bridge fdb add" command provided in the switchdev documentation is
> junk now, not only because it is syntactically incorrect and rejected by
> the iproute2 bridge program, but also because it was not updated in
> light of Arkadi Sharshevsky's radical switchdev refactoring in commit
> 29ab586c3d83 ("net: switchdev: Remove bridge bypass support from
> switchdev"). Try to explain what the intended usage pattern is with the
> new kernel implementation.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
