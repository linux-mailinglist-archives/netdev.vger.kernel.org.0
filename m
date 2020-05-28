Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5299C1E62DA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390736AbgE1NwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390638AbgE1NvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 09:51:12 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8968C08C5C7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 06:51:10 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id r16so4107215qvm.6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 06:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3Rh8K4+22O+QrskrmwrNTFBFh5vNosv/sr65KhuOYxw=;
        b=DPWNkC3TUmnqZbbYEmi599uf3WJwosa8MGshm0VnwLkNfwtiOfu63b+H7co25zOIei
         /PFLTBpk9KSDfT2KHg43sSZUGFDhM/Eusszyg8Vv+bhw1u5EKr819Kz0DbE+CegMJh0f
         w0L4heEofgU4koOwKyena9NVSqmdhHsetq1AiOAnOY4to4U+fFQcSsuyKItYt7e0hGpZ
         ZjPkjDF1i1tqA5bjWD20luWin4AwmRIreRgFjGZ7FrbOg5gXHP3PyTklpEiLRLiW4HTN
         qilde4CsbWe+FEVPmCjq+Ads2DQV8fXNlAMQ3UD9MCF3bBayQ3MRIWh9WXhLv6+LmZk+
         Wt6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3Rh8K4+22O+QrskrmwrNTFBFh5vNosv/sr65KhuOYxw=;
        b=nf0IkdPn126O5PKzfr2SyId6r4Z9IaecNE7EPpCYuuy56mIxhEPMjQYw4JcKDQzsXN
         ocU4KxHz6BnuKhZcz513X8b6RuSUOtTo48ITJQW9JFp4HLCBVdFRftrxkuJ02RodUWCF
         3wUXT7RCa2RZmEafh61R1f3rSDIHXHs+vRB/suDorTauDY2Ax2uS4ct4T6udEXNPJxg9
         pOJi3T8Y+6LlLArh8pohlENYLkOjLMcvFaMtb0KM78AqNN3wLMVFY5ZjgEAzkVohBjsf
         TV/oEwCtpnfve1L96MclIll+Vj27cGDlU1aakSaNU69wveSm79ZERHsl6Qd/fCASxBIm
         HMNw==
X-Gm-Message-State: AOAM530YsNBL7HgZW/hMOg29f/E7uWsY4lGadDleWcLS/6hsJAdBNNb4
        LdbWOKhxWMXpMNFREnF1S5DJROVQdi+B2Sl90WxAvg==
X-Google-Smtp-Source: ABdhPJwwhNNg2jX7o0MVbONScnOgv1IrK2/t9ZTXd2p5X6gY80YlNgs/fudAJIX62UrVDXZuWcm7dMxbLlnnFexePB4=
X-Received: by 2002:a0c:fb4b:: with SMTP id b11mr3078897qvq.96.1590673869956;
 Thu, 28 May 2020 06:51:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200528132743.9221-1-brgl@bgdev.pl>
In-Reply-To: <20200528132743.9221-1-brgl@bgdev.pl>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 28 May 2020 15:50:58 +0200
Message-ID: <CAMpxmJU6=UfzMjB-zKV9ULPUdLe_qUr+zSwwrc1VXKv6HN6BEQ@mail.gmail.com>
Subject: Re: [PATCH net-next] dt-bindings: net: rename the bindings document
 for MediaTek STAR MAC
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 28 maj 2020 o 15:27 Bartosz Golaszewski <brgl@bgdev.pl> napisa=C5=82(=
a):
>
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> The driver itself was renamed before getting merged into mainline, but
> the binding document kept the old name. This makes both names consistent.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  .../net/{mediatek,eth-mac.yaml =3D> mediatek,star-emac.yaml}        | 0
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  rename Documentation/devicetree/bindings/net/{mediatek,eth-mac.yaml =3D>=
 mediatek,star-emac.yaml} (100%)
>
> diff --git a/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml =
b/Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
> similarity index 100%
> rename from Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
> rename to Documentation/devicetree/bindings/net/mediatek,star-emac.yaml
> --
> 2.26.1
>

-ETOOEARLY David please don't apply this - the id field needs to be
updated too. I'll send a v2.

Bartosz
