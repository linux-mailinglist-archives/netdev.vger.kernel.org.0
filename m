Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F4483967
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfHFTL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:11:27 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34074 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFTL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 15:11:27 -0400
Received: by mail-ot1-f68.google.com with SMTP id n5so95323076otk.1;
        Tue, 06 Aug 2019 12:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=csIIqB/IrDwLxPl2lYtUj9WD1Dt8I4kBPcjCQJ1GYDk=;
        b=FWZMw5rM9Sew425w6LoMV3JWYdZyFv45J6PeYPnLCESmUr1QSJ/KR+lmQdvj/ptwJE
         sGELprR/Q+lDFpDt5J8rRhPinv219RUzLN0fZ3YwLVZDSaLeVZjDam/znyeMBKqhDAq0
         IukAZZtnHks9qtfY0F9F9K+IqHL/j2xFQJdjg5z+oIOT2DHrXwPxeco1KLXMmnP8s4NV
         MXMUKdhOZ/addouKfHxBqR3/sbEWBUEflVVYRukqnLtVU5Ecjwp12d2QMoWAK5D6wsXi
         XNBnILgzzY1Rcln3VdrWhNhmpIikpvYE604u7ni6rgELv1JSA+fiWLHQL3dk4yYXsce0
         hjww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=csIIqB/IrDwLxPl2lYtUj9WD1Dt8I4kBPcjCQJ1GYDk=;
        b=le9sKqbjIKQNrScYDD7zTdyJSwm2figJllcMs1f8KzMSBVcMJkn44OgVouj3Bq+A13
         vB6EA3wf5mY5Jt8yRgQ5bUXcyYW8oqAdsp2wXq3TgRZn1WoKbBxn7CaPGCNsRlsqbp5l
         tuLTxMxGH+uQu+UflJoP6qKdlJseilzqo33gZ/KmdMgsAhrKe4qPbbu5LmqF+FreS84L
         TVv+txwTUAHDKi1Pd8YH/0ddpl8S0c4meTorUBB8ryMQ9td4V5VaKG1kZ1geL1VrOPI+
         ZXYnhsiVgUtQGwaKPmCkevTQ0Fbs9OSQcVf5EdWEDQHiQVqGAmh1SEIGbHL18eWcy+uE
         AQtg==
X-Gm-Message-State: APjAAAX89ppdwRhLfT5zIYoLRWJnrZbJeZqglMlHrL9+LE1OVFN2/c6M
        oy7xkEBtGvvuBARUqE3A+9Ev3PRzvYbWYxz3NdbA8xrP
X-Google-Smtp-Source: APXvYqwoRzmwN8s0WXpLys3Q35DBxnwW1evWctYoRF/gKNCVFoMTOKHWiSrEdkwTXUkFaAgXbhANT451Z5mIAbm1IxY=
X-Received: by 2002:a9d:226c:: with SMTP id o99mr4093932ota.42.1565118686396;
 Tue, 06 Aug 2019 12:11:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190806125041.16105-1-narmstrong@baylibre.com> <20190806125041.16105-3-narmstrong@baylibre.com>
In-Reply-To: <20190806125041.16105-3-narmstrong@baylibre.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 6 Aug 2019 21:11:15 +0200
Message-ID: <CAFBinCCw8sZnmWcHMtEGBrEGqok=3N0qBEaPBZ7_ixLFFtGnGw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dt-bindings: net: meson-dwmac: convert to yaml
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 2:50 PM Neil Armstrong <narmstrong@baylibre.com> wrote:
>
> Now that we have the DT validation in place, let's convert the device tree
> bindings for the Synopsys DWMAC Glue for Amlogic SoCs over to a YAML schemas.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
thank you for taking care of this conversion!
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[...]
> +        amlogic,tx-delay-ns:
> +          $ref: /schemas/types.yaml#definitions/uint32
> +          description:
> +            The internal RGMII TX clock delay (provided by this driver) in
> +            nanoseconds. Allowed values are 0ns, 2ns, 4ns, 6ns.
once I have more time I will try to see whether we can define an enum
with these values, then invalid values will yield a warning/error when
building the .dtb (which seems to be a good idea)
this comment shouldn't prevent this patch from being applied as the
initial conversion will already make life a lot easier


Martin
