Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA82453EC7
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhKQDIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhKQDIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 22:08:40 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C20BC061746
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:05:42 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 67-20020a1c1946000000b0030d4c90fa87so947842wmz.2
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UKZ6GaRD6run3c1PJPskqzhUzQy+wsAa2zgVKl5+4u8=;
        b=IGaA7Fhphxaznr+UYSLE09+pej6AmCx0QFzafA1J3gvETz6n84x/7uHPT1goftadgz
         oH1n8NH12lL+ny/jzQmx1GwD7lR4vo8+Tz6ypBlpSz0jTJbfMBgIif3OllUWjsecLwIn
         Y2V6Ay2vZomXg9PdU6QKQjspKTkKuJGSaXiUtm8df0ILGg9Cniit0xgQtJ4qfwk2rbXp
         CxK7IeP5YkznIOYHdUvbz/wRs04z573RbStv1lHuDsL8M5zdx+g0Ce+ntYHLFj0Qf3J9
         4uwQhWkVo2XpVC5ZdIBUP4A+abKzMAxb1yrUP2npWS+ptewmSl8KoburFWIaVeMbz9BO
         E8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UKZ6GaRD6run3c1PJPskqzhUzQy+wsAa2zgVKl5+4u8=;
        b=T/0Fr/oPwOeATAerc8pHtr4jWwO7Weq8IjdHB3NmN2PAr+Bq9u3yKCY6MQLHxJVe7+
         tvA/6cBlalbT1cR0/4kY5tlJC9EbrNYciDvjsyEd2mpxfsAmD38yQtc9ujjLAcsXAf5p
         dRLajYSIaLtqS/BdS82h25kEVraZlzHX+aRZvqXL0QY6rRa7VNBzymNfCQwR5t0Oldvk
         inH0xIVoQ8LtVOz1pbaKAx1sEwtRNq1j1PT91N28dTUfjlZCF8rcf6xgpbI8JiEcZ4Mt
         w62P9or194yqmu8b+dE5NcNwzneNOVMuL2R26vz6LvHdAXKQT0aHElsZ3grJDZPPRQT3
         KWLg==
X-Gm-Message-State: AOAM533a4qebF/q6q2Zcdmw28ze+2sfQGJApRHng/A57sPRAk/2XMfRx
        OkeT41VBrU/4Jg9apFW/7n/Fcbg3pyUScJP8mni7CHpeQuk=
X-Google-Smtp-Source: ABdhPJy4vo81ZBn+uQt56I0zEdMolI+WBTQ4qIs/blKZxO0eNUos1D3u/BgeLEce8BEwH2HAjPDjKINMSft8z1bJbG0=
X-Received: by 2002:a05:600c:3ba3:: with SMTP id n35mr14188808wms.88.1637118340213;
 Tue, 16 Nov 2021 19:05:40 -0800 (PST)
MIME-Version: 1.0
References: <20211117135510.0307294e@canb.auug.org.au>
In-Reply-To: <20211117135510.0307294e@canb.auug.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Nov 2021 19:05:28 -0800
Message-ID: <CANn89iL=gHkZg5YUVYmPMB79xA_d5eDXjQLS_85Ks_NU6q97HA@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 6:55 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the net-next tree, today's linux-next build (htmldocs)
> produced this warning:
>
> include/net/sock.h:540: warning: Function parameter or member 'defer_list' not described in 'sock'
>
> Introduced by commit
>
>   f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
>
> --
> Cheers,
> Stephen Rothwell

Thanks for the report, I thought we got rid of these htmldocs for sock already.
