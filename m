Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF10421D09
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 05:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhJEDth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 23:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhJEDth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 23:49:37 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2040BC061745;
        Mon,  4 Oct 2021 20:47:47 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id 188so22222539vsv.0;
        Mon, 04 Oct 2021 20:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UDsljUijqnZ5Wx+bun2KCPdz3eZ9B9kNij17UG2PwQI=;
        b=O0fHoYqc6PSsqeZJWcPeKmzbT7zjxQ1uas7QyrV3q1wM90ZuYW3mq8hTMZ0vOx1/qf
         59/4hZaUpJQTRjsj0YNr6+aenjmxSBguQF4SoWsBaDQt0CS0VMxblFKZSHa9NRZRwUMb
         UsEveLiaC0OSttPne5WeJSHFGqyF5z0KAdkfQzqOsXISf4RBT6kJUy5r+on6mHwGf+K+
         BnIvdLlTKDqbx4F/sx/yt7sKpH+MJzkKx9phPctyep4SWZosILeemYprdkCehjCb+AM8
         ucXIl+8mseOJ6Pm+iz1eWB5AUl8P5GuYlBDh3DVEChFT9vJpyjFv+882i2tU+B4lWS7p
         IjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UDsljUijqnZ5Wx+bun2KCPdz3eZ9B9kNij17UG2PwQI=;
        b=xb6aS5zIc/Hz6JU8u+sSO1wqsg45+OAn7IJcq/pJRSpgt50BKosyZH1NJ0Ynm1oA90
         nY7nchbrjb7QNFoRZ7wDyWF0hm+ogEttjEMRwguzBcFalaJCWkWDq0hk5AFsOVC1QlGz
         I51lsTJe5aBcZGk28wzfk0Q3ywKdaYbuQKrtphV04Sm8eMdjI6e3N5b0Nu/k3Q0OtwWH
         yIFae0MhF8QDZNb6r4mu+EJML0YVQFn7Hpfk7jCUFSkkCwTK1wHrfLUKz+vWOa75b+eC
         m1aoRSaUpOxndzjS5IS/0OU1adHTBbBS0bceAzkMafml4HdPexDi5SdbXcUEkDvw0va3
         ZJfw==
X-Gm-Message-State: AOAM531wz2tfDuNWV/L26h97PNCsRIwf6UyT0r6vH3oklp0XoYSyKXDU
        xxL2wTD0vnYxzsOxhveFnf1HOAGylJmyGBoqCWIMEEFq
X-Google-Smtp-Source: ABdhPJzKSLKE/L/ExSnE+Xjn7b/Jpy2TNylzklhwSdCgHM8cexlM4/LvcunGLjLBFzqv6sCzlJAU8dFthMp26atztfA=
X-Received: by 2002:a05:6102:318d:: with SMTP id c13mr17169978vsh.10.1633405666008;
 Mon, 04 Oct 2021 20:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211004222146.251892-1-luiz.dentz@gmail.com> <20211004182158.10df611b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211004182158.10df611b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 4 Oct 2021 20:47:35 -0700
Message-ID: <CABBYNZKJaD01+o8Tuh7AX7=3Hct_6YqzQcWWzDvOcRpRdPOizQ@mail.gmail.com>
Subject: Re: pull request: bluetooth 2021-10-04
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Oct 4, 2021 at 6:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  4 Oct 2021 15:21:46 -0700 Luiz Augusto von Dentz wrote:
> > bluetooth-next pull request for net-next:
> >
> >  - Add support for MediaTek MT7922 and MT7921
> >  - Add support for TP-Link UB500
> >  - Enable support for AOSP extention in Qualcomm WCN399x and Realtek
> >    8822C/8852A.
> >  - Add initial support for link quality and audio/codec offload.
> >  - Rework of sockets sendmsg to avoid locking issues.
> >  - Add vhci suspend/resume emulation.
>
> Now it's flipped, it's complaining about Luiz being the committer
> but there's only a sign off from Marcel :(

I did have both sign-off, or are you saying Ive now become the
committer of other patches as well? Which means whoever rebases the
tree has to sign-off the entire set as well, I guess other trees does
better with this because they don't have multiple committer but once
you have that it is kind hard to maintain this rule of committer must
sign-off, shouldn't we actually just check if there is one sign-off by
one of the maintainers that shall be considered acceptable? Or perhaps
there is some documentation on the matter?

-- 
Luiz Augusto von Dentz
