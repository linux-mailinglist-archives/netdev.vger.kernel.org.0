Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDAB176F0E
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfGZQ3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:29:30 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43022 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbfGZQ33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 12:29:29 -0400
Received: by mail-lj1-f196.google.com with SMTP id y17so27479458ljk.10;
        Fri, 26 Jul 2019 09:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=+CW43oDjjf97uXnO1yFBC+kyjGo7bEowuJ7murd1juw=;
        b=etENTVA7DjvU2AiUuoCuuykKkMYl2+TSQPOT5X3qJ2eZJFHwPPg0VsEjVW85mww7Vo
         8dweWbEnm97EKHJbmAQyycY83tIVmIr0uF2b+bZ4SgIPfeygo9kYob5bayq+fMf0MN18
         u7ZTEVCKjZqtWYRhM5yH7hMftMbRB6JSJ+BRLgic48AlReU1gHBV2OsRoaea77ad41PE
         hQYBMynd8gncuWog2CXD09tp6FhhWDsOpCK7ILsUcTt684Bzasil8XiGIosjpGPSyqFJ
         0uNfzXDT8PERLi0DHPN1eiLJVYUczXEAWKqt3EKJ4WmO1PKPVqeVLmn7S8qObocWoBjB
         JJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=+CW43oDjjf97uXnO1yFBC+kyjGo7bEowuJ7murd1juw=;
        b=TQ910LPL/i8H/qYSAkk3A/63uNBZnINnGozZge/w/+hm/90rJPC1+J/9lzr1lIttBh
         opzZolmvFbiYv2FpWRymai/mG+VJwPiPv9l99WkwLEHq7znSLx0b/Wkn7kp35XPD7NcD
         c0eXN16SScPf5jzLAS2Lc6uZNNPhqIqIu3DuU1Ywi0N9PervHkN/pgnC0A+nbrD0k5Jh
         DwWai+w0s/F/oyqM1Yhrr1u4fbcXnN1UihKY22WbryQyGn0NA0BoHbesNAsKvhKmB+Zb
         /V9V/u61z8m4XPlYRjh9b5B5C29c4Bo1JlP+h/hLAgEFoDOq5Ol4OTQuOo/4CP83rLEe
         ZEkw==
X-Gm-Message-State: APjAAAXLXXhLCUvohe4iTCmLSR9UrywJfE4F5AZfvmU/3lltqaOk60kX
        qtEJ4HGuWk7r5TlpzToSJMuyYfWlEHZ9bU3JLT8=
X-Google-Smtp-Source: APXvYqyduOFi8NImu0AzMAEfao7/6RCtL069JVxtRYJcG7ZxY2sDnpNyZhwel7yXqUTnvDofI8d+F0LuvM32vbsAM7s=
X-Received: by 2002:a2e:5b5b:: with SMTP id p88mr14059332ljb.192.1564158567371;
 Fri, 26 Jul 2019 09:29:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:94c:0:0:0:0:0 with HTTP; Fri, 26 Jul 2019 09:29:26 -0700 (PDT)
In-Reply-To: <20190726100614.6924-1-colin.king@canonical.com>
References: <20190726100614.6924-1-colin.king@canonical.com>
From:   Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date:   Fri, 26 Jul 2019 20:29:26 +0400
Message-ID: <CA++WF2PS_3X-fs7nKuxipizXE3QAPYXbYk=AV9waxDEc9JVJNg@mail.gmail.com>
Subject: Re: [PATCH] ipw2x00: remove redundant assignment to err
To:     Colin King <colin.king@canonical.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/07/2019, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Variable err is initialized to a value that is never read and it
> is re-assigned later.  The initialization is redundant and can
> be removed.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks fine, thanks!

Stanislav.
