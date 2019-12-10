Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D02C118E84
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfLJRFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:05:22 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37337 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfLJRFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:05:22 -0500
Received: by mail-ed1-f65.google.com with SMTP id cy15so16626767edb.4;
        Tue, 10 Dec 2019 09:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V/m7GvYpg3asIPZhHfNwzAdY+b/5CfIU9R9Z7IpYwiU=;
        b=urIFH+zO4UZfF2rCurnwpzVDpFNMAqb2rWMAIdXu58p8ugm6svnzZ31UqKn+Rtbu5e
         PQsO/BsQcZt/HKR9Hv4vG658oKEceiGQQVzZQcDCEEuiMdWZbPa8u31fvChGoYyihI6Y
         sl5fkWptMuptcHYYYeXRZneQVLiNZmRg52kmHZy2nFsGvceMwwa1MKoOeZ7HkVSFiCzK
         nuD7lyyY/3F2R8aVkID44KN0loAp/QQCgWhn4yFIKm+V7Jbnun8WnKWqmVo4Ntm+41Z5
         P+iwzzCI7ibvAAnmmMzUWCsPVXjIo3en5FfaJIT/ttoJaq9exR3GPS32l+UhFoQca0lg
         2mTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V/m7GvYpg3asIPZhHfNwzAdY+b/5CfIU9R9Z7IpYwiU=;
        b=dLQCvLvKcvZY8c3Bl29HYB9hejgb4ngDKjrvWsVJokR6aJKEyHpbtKl2bqS9LSO6vb
         cEI1tK1lCtzquyzn8bQUrdQfuy1cmjWobRX5emuMJ/LnUDsv9ipQXyiNCDyLW20AWOm3
         tjftByKCqehd27YsRHklzytUYdOAPRz56Ee7iR8TClyANDcUoYFdgrgp3IzevbvXHZ+U
         Z09KIBcZbq5Xd9DthvQkKikv/j/1e6JLbSCpkMnojn1Qb575HcCDEGgNvqmHzVub4tCB
         dvvJbQlV65XnI5IAcMZvApehrH7P9noXT054kjOglV2WwyKfQId50yezGy0bCIEqnbwj
         jcRw==
X-Gm-Message-State: APjAAAX+fqbonNqu8TixMR8DFHNuf7kQ3ixXPmyPRmQPUkh5xug+LIys
        ggznIfKfp9RW7St8f6uAXOEM0s7moQ+jdsWwuVg=
X-Google-Smtp-Source: APXvYqzyHbVIEY/8yAXTbmWOCmJY+Np2u+GYL67HEkNJeOc5mAbpPhpBS37Z+eeJdlRiZHSgZ7qlEoQyRL9kKTMTrHc=
X-Received: by 2002:a17:907:11cc:: with SMTP id va12mr4844106ejb.164.1575997520215;
 Tue, 10 Dec 2019 09:05:20 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575914275.git.landen.chao@mediatek.com>
 <6d608dd024edc90b09ba4fe35417b693847f973c.1575914275.git.landen.chao@mediatek.com>
 <20191210163557.GC27714@lunn.ch>
In-Reply-To: <20191210163557.GC27714@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 10 Dec 2019 19:05:08 +0200
Message-ID: <CA+h21hp12UGQ04W4rDo2PdFa2_5oMmX05KKUecdz5-+hv-JqAA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] net: dsa: mt7530: Add the support of MT7531 switch
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Landen Chao <landen.chao@mediatek.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        matthias.bgg@gmail.com, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>, sean.wang@mediatek.com,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        frank-w@public-files.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Landen, Andrew,

On Tue, 10 Dec 2019 at 18:36, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Dec 10, 2019 at 04:14:40PM +0800, Landen Chao wrote:
> > Add new support for MT7531:
> >
> > MT7531 is the next generation of MT7530. It is also a 7-ports switch with
> > 5 giga embedded phys, 2 cpu ports, and the same MAC logic of MT7530. Cpu
> > port 6 only supports HSGMII interface. Cpu port 5 supports either RGMII
> > or HSGMII in different HW sku.
>
> Hi Landen
>
> Looking at the code, you seem to treat HSGMII as 2500Base-X. Is this
> correct? Or is it SGMII over clocked to 2.5Gbps?
>
>          Andrew

I think the better question is: what is being understood by HSGMII?
What does the AN base page look like? Do you support AN with the 2500
baud speed? Do you support AN with lower speeds? Do you support lower
speeds at all? What PHYs do you interoperate with in this mode? If you
don't support AN, then what's so SGMII about it? And for that matter,
if you don't support AN, what's so 2500Base-X (802.3z) about it? I see
you unconditionally force the speed and disable AN in this mode. Do
you have any reference for what SerDes protocol your hardware
implements in this mode?

Thanks,
-Vladimir
