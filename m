Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5D31DF678
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 11:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgEWJzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 05:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387764AbgEWJzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 05:55:45 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7773DC05BD43
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 02:55:44 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id k5so15570464lji.11
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 02:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CMclQJeEjaTGzozjvCY7w7Tg3uKCjCaOAOe9Qm2vLDY=;
        b=lgkXbzQaxZ3ZdUqaKD/Vk8++aL4V1xQFTCGOMMlMS2FwW/36sWQqk2y3t+S+XOpMKp
         7r1yk9sbFiX+ulpxmh9DHFT5Pneh83/ip4//P9XuXtjMGRrDQHSCl5yQkVKtyJETvZtc
         ZQTl2rX9KncufYqrd9gMLzSRR986GZ2TN8LshEnx8DUVP5XP2DfT64ZqAxmzwqgH7SkK
         XCNpFncBj8GW+ardlqcljq3zWqd4Os26P8ApyLAxXFOk2OjJBSXP57EkIhhGOKNm4moz
         cfOo1QTQ9RslEQmBxNG9B4XsKYMxPgfITMSU0erivsNpMHquKv4CFLRJGyQHpcKt+cAu
         CB6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CMclQJeEjaTGzozjvCY7w7Tg3uKCjCaOAOe9Qm2vLDY=;
        b=NAuYkn/AFipsZpPR8W8XeMcsg9HkTXGsqfCSWZzqPyIbrpRR6wAoUqF1dd55PFWIiv
         eMlUs//MKd2WtODJNbIrtulioYZ1nluKhokotPWajshNGDQdVKzCXwAyjY7asMdD34xk
         uHSaO4rqKSFYV4H/DXLmKcpmfLSoY9r+4oHZESmqGG7EbJSoF0piQPbLTHbZlC47k3bD
         RshRvB0UyJxHTFSO1GrHG/5W0UeS4GrerGn+gaSJWZf5asOPhRPtpXY5tfi+TwV7qnyM
         je10ifGsESfJAdgfpKMiInepwovW9p/d4CYDQYxuVopOE4fPufgAxqi96bAwwZoZo//i
         TFVQ==
X-Gm-Message-State: AOAM532g8z8UHAKzjKzfK0kPjihcORziY2+4aBogfSlNlLDmG7juY2Uj
        s3bXChzmcJ6whYAe7wRegv4TOEGuYI7E+Oq/vBi24Q==
X-Google-Smtp-Source: ABdhPJyWikAx3DmkIWIlzihQD50fVK6Jep9CtCjCkA+74uSibZApHsJ7HrlPDX3OHQ52a4Ly48BqBKXpN5ihKWU+NV0=
X-Received: by 2002:a2e:6c08:: with SMTP id h8mr7901816ljc.375.1590227741126;
 Sat, 23 May 2020 02:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com> <1589963516-26703-2-git-send-email-fugang.duan@nxp.com>
In-Reply-To: <1589963516-26703-2-git-send-email-fugang.duan@nxp.com>
From:   "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
Date:   Sat, 23 May 2020 11:55:30 +0200
Message-ID: <CANh8QzxuHAu+L0swPC5V4Oca21Z5zpiULTm22VPShX_T-JVznQ@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net: ethernet: fec: move GPR register offset and
 bit into DT
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

> Fixes: da722186f654(net: fec: set GPR bit on suspend by DT configuration)

Just a nitpick maybe but I don't really think this need as Fixes: tag.
That commit didn't actually *break* anything AFAIK.
It added WoL support for *some* SoCs that didn't have any in mainline
and didn't hurt the others.
Of course it turned out to be insufficient for the multiple FEC case
so this patch series is a welcome improvement.


>  struct fec_devinfo {
>         u32 quirks;
> -       u8 stop_gpr_reg;
> -       u8 stop_gpr_bit;
>  };

This structure has become redundant now that it only contains a single
u32 quirks field.
So we *could* go back to storing the quirks bitmask directly in
.driver_data as was done before.

It's a slight wastage to keep the, now unnecessary, indirection,
though the size impact is small
and it's only used at probe() time not on a hot path.

But switching back could be seen as code churn too...

I don't have a strong opinion on this, so just noting it to see what
others think.

Martin
