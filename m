Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB7A2BA143
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgKTDiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgKTDiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 22:38:03 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F40C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 19:38:03 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id t8so8492751iov.8
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 19:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjb0TOjLsMDjUodICH7KCcrpDGKufjexd1+8o7B9kb8=;
        b=ceTHKqCRixhp7kONN33MxtSkd783OojNPQR5/0AG/7DDFyEw59YudMfnCY7wgicujN
         M+qkJB0p65VxB5LaBCFKtoxY6vX8sUsueiN04sxxLhRcNO6VWkycNtPbF9ncobZMTWCm
         RjNmoxfTAwHOQ/2H9q9IdOUiGzlOOIecMdv8Su7g0oN1+yjya03FV1hdAJS45zCIM8le
         eEJa1TLZZSAUVuIc9ofmknfotd4V1EdtBsxIHJg2QBnuMJ6UzVwtGrUBJ1LvRX0nhYh4
         7cIvS1a6ET58abJ+N0LkpiHVRf2eNipHohu3wVIzFi2Ji02BXHd508Q9x8hIevmTJlaH
         9qqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjb0TOjLsMDjUodICH7KCcrpDGKufjexd1+8o7B9kb8=;
        b=baVkmU+B0yduxX5WUZRR/sIK8+jpav02rndewJsnM0DHztGwyH7C9/1NuWNHRtr9CP
         XxoLKBYrtcSfWOwEsdmLjuCEVa8AsN+2R1KwGUcvc9THYS49v6RYsrJN2Lc1i4Jol5/B
         eTS90opnhEbl2sPBwEBE9vlZmU2izj0iBSJYPsK88Oagqd44UEch31WVa0MwZmy/9Apa
         61MIH0Dafv007EhtyvmMe4D+EeVZ12SpBYQrrt/AUtXs6RrbrIkNqhMVlt54eJ41ArKO
         nmIsiRaTgdRwxNgcrB59ebRFPfpZyI+HOqV8M0rLILMa2uzFOrzU717aM0ahkSb3w/s7
         iP1w==
X-Gm-Message-State: AOAM533EQd/nPsbeKQyIeoiQosLjteuZgTgMlOIsErOr+a4DKnMvomPh
        PLOr76/nbqVmapFZEG8eSd4wbrgo8eX90EJ01Xo=
X-Google-Smtp-Source: ABdhPJypsMqrPht3AzlEWEj54WD7QLcxASxpFnXOhG3GU8sv2Ggz+0Z5+J3rw5aatqCoU3Xoo7EEMPQMqRCCPMzXIt0=
X-Received: by 2002:a6b:b3d6:: with SMTP id c205mr8665601iof.68.1605843482923;
 Thu, 19 Nov 2020 19:38:02 -0800 (PST)
MIME-Version: 1.0
References: <20201119064020.19522-1-dqfext@gmail.com> <20201120022540.GD1804098@lunn.ch>
In-Reply-To: <20201120022540.GD1804098@lunn.ch>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 20 Nov 2020 11:37:53 +0800
Message-ID: <CALW65jZzAh7sk-2ASuAj0gM=DGv6g6M7t_SjfSsBWkG=2pk_Og@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: support setting ageing time
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Greg Ungerer <gerg@kernel.org>,
        Alex Dewar <alex.dewar90@gmail.com>,
        Chuanhong Guo <gch981213@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:26 AM Andrew Lunn <andrew@lunn.ch> wrote:
> The bridge code will default to 300 seconds. And after a topology
> change, it sets it to 2 * the forwarding delay, which defaults to 15
> seconds. So maybe you can look for these two values, and use
> pre-computed values?

15 and 300 are not larger than 4096 (AGE_UNIT_MAX + 1) so the exact
match can always be found in the first iteration:

age_count = 0, age_unit = 14, secs = (0 + 1) * (14 + 1) = 15
age_count = 0, age_unit = 299, secs = (0 + 1) * (299 + 1) = 300

>
> You still need to handle other values, the user can configure these.
>
>              Andrew
