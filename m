Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3035563DB7
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 00:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfGIWHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 18:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfGIWHS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 18:07:18 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9BCC20861;
        Tue,  9 Jul 2019 22:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562710037;
        bh=OiT+uT8Hh/VlQ9ZgjGjxzgYYuE0c/OT4RlYMEBhiS5k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NyEKzN8IlVAhm6Tdqv51vd1lS0/oj+SkMEhmBUsVLQvIMFdj/CsOLuXH9/Qx8hgzQ
         6+0QhvDXdMrZwX8xjoxJSIJ3kLoJECTuqY8UucpfnBI5jzFP7LCY6chKUOKuux9KcL
         zpZHNVqnKwO/0sA+hjDJ+Qry2agsvxe36QeBe6Mg=
Received: by mail-qk1-f169.google.com with SMTP id m14so333356qka.10;
        Tue, 09 Jul 2019 15:07:16 -0700 (PDT)
X-Gm-Message-State: APjAAAX6ULWjPeJjHdA5X/xW2KvdPD4SajEWyXC0ePPJUCYutIQPUAAC
        jc5cUs0KIilFqYe5neomVA1H0tAk2dsoRD8fpw==
X-Google-Smtp-Source: APXvYqyjqlXZtypol45IgbwahudaQP3rpE7kZ07aIm8NcxIJhsZuyWFA6AFZSq6RcLqkQKFEl8ZdWIpMpeAp10DozqU=
X-Received: by 2002:a37:a44a:: with SMTP id n71mr18752828qke.393.1562710036205;
 Tue, 09 Jul 2019 15:07:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190706151900.14355-1-josua@solid-run.com> <20190709130101.5160-1-josua@solid-run.com>
 <20190709130101.5160-2-josua@solid-run.com>
In-Reply-To: <20190709130101.5160-2-josua@solid-run.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 9 Jul 2019 16:07:04 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+qh=M=aoSGfpRov55Bd4Vjeq1Ls7sxqtRsXStxOXmQwQ@mail.gmail.com>
Message-ID: <CAL_Jsq+qh=M=aoSGfpRov55Bd4Vjeq1Ls7sxqtRsXStxOXmQwQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] dt-bindings: allow up to four clocks for orion-mdio
To:     josua@solid-run.com
Cc:     netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 7:13 AM <josua@solid-run.com> wrote:
>
> From: Josua Mayer <josua@solid-run.com>
>
> Armada 8040 needs four clocks to be enabled for MDIO accesses to work.
> Update the binding to allow the extra clock to be specified.
>
> Cc: stable@vger.kernel.org
> Fixes: 6d6a331f44a1 ("dt-bindings: allow up to three clocks for orion-mdio")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Josua Mayer <josua@solid-run.com>
> ---
>  Documentation/devicetree/bindings/net/marvell-orion-mdio.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please don't resend patches when the last one is still under discussion.

Rob
