Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BBE226DB7
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbgGTR6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgGTR6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 13:58:14 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D82C061794;
        Mon, 20 Jul 2020 10:58:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m22so10618226pgv.9;
        Mon, 20 Jul 2020 10:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dn+bkLkSM2KuCKSXgr83y2+KLzl+K9NcQTzlSg6shOw=;
        b=IVPx3/vUOZoleX2si86P7GBZQhDQfBmNSj5bNfeOjTPe/PcJT/frdYfHefwROvyw8y
         dmsNiVTu7IYvZkKTvIHonXifIDXWA29zGL0oCiEqssPnxmqeXDE2T+Ymm4FkFLl2h4Kq
         FvY8d8chMcK9tRBQc2CV5xQt46ujwWlyg04GNGGMX1qpVZ74B3LdMgqkRxT/EEPVO1D8
         PmV9VZ7D3n7j713ejV9r7cHZ/srYMvzFFJ4UeUlE6lbsW81D+uIIeEudiebAIlyOZA+7
         VdqYJQrmWPuUU3wfCe40/4ERIXixMWHX0Q5he2KrDL5jmhGN0zne09zYUlR8GNUMYwDX
         2VhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dn+bkLkSM2KuCKSXgr83y2+KLzl+K9NcQTzlSg6shOw=;
        b=WPQGNWMN9IJYt46jSnaEoYlr0a3UM/+P6Xm1ly0DiDi/g360Zow8xs3SDS7XPFEfH4
         oy14Cx8zfLuwHVHV6GB+ycnhh6Jy33n2YHo0ZFcusakrAzeo00qgqb+GkXQUvbf+MTOj
         B+bUPsbSAnr32/VB76ULgSeqbbDWOXMkGXtA85iBBNX2pYJ87HvI245/RjOQSeDwnq2T
         x1dbzfCUrqzHoHrSA5tOiZWa8v0L0XvdlENU89f1KBS5q68fv1Ap65YPNJnuMFIM9ngd
         9Q3IOW/41FNsTofVWfc6obaFCKY9JGbOyTzHHsPak7Py3zgWh7dqpkiaJhrzWpb/9xIs
         Uu8g==
X-Gm-Message-State: AOAM532pRPKEmUj0udqtKoRpvUBrStfu+vDaJjVMAB1DzcxobX+vkgCq
        jaHKCelr33SSJ8XD+PJ77lMhGQvlvWglnrBgPDQ=
X-Google-Smtp-Source: ABdhPJyUy9OUzx7NJxRwSJeXyNze72+OUAMDroKsg/wVdwo2gT5bAnmDsD13W9hyJDJ2SF9i6DOc0+yhLFfxxAXBQvQ=
X-Received: by 2002:a65:6707:: with SMTP id u7mr19505026pgf.233.1595267893842;
 Mon, 20 Jul 2020 10:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200716234433.6490-1-xie.he.0141@gmail.com> <b2836ae012e0c57ba01ba1dee0a9eacd@dev.tdt.de>
In-Reply-To: <b2836ae012e0c57ba01ba1dee0a9eacd@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 20 Jul 2020 10:58:03 -0700
Message-ID: <CAJht_EOZZFE0-Os90-CyO9M8xX-B7UYWaTHcLiFOcGvHh3TB7A@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/net/wan/x25_asy: Fix to make it work
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 4:23 AM -0700
Martin Schiller <ms@dev.tdt.de> wrote:
>
> LGTM.
>
> I have never used the driver, but the adjustments look conclusive. The
> functionality is now comparable to the one in the drivers lapbether or
> hdlc_x25.
>
> Reviewed-by: Martin Schiller <ms@dev.tdt.de>
>
Thank you so much!
