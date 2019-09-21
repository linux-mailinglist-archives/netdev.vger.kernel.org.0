Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50BBCB9F72
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 20:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732266AbfIUSqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 14:46:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43931 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731877AbfIUSq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 14:46:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id d4so2552263pgd.10
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 11:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gZgapyHyH+z8gwryep0g9GJqqxSOwZDa0VOuFSFTh7U=;
        b=QX7r75rsGufPXqaJn18X+USDCtCeYN76gTDDFNm5TdsuF6FBvbBVxQg+DxpRdjxNsE
         4qezjRwMSeWooIBocQtJA7D00B2Y2USSXSUCqo1JUx6MmHxhWB205zTOnz4Ic07jtGQT
         Hv2utAWctZKnJNCD4yIOt3WslfIwfh/0GiVQK5m1UQKoiMD14V/IB0XWmfMV6BecCHtZ
         ex0xLYCEquo7rHDOHfvpMneGxRpOX0IGoh6NQVUBvUW0pp1GO3dKd2vfW1FOBgLUf4HB
         bHjaH7kML3sYvyNXA+Q1S/8BXg7qJ87ukBBJbpFMmv9BZAv0c0ffaI/quD7NYmOa9KBQ
         HjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gZgapyHyH+z8gwryep0g9GJqqxSOwZDa0VOuFSFTh7U=;
        b=ovMJlz4wNHaUnsZG6lmLQM7UpmwJG92aQSstbsPWrkoMUU+qo436kfnUZ3bjB+iK0C
         ziwLsgcBjUIPo1WoQDapjlNy8XPr1bsshGjs3YfwzxaU/Q1ZmebjSCUNBegoKZHAdt1p
         Ic3A9wOD4+s0wL9ORK9gBZgFfcR2gdBUIS+DwsH0phGX4IlIXYuZI47NmJ961HcX9V0R
         VDBmChg2vTLtbJO2CPfg8AylqYn759FtqLkiQ46mUvtURy4Cc2T/dYgbLMd+WWIGnGFv
         LJnD8m77pX55isnhQFftDm/8rYH2zdiKjBGicJ/Tb+Gs4RDkKU3N+wXtBWckbBBrWff8
         S/tg==
X-Gm-Message-State: APjAAAVJVueKDlWsFeTv8oXN2Sr7YmQO2yFLKXH3PqSEx7ie2/tjKtGv
        taSvZ0brzRZ6azvvOBo/YyR/cA==
X-Google-Smtp-Source: APXvYqzhw4Or80vd1JWPD+/gJBS1uUISAWYzm4nXN1BXmGT5xEQKlE1LbadZGcLKUXuZZAU5ZTSiXQ==
X-Received: by 2002:a62:2787:: with SMTP id n129mr24547914pfn.45.1569091588773;
        Sat, 21 Sep 2019 11:46:28 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 62sm10472395pfg.164.2019.09.21.11.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 11:46:28 -0700 (PDT)
Date:   Sat, 21 Sep 2019 11:46:24 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, andrew@lunn.ch
Subject: Re: [PATCH] dt-bindings: net: dwmac: fix 'mac-mode' type
Message-ID: <20190921114624.453e4b32@cakuba.netronome.com>
In-Reply-To: <f189cdbc-b399-7700-a39a-ba185df4af49@gmail.com>
References: <20190917103052.13456-1-alexandru.ardelean@analog.com>
        <20190920181141.52cfee67@cakuba.netronome.com>
        <f189cdbc-b399-7700-a39a-ba185df4af49@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Sep 2019 20:02:58 -0700, Florian Fainelli wrote:
> On 9/20/2019 6:11 PM, Jakub Kicinski wrote:
> > On Tue, 17 Sep 2019 13:30:52 +0300, Alexandru Ardelean wrote: =20
> >> The 'mac-mode' property is similar to 'phy-mode' and 'phy-connection-t=
ype',
> >> which are enums of mode strings.
> >>
> >> The 'dwmac' driver supports almost all modes declared in the 'phy-mode'
> >> enum (except for 1 or 2). But in general, there may be a case where
> >> 'mac-mode' becomes more generic and is moved as part of phylib or netd=
ev.
> >>
> >> In any case, the 'mac-mode' field should be made an enum, and it also =
makes
> >> sense to just reference the 'phy-connection-type' from
> >> 'ethernet-controller.yaml'. That will also make it more future-proof f=
or new
> >> modes.
> >>
> >> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com> =20
> >=20
> > Applied, thank you!
> >=20
> > FWIW I had to add the Fixes tag by hand, either ozlabs patchwork or my
> > git-pw doesn't have the automagic handling there, yet. =20
>=20
> AFAICT the ozlabs patchwork instance does not do it, but if you have
> patchwork administrative rights (the jango administration panel I mean)
> then it is simple to add the regular expression to the list of tags that
> patchwork already recognized. Had tried getting that included by
> default, but it also counted all of those tags and therefore was not
> particularly fine grained:
>=20
> https://lists.ozlabs.org/pipermail/patchwork/2017-January/003910.html

Curious, it did seem to have counted the Fixes in the 'F' field on the
web UI but git-pw didn't pull it down =F0=9F=A4=94

linux$ git checkout 92974a1d006ad8b30d53047c70974c9e065eb7df
Note: checking out '92974a1d006ad8b30d53047c70974c9e065eb7df'.
[...]
linux$ git pw patch apply 1163199 --signoff
11:41 linux$ git show
commit ac964661384b93ff3c9839c6d56f293195d54b4e (HEAD)
Author: Alexandru Ardelean <alexandru.ardelean@analog.com>
Date:   Tue Sep 17 13:30:52 2019 +0300

    dt-bindings: net: dwmac: fix 'mac-mode' type
   =20
    The 'mac-mode' property is similar to 'phy-mode' and 'phy-connection-ty=
pe',
    which are enums of mode strings.
   =20
    The 'dwmac' driver supports almost all modes declared in the 'phy-mode'
    enum (except for 1 or 2). But in general, there may be a case where
    'mac-mode' becomes more generic and is moved as part of phylib or netde=
v.
   =20
    In any case, the 'mac-mode' field should be made an enum, and it also m=
akes
    sense to just reference the 'phy-connection-type' from
    'ethernet-controller.yaml'. That will also make it more future-proof fo=
r new
    modes.
   =20
    Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
    Reviewed-by: Andrew Lunn <andrew@lunn.ch>
    Reviewed-by: Rob Herring <robh@kernel.org>
    Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

11:41 linux$=20
