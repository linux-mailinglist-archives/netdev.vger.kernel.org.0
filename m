Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71F6513B9A
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 20:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351079AbiD1SgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 14:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbiD1SgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 14:36:10 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7755A0B5;
        Thu, 28 Apr 2022 11:32:55 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id x17so10122448lfa.10;
        Thu, 28 Apr 2022 11:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iYwpAKlBkZoPA+yWEtVITUSSaNgmAu1b7cqpcYmcgAs=;
        b=FDcR/vXjfY+XIBnB6FHqa86R83ugNPGhcGpD7RyQNBz6flZF5XQ8qaX3LsYOKtgv76
         DowHZHgqx4Hf/pMz0PIHUZPQAUSkBX3NYZfruy8FNrnRoGqyte0OnMuKaORovJSY9K0S
         3/BslUsyZtESxrtGXtLhaH1HozfRHq7TcfUyzEOpIYwnzAxyQK5gBxWQwkJtximsn+zq
         xVWkwQid11qdaQRUkaIeMCsFpQhvWNtvlVkLGOB/ch7i3IhSYNqGZa0G47L2h9Gkk0xx
         RrS5zzNtjXi0aaIPROSgngT5F2QrQu2TsPxQhktbPiUPwAK6pKbhYLfpAjgG//wIHukb
         /uyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iYwpAKlBkZoPA+yWEtVITUSSaNgmAu1b7cqpcYmcgAs=;
        b=YXr9BbA1ELKgktNdFZVvZfTdb0vuq5ScjdEBuVXlCJ6zBevZCPVr276F8LzL1flXmM
         i49KQsAn8oBQV6wghkZvzNibFe+Wj6Dn5UNGUsl7lXBVgrBs8c2VkxxjIt3Xer/PeP7b
         CR8vAhdJXu1ZMyqyNP1h9L2CJ+X8S7Pif5EJJRD9mi/rc0pa5ZSrJnd9aZjuQBBsjgvW
         c/vv1Yd5Ssiw6178nucI5vPUbZwfFoAvNwto0vgv8tfoxqm8WbgGH9T+hX4gJonTmzoC
         NzdIFDn5aKYzfnyE9BR/+8g9ffOPdafB7qljud4XvAv13dC9c5V3YnoMu7yL3e4U6Bso
         NS+Q==
X-Gm-Message-State: AOAM530NWI1etFvK7Zdv8+ITd608EZJH+H/emaDoAYlV58C8EMytH7TF
        r4W3FQk4ya21TnmK8NEei4sAIbpuRTCQlnRhHvVNF78m114=
X-Google-Smtp-Source: ABdhPJzsy1/W6+3xM32IUqcIqcmbNNq7+WISt3f7vBJVg1pdNFOhH6dUMHKesA2D182dULqFfbmthxKAaF4cv4tfYGY=
X-Received: by 2002:a05:6512:15a0:b0:472:d09:a6b4 with SMTP id
 bp32-20020a05651215a000b004720d09a6b4mr13631034lfb.656.1651170773738; Thu, 28
 Apr 2022 11:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220428164140.251965-1-miquel.raynal@bootlin.com>
In-Reply-To: <20220428164140.251965-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 28 Apr 2022 14:32:42 -0400
Message-ID: <CAB_54W5c0gATeeSEa5Wy150nT1Hoh91ygYuuNrMW4J-DQ7czGQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next] net: mac802154: Fix symbol durations
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Apr 28, 2022 at 12:41 PM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> There are two major issues in the logic calculating the symbol durations
> based on the page/channel:
> - The page number is used in place of the channel value.
> - The BIT() macro is missing because we want to check the channel
>   value against a bitmask.
>
> Fix these two errors and apologize loudly for this mistake.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

Acked-by: Alexander Aring <aahringo@redhat.com>

- Alex
