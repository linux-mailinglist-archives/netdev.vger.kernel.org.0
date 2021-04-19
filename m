Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED215363B70
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhDSGZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhDSGZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 02:25:06 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38460C061760;
        Sun, 18 Apr 2021 23:24:37 -0700 (PDT)
Received: from miraculix.mork.no (fwa161.mork.no [192.168.9.161])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 13J6OA33005567
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 19 Apr 2021 08:24:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1618813450; bh=E7X1Z/C7m4uTr61eYxZTSepR9nL5wv+XsO96GsmyN1o=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=Ik288FpI4+tP3NUif79juWd79WI9mF6EwixRHDNl9pM365SLN/2YUjFGhP517DrAq
         iLKyA9hXRV4N1CNtUMM0qq9onUb9jv5Jpf3XyXpHfg8L0Qpk+MtZXnF0Otd1cyAcmB
         tak3jj60+xS63bbFXtSk0SkE9+bzRGtYPXIk7s6M=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1lYNKL-000bQN-NA; Mon, 19 Apr 2021 08:24:09 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Ungerer <gerg@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: net: mediatek: support MT7621 SoC
Organization: m
References: <20210419034253.21322-1-ilya.lipnitskiy@gmail.com>
Date:   Mon, 19 Apr 2021 08:24:09 +0200
In-Reply-To: <20210419034253.21322-1-ilya.lipnitskiy@gmail.com> (Ilya
        Lipnitskiy's message of "Sun, 18 Apr 2021 20:42:53 -0700")
Message-ID: <878s5e94hi.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com> writes:

> Add missing binding documentation for SoC support that has been in place
> since v5.1
>
> Fixes: 889bcbdeee57 ("net: ethernet: mediatek: support MT7621 SoC etherne=
t hardware")
> Cc: Bj=C3=B8rn Mork <bjorn@mork.no>
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/mediatek-net.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Doc=
umentation/devicetree/bindings/net/mediatek-net.txt
> index 72d03e07cf7c..950ef6af20b1 100644
> --- a/Documentation/devicetree/bindings/net/mediatek-net.txt
> +++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
> @@ -10,6 +10,7 @@ Required properties:
>  - compatible: Should be
>  		"mediatek,mt2701-eth": for MT2701 SoC
>  		"mediatek,mt7623-eth", "mediatek,mt2701-eth": for MT7623 SoC
> +		"mediatek,mt7621-eth": for MT7621 SoC
>  		"mediatek,mt7622-eth": for MT7622 SoC
>  		"mediatek,mt7629-eth": for MT7629 SoC
>  		"ralink,rt5350-eth": for Ralink Rt5350F and MT7628/88 SoC


Thanks for taking care of this!

Note, however, that this compatible value is defined in
Documentation/devicetree/bindings/net/ralink,rt2880-net.txt

I believe that file should go away. These two files are both documenting
the same compatible property AFAICS.


Bj=C3=B8rn
