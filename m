Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 123E7105F11
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 04:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfKVDgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 22:36:53 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45234 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfKVDgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 22:36:53 -0500
Received: by mail-wr1-f66.google.com with SMTP id z10so6874182wrs.12
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 19:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K/kNmRQpAY6NDDX+4H119fem6mrNO0k6YvPUtE1nMXI=;
        b=gMO5d8EANHog7uOqBcUYbcK3sR4Rcun23ZcQUwhC4nbchx8NcZw+gYtlXJiorCVDPA
         NGQZX3DpJ/jDaVs9Qcagny1I/XkSDs5BhRXKRpoAVTijK4LQf3oR9WiVYQ7h5VlJhj3X
         GbjmDIbRe0F8qygoOc5ZFviADoRryejeF2nYRX57fxcqLrMBYjG+REddVb7+6J/jDZZI
         EJ7hAaIUGErLScGcE98UWng5kYdr2IJMOnyUa1tdSEQoEIk0dnGDiPnYt9k08N9m2vqW
         mw20H2TJ5sItbeCKjPPOsk8ws6ZoCn0dQVP0vFnikXp7LBlNBkft/dWNsNWhucY/Ikg+
         UNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=K/kNmRQpAY6NDDX+4H119fem6mrNO0k6YvPUtE1nMXI=;
        b=rjpaS/azMz4NiDzJKIT8NGpNwClV8DQS4ql0H2lA7/oeJZjamSQTQ5yv07lXV2v65J
         LbFiQACP/Lwr+386FzAg0PkNP0cyLi2Oednjb95o+sbLp6ouUB1XP/uKraDSQlaXTbhJ
         gvMH0yYFT4GKVU4EsAdDuOxqK2Y26HcaCe8lbWOqEvwHeO1Zei0VjVS/5e8+0CJTpYoo
         43aOluIt9MZZg2oPKCG+K8kJsTbCaniVch/fxysiO5wvs8H02F61X8iI0phO2GKmrC0o
         E0SjLcigtMdyNUcrAhDMhweN3/lXRHEjq18L+ccs0fR/axCMcZxSpRS1C/jIYnHVHskI
         5ykg==
X-Gm-Message-State: APjAAAVDqyz9xJ4ydXippPErvBI8hN3qxss2iATBjsvxd0oGO3srub1h
        VBeVBd9nBmhBtozgg2zCUY0=
X-Google-Smtp-Source: APXvYqyVr1GDOV0+efqL0RM7uap0OvWzeRm4hUvx0xyaE/NUzW0rGRCf2a/PH26QWw/2EaYUw1TEfQ==
X-Received: by 2002:adf:8426:: with SMTP id 35mr13417228wrf.262.1574393809796;
        Thu, 21 Nov 2019 19:36:49 -0800 (PST)
Received: from [10.230.29.119] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w7sm5795282wru.62.2019.11.21.19.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 19:36:49 -0800 (PST)
Subject: Re: [CFT PATCH net-next v2] net: phylink: rename mac_link_state() op
 to mac_pcs_get_state()
To:     David Miller <davem@davemloft.net>, rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, nicolas.ferre@microchip.com,
        thomas.petazzoni@bootlin.com, nbd@openwrt.org, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, radhey.shyam.pandey@xilinx.com,
        michal.simek@xilinx.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
References: <E1iXaSM-0004t1-9L@rmk-PC.armlinux.org.uk>
 <20191121.191417.1339124115325210078.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <0a9e016b-4ee3-1f1c-0222-74180f130e6c@gmail.com>
Date:   Thu, 21 Nov 2019 19:36:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121.191417.1339124115325210078.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/21/2019 7:14 PM, David Miller wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> Date: Thu, 21 Nov 2019 00:36:22 +0000
> 
>> Rename the mac_link_state() method to mac_pcs_get_state() to make it
>> clear that it should be returning the MACs PCS current state, which
>> is used for inband negotiation rather than just reading back what the
>> MAC has been configured for. Update the documentation to explicitly
>> mention that this is for inband.
>>
>> We drop the return value as well; most of phylink doesn't check the
>> return value and it is not clear what it should do on error - instead
>> arrange for state->link to be false.
>>
>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>> ---
>> This is something I'd like to do to make it clearer what phylink
>> expects of this function, and that it shouldn't just read-back how
>> the MAC was configured.
>>
>> This version drops the deeper changes, concentrating just on the
>> phylink API rather than delving deeper into drivers, as I haven't
>> received any feedback on that patch.
>>
>> It would be nice to see all these drivers tested with this change.
> 
> I'm tempted to just apply this, any objections?
> 

Russell, which of this patch or: http://patchwork.ozlabs.org/patch/1197425/

would you consider worthy of merging?
-- 
Florian
