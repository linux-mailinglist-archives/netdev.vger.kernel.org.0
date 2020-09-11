Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8073D26591F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 08:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgIKGJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 02:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgIKGJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 02:09:03 -0400
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58366221ED;
        Fri, 11 Sep 2020 06:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599804542;
        bh=XzzaqRgzegv5mShrfRiMAX/0bKqxPmMJr5VwppGGwEw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ihhcwtVWk6dTGE+h9Hne7tOOv/piw6eF0oxfxjMAzyMEi76bRAHq4wh9HTqPQlReu
         FO4DNAMAN0P2AnALwa4Gh1oqnSXIPSd/9RwcY1PYk2Gwow+aZNT2gqUI10i7aXbuvY
         5OWPFFLx+B4R2b1vfMPvfrbmYQJTsJGjSjDapPtk=
Received: by mail-ej1-f43.google.com with SMTP id q13so12175433ejo.9;
        Thu, 10 Sep 2020 23:09:02 -0700 (PDT)
X-Gm-Message-State: AOAM533tXv5vpufzr3Fb557g3H4okNSow+XDuBOPW1CRs1jonFxUt5Fv
        fghRSZiOZaMpq364yqSPIxD5jrsQ5phzLLlvwAI=
X-Google-Smtp-Source: ABdhPJwZG4xklZq441Eewbql9ntW9zPs1xfQjq9o+LVzvNLUp2kxK3mUNknnSYBDmPX56LMLO75nMFLMG4xyFDPtcm4=
X-Received: by 2002:a17:906:8401:: with SMTP id n1mr505360ejx.215.1599804540886;
 Thu, 10 Sep 2020 23:09:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161219.6237-1-krzk@kernel.org> <20200910.152235.1512682061673845419.davem@davemloft.net>
In-Reply-To: <20200910.152235.1512682061673845419.davem@davemloft.net>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 11 Sep 2020 08:08:49 +0200
X-Gmail-Original-Message-ID: <CAJKOXPcFfxY2EU7-_gPQyhp9m_dVed6qxgpZzD4kazEkjDeXOw@mail.gmail.com>
Message-ID: <CAJKOXPcFfxY2EU7-_gPQyhp9m_dVed6qxgpZzD4kazEkjDeXOw@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] nfc: s3fwrn5: Few cleanups
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, robh+dt@kernel.org, k.opasiak@samsung.com,
        kgene@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 at 00:22, David Miller <davem@davemloft.net> wrote:
>
> From: Krzysztof Kozlowski <krzk@kernel.org>
> Date: Thu, 10 Sep 2020 18:12:11 +0200
>
> > Changes since v2:
> > 1. Fix dtschema ID after rename (patch 1/8).
> > 2. Apply patch 9/9 (defconfig change).
> >
> > Changes since v1:
> > 1. Rename dtschema file and add additionalProperties:false, as Rob
> >    suggested,
> > 2. Add Marek's tested-by,
> > 3. New patches: #4, #5, #6, #7 and #9.
>
> Seires applied to net-next, thanks.

Thanks. The DTS should go separate - via samsung-soc/arm-soc tree.
However if it is too late, then no problem.

Best regards,
Krzysztof
