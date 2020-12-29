Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104492E6ED2
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 08:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgL2H5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 02:57:32 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:37778 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgL2H5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 02:57:32 -0500
Received: by mail-oi1-f169.google.com with SMTP id l207so13915823oib.4;
        Mon, 28 Dec 2020 23:57:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oMPZ3DxBbc0lAKaQmoEELbbnrNIMTsZVrRlvJMn6IWU=;
        b=QypvsQM46keFFzHTb3Am10PMu6FIUqJq37tOwghHez8DGUkzN+6xRoT9KZ3AiPe/Qz
         q/iWKCwjsAkogdOYQ7jRzGT9HcMulN8HuKvKe4cw1Uu1LYm3kbbzoZR/YFmf77o6p79E
         i8gW8xtgzxe+b7kaBZPdyCG/9CEfxImkQB12ZpT8jQDGU2EHw5s85xTZODGqKdM6QwjD
         uyg+zNsU9pTZeOejqwXyIbgM53v6y4KXroQDdAXIH7c8BXG55ZB0A73n51GvgE7oRl0B
         ZglMVAyBPgZ6Kxb/2KRHo5cVaXbHWcD2X0NHgkcRssQsBHCrS7/X9nYcu1/XDkynwVYr
         DJ+g==
X-Gm-Message-State: AOAM530Hl7PL9R/lb6wqGvBNCYitQazKJmu7qVjOV927GEHsM7hL3aEK
        2+jJHksPUcQX2BkqoD3dV2nefp8tymPSM+2t0lSSoo0qblw=
X-Google-Smtp-Source: ABdhPJzNGJGEy8ppBWe2WqSc3W7SOXJx6+xS6SXmAHxzBe05sOkLQa/LD4DLp3aPjhQ9PxWEVWOIpV4tJZb/H0u7BW8=
X-Received: by 2002:a05:6808:199:: with SMTP id w25mr1625378oic.151.1609228611780;
 Mon, 28 Dec 2020 23:56:51 -0800 (PST)
MIME-Version: 1.0
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201224032116.2453938-1-roland@kernel.org> <X+RJEI+1AR5E0z3z@kroah.com> <20201228133036.3a2e9fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228133036.3a2e9fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roland Dreier <roland@kernel.org>
Date:   Mon, 28 Dec 2020 23:56:35 -0800
Message-ID: <CAG4TOxNM8du=xadLeVwNU5Zq=MW7Kj74-1d9ThZ0q2OrXHE5qQ@mail.gmail.com>
Subject: Re: [PATCH] CDC-NCM: remove "connected" log message
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Oliver Neukum <oliver@neukum.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Applied to net and queued for LTS, thanks!

Thanks - is Oliver's series of 3 patches that get rid of the other
half of the log spam also on the way upstream?

 - R.
