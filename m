Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC9C2C3070
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404397AbgKXTFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390880AbgKXTFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 14:05:46 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3835EC0613D6;
        Tue, 24 Nov 2020 11:05:46 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 131so19432527pfb.9;
        Tue, 24 Nov 2020 11:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B3AQ7qIleZ98ol81EX8UKJux3KkrTXmQK6HY6sjAr3Q=;
        b=cyZ66djmj11YFpB8eyen5l1og8njPdYe2JKIwrrePLcZoLVDmSMe+hS6Od0LksguBw
         eGwGFF6Q8d1FuGq6FkgIE266FU9eYTFoNGP2fsz7xIZuOxnBWLdO63qRCpREvO26AGQu
         +S0pVAXwYJoJiubREQlItqhFva77//OPa1w4dfs1B75V/T4+pLDe3SKPoRnJCAMhi91m
         P4zLMOU+Aw4XfzqlNzhKbm0Tho6QwgYVat0gVeYi3BM5C+1232G6a2H1UjXlRFTkyQFF
         rSYxs/+8lsI22Hy1hiMC+Iy46F7PifXVZAXrx0Ied4gEXvPORA/46C4iHMKEgmLIGgvB
         ObZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B3AQ7qIleZ98ol81EX8UKJux3KkrTXmQK6HY6sjAr3Q=;
        b=G/C4/4D/MDL9shokzWYTf4OIlbT0dzZ8phF3XHbjPZDLEUWlN357G+yfkd22zC13yf
         GcAWQvk3m9vM8/x1ghPq0MnjmLipIGv6mmF36EV61UzwCwsRrfUazFyKa6xpufKSa0hG
         FMvDIlleafBBmRQIKgGakytEwkJZDovBKfr40O1O0s0OV8+4AKi7FJBoFCcGPq2qPfa0
         cxvLrvvRklFXsu0QzJ4bt2C/eH4BeXH8CY04eBQa7po/qlWqZArPsBs3iod+cQ/F7mPo
         4b4DzJvWZiKn2nrGB6lpVS3quKOHVv3iic9csdfAbkajNinBrUMGpjP/ifnKG/+kN4v5
         Owzg==
X-Gm-Message-State: AOAM533ozAjH0EwYbT3GApVNY0vGNWUHrPLntGV8neB6hztutTbIhnV8
        x/0Bw3xWhkqzP/BfQVf4nujm/KlP8jP3/ZtD60hjU1kksqw=
X-Google-Smtp-Source: ABdhPJxjKII+6oaxfxVFzDno1Lx1iNTipA9Khcd+0BHqqjLkjNtdlrQW4o/TQ5RtCeTXuenG8SaDwMOjRlx6X1d8xlY=
X-Received: by 2002:a17:90a:5905:: with SMTP id k5mr30953pji.198.1606244745869;
 Tue, 24 Nov 2020 11:05:45 -0800 (PST)
MIME-Version: 1.0
References: <20201124093938.22012-1-ms@dev.tdt.de> <20201124093938.22012-3-ms@dev.tdt.de>
In-Reply-To: <20201124093938.22012-3-ms@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 24 Nov 2020 11:05:35 -0800
Message-ID: <CAJht_EOJ2M3tjN_2dQa2PweHCvJK8EXpnY7kGyJ7RezXBP4f8g@mail.gmail.com>
Subject: Re: [PATCH net-next v6 2/5] net/lapb: support netdev events
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 1:40 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> This patch allows layer2 (LAPB) to react to netdev events itself and
> avoids the detour via layer3 (X.25).
>
> 1. Establish layer2 on NETDEV_UP events, if the carrier is already up.
>
> 2. Call lapb_disconnect_request() on NETDEV_GOING_DOWN events to signal
>    the peer that the connection will go down.
>    (Only when the carrier is up.)
>
> 3. When a NETDEV_DOWN event occur, clear all queues, enter state
>    LAPB_STATE_0 and stop all timers.
>
> 4. The NETDEV_CHANGE event makes it possible to handle carrier loss and
>    detection.
>
>    In case of Carrier Loss, clear all queues, enter state LAPB_STATE_0
>    and stop all timers.
>
>    In case of Carrier Detection, we start timer t1 on a DCE interface,
>    and on a DTE interface we change to state LAPB_STATE_1 and start
>    sending SABM(E).
>
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>

Acked-by: Xie He <xie.he.0141@gmail.com>

Thanks!
