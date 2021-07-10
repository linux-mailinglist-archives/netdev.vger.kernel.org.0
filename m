Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9026F3C32EE
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 07:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhGJFFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 01:05:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhGJFFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 01:05:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88851613E6;
        Sat, 10 Jul 2021 05:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625893383;
        bh=iYSchZmAc/97hywuhc0uv/csuJSDFBMm/mbu5MwOqdo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PKje/gftA3ophK4pa8QSFmR5FJGuH3xfEDUJ5JJZP+JVWABTbgJpz7iVH8c4F3Msc
         xhX9SL9gFuXUUB3E7Co3+wrTkwo/i7uYQzyvA21iBkqIDewUxMq1xN7mk+dVQDLCYs
         88i+60iOKxhiUCr0VSJiYSbK+dPePdj+nm0A7wAhfeX3akJ1aQrEA3JERcRtbkAMWQ
         EgzcUL0UI7yk2av6N+UnE3Wd6axeaQurBmQbR1oGmakkEU1lYCjhLJe9/LAEGvbUBr
         8VugYJN+Li5MJ9tWHKIfqm00vz+lkg3nVLLt7NTzDMPiuJWGvN97zEQhSCGDrzyUn2
         6S3o4CGQFFZTQ==
Received: by mail-pj1-f50.google.com with SMTP id n11so6884426pjo.1;
        Fri, 09 Jul 2021 22:03:03 -0700 (PDT)
X-Gm-Message-State: AOAM531RWlq2eK5/96o/oLt1Nw06PISYixce3LRQWPPWhHDMw8Dcc/g5
        nVc595hMp4n/cQusQ1KW5jkOKDA887+hIa5gbas=
X-Google-Smtp-Source: ABdhPJxtOVxq9nUoVnwK/0Rv8R+Z7QcUAOmRu+oT0PKSSYg0TQqnI18zMS6tgOgnb79OjemeIhP/4RI39U/nyNkPKnI=
X-Received: by 2002:a17:90a:9411:: with SMTP id r17mr41449680pjo.49.1625893383288;
 Fri, 09 Jul 2021 22:03:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210709142418.453-1-paskripkin@gmail.com>
In-Reply-To: <20210709142418.453-1-paskripkin@gmail.com>
From:   Timur Tabi <timur@kernel.org>
Date:   Sat, 10 Jul 2021 00:02:26 -0500
X-Gmail-Original-Message-ID: <CAOZdJXWm4=UHw42YjUAQLZTNd=qbxyRag7-MJ5V4aq_xf8-1Vw@mail.gmail.com>
Message-ID: <CAOZdJXWm4=UHw42YjUAQLZTNd=qbxyRag7-MJ5V4aq_xf8-1Vw@mail.gmail.com>
Subject: Re: [PATCH] net: qcom/emac: fix UAF in emac_remove
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     timur@kernel.org, David Miller <davem@davemloft.net>,
        kuba@kernel.org, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 9, 2021 at 9:24 AM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> adpt is netdev private data and it cannot be
> used after free_netdev() call. Using adpt after free_netdev()
> can cause UAF bug. Fix it by moving free_netdev() at the end of the
> function.

Please spell out what "UAF" means, thanks.  If you fix that, then

Acked-by: Timur Tabi <timur@kernel.org>

Thanks.
