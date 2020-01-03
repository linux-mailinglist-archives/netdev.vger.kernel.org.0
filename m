Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F17912FCE2
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 20:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgACTNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 14:13:20 -0500
Received: from mail-ed1-f43.google.com ([209.85.208.43]:32778 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbgACTNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 14:13:20 -0500
Received: by mail-ed1-f43.google.com with SMTP id r21so42398549edq.0;
        Fri, 03 Jan 2020 11:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mJgZ6foC5X2L3PU1OYn3aOckELw2Hq9GWYF/0Ih/oEA=;
        b=KLoelPZ3P4+qC9Qv/UPorq+aZdYVDP4Pk4HjgFD6T4/V/1mlZjvdN+jZeDbn1H/sU0
         KXSq3AwEWxoePWhFULGURiZnud5VzyugNavbvhRFDS5ihJk9aKUR55gRKp8Z4HbGubH8
         0smQ9z7qQ8q7SaGbpr7tbnPH9r5KQnyWDaDVC3S7oUcMk2iHmXru1y+ZmRpCXodepOHz
         N+UamyOGwzLMY6WZ+jcy444ea8d1DFa4JhH/nntYecLuJux5Yuvt/ayiPu7h/I6o32C2
         Lp1Qg0+XpDcp96X8FhbXteCHFZoecPBDuN2RmcRz4NZosGpC/zbOzm/YkHK6TdSetR76
         Lfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mJgZ6foC5X2L3PU1OYn3aOckELw2Hq9GWYF/0Ih/oEA=;
        b=tknkzfuTTmcA8af0j85iF9uymAHT+jS2GgO/lhX+xlO8R00VMz7Iat3CMbYcyoPYjW
         LTQO/+T7aA1ghyI817D0lmyt8LUg/YK3sbV2ymFi2K2I3MOnEHL/WheZ7GR0ss0n5T4M
         V+iafpO/7JXlprsKWKzo7d3NGgYcXr/FZUj//vdKM+LZCZgL+gjWRfLTgvY02TO6oaG0
         KTjlmhaBg12KVFAVTFoR5+wxR/6Dst7ymZlkTZUc3KXi2Vdc3F037sjjqQ5ELoUFINMU
         xJcS1V8nJqT2p4Ojmw1FbglRCxV4059IYItKrRFwewIpfuMknYcwKVqMxMLPoII8jFfL
         C60Q==
X-Gm-Message-State: APjAAAXVMXoLNohT4gNIF4olknGIcy87LulN0GTtBmmvTz4Qx+7BFbrT
        qyIxH8WELFfWp/MRokVEzhJHreBGAE742xhTATM=
X-Google-Smtp-Source: APXvYqxiPemLnCmmxKwarmQGLHxcAXw5mT3JE7BUYpP0KXIrUq21gnizFMzi9b0QLGGayzTh+PBYv0FmG7wXASaMfcw=
X-Received: by 2002:a17:906:c35a:: with SMTP id ci26mr96583374ejb.133.1578078798402;
 Fri, 03 Jan 2020 11:13:18 -0800 (PST)
MIME-Version: 1.0
References: <20200103121907.5769-1-yukuai3@huawei.com> <20200103144623.GI6788@bombadil.infradead.org>
 <20200103175318.GN1397@lunn.ch>
In-Reply-To: <20200103175318.GN1397@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 3 Jan 2020 21:13:07 +0200
Message-ID: <CA+h21hqcz=QF8bq285JjdOn+gsOGvGSnDiWzDOS5-XGAGGGr9w@mail.gmail.com>
Subject: Re: [PATCH] net: 3com: 3c59x: remove set but not used variable 'mii_reg1'
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Matthew Wilcox <willy@infradead.org>, yu kuai <yukuai3@huawei.com>,
        klassert@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        hslester96@gmail.com, mst@redhat.com, yang.wei9@zte.com.cn,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, 3 Jan 2020 at 19:54, Andrew Lunn <andrew@lunn.ch> wrote:
>
> I fully agree about the general case. However, reading the MII_BMSR
> should not have any side affects. It would be an odd Ethernet PHY if
> it did.

This is not really correct. As far as I know the clause 22 spec
requires the link status bit in BMSR to be latching low, so that
momentary losses of link can be caught post-facto.
In fact, even genphy_update_link treats this case:

    /* The link state is latched low so that momentary link
     * drops can be detected. Do not double-read the status
     * in polling mode to detect such short link drops.
     */
    if (!phy_polling_mode(phydev)) {
        status = phy_read(phydev, MII_BMSR);
        if (status < 0)
            return status;
        else if (status & BMSR_LSTATUS)
            goto done;
    }

So no, reading BMSR generally is not without side effects, and that
does not make the PHY odd.

Whether clearing the latching-low status bits is of any relevance to
the 3com 3c59x driver bookkeeping, that I have not clue.

>
>    Andrew

Regards,
-Vladimir
