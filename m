Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2D439F111
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhFHIjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHIjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:39:51 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE63C061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 01:37:59 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u7so10255139plq.4
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 01:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oIri9kCofOoOLXZOxF6K2aAvR+DCRNO/EjptNrjwmC0=;
        b=xJQgFOW5VPPAQ1Dimyfflz+oVklcBFyTFZpUjTGxB1uUP/BioLERjmCj2Xu0//V0wW
         QpZgBi4sViwCQzcIx8IgY2JeLnWkFYgObwd4ZAykrErWjlUTec+3uh81/fl9DxBpB6Sw
         +1aOzhQFvAXbIVf+CewoJvhNiooCn5IJeA7Ep1XoxQHcPPPCYYz5meHlpZ7KdN+1NHrf
         g1mwLfurSZPaJ9d5rHwhmOwDSEr08D/oDzccsq1iiXPcXxVLjZMUOp4GttK1PKUywAg2
         YodIl8lw28caKUmm1PxHlRyvjOE8vXsohbdzuA3UUfA6DMAD65b4ZyHMdYU3KuhQ2bqK
         NwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oIri9kCofOoOLXZOxF6K2aAvR+DCRNO/EjptNrjwmC0=;
        b=QQ0RZ/d4uQ6Er+5fCczUjrhH+1CeHmiGAQIpuci5q4cP54BQQOeDiRTVNsWOLeroXb
         iHoIOx8jk136NAh1rXoQa1gflbRcJOWry51mRJuYK/bPfpZcvdhIaEiKZOBVzkn212Td
         jitXRdaGNSRdcSEVeBEjAVkbAeXyCva8RHxpnr5ApqlG2gHiqdWUBbgsCCYMAp3Am1fD
         78PUyH2AX4fkQai2UmYi2rGAVf4P5bzZnfKYF52PhBaPyLBndlCoxAnapQV1isu2mZIh
         8bt1NoJHfZPtlsoFTyA3PNd1P2IO7XM3P+/KIvnpImAkaM8eg81tYDIsFh0LoBqHzSAX
         makg==
X-Gm-Message-State: AOAM530FSUd2mA5UTq1hGdiw/N9eTO8bV2GM6QD4XCXuhCwX+5zcn6yK
        sf2z6v5FpAirLG6hrg/j+t10Tf7Ncce8t1y8NGRuyw==
X-Google-Smtp-Source: ABdhPJz+BSmdoRZ3oG1wx09tz9CAHaCiLiyjr+/x+s51kbbz40d2iS/z3BgzWTIAcD3GHGSLqCEF5eYE2JE87LU2kZk=
X-Received: by 2002:a17:902:d64e:b029:ef:8b85:d299 with SMTP id
 y14-20020a170902d64eb02900ef8b85d299mr21818436plh.27.1623141469979; Tue, 08
 Jun 2021 01:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com> <20210608040241.10658-8-ryazanov.s.a@gmail.com>
In-Reply-To: <20210608040241.10658-8-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 8 Jun 2021 10:47:01 +0200
Message-ID: <CAMZdPi8OoAz-Tr4qXugBPNRhAUt3=co-qMouYvsKdyH8r8KS5w@mail.gmail.com>
Subject: Re: [PATCH 07/10] net: wwan: core: expand ports number limit
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Jun 2021 at 06:02, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> Currently, we limit the total ports number to 256. It is quite common
> for PBX or SMS gateway to be equipped with a lot of modems. In now days,
> a modem could have 2-4 control ports or even more, what only accelerates
> the ports exhausing rate.
>
> To avoid facing the port number limitation issue reports, increase the
> limit up the maximum number of minors (i.e. up to 1 << MINORBITS).
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
