Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11F42BB93A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgKTWkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728587AbgKTWkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:46 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C02C0613CF;
        Fri, 20 Nov 2020 14:40:46 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id s2so5610206plr.9;
        Fri, 20 Nov 2020 14:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sgtncp9FPigEcaXHQf1sv5gXWmKILLQAAH0peI9rJmI=;
        b=FtS4PJN799vGwsAvEZlBzBju3wKNl5Aie1A6KJxxdG25b9oLyJmUJ+HrU27trZ21SZ
         IPWoSBuyc7eriH1qab2mi+wSGdgPx+LrBeZCx2nWYTTh+hEQNZG9WalPDVSNVFFzf0vJ
         bI/guDxtU0fm3bkpRp1kjosaHz9+QD6drgLgUJRTqJeiw5sAcjkqIcvUaKspH90TKma3
         13XHbS7mfz3VXT/7pE/Fbh8Qq3XX/qVrdOboHE8YXELAL+Mil6CopOoijKJo+QwhSGrA
         mjEMFAv8Es1s8CCTjtIjZyjRBwn4cOvvKJHJZwOeLf5xJ1wQQhLYV5SW654u5idEHdJh
         JJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sgtncp9FPigEcaXHQf1sv5gXWmKILLQAAH0peI9rJmI=;
        b=Alng70yKX9iZEX4Sw9rrX/yMICz9nI1bljQGX3PH6tOSK5V/obHZySfnZuzNtI5Opw
         dXjLM/9PqL2jiP/+JmPAEGBMTt9fWzbH83U2x62h5qzZtaPUYJdtLfRFmt8LE3iZmvtx
         A1Vzy60fyuAIorsyC4VsuR/8zLLQTdpOgx49IVxHq+GpUxeR11W4/uouuJ7t9k9UwcXB
         oyUen4vsacWVVnMIUxine7Z905qh3icvwFU/kLLEMUmrILxCRE19AwyrMAsbQuqE8Fb6
         Oif+BtmSjRYWRNpFjhAusOyb+R5LfmITmSxSR9mI7XA/dBpUah5DRbBCLA0ldqfRt8wf
         bgzw==
X-Gm-Message-State: AOAM532/IXkQ8qulXjTFk8moJ4bYkj7gQhvZGdV9OwPz0bAIyg5LGi9i
        bWEo/Z0zWUK1s1SPodg51zoTXXqOoD8L/ENKoOE/1oyK
X-Google-Smtp-Source: ABdhPJxZz7ZAu71SQikBNC9bSlsXs6oaqTNYe6me8SKr3cUgLpsBVNvEhVCQ8vxXMzmoqTjMTUIvRxaUBp6CXoxetno=
X-Received: by 2002:a17:902:aa4b:b029:d8:f87e:1f3c with SMTP id
 c11-20020a170902aa4bb02900d8f87e1f3cmr15106133plr.23.1605912045872; Fri, 20
 Nov 2020 14:40:45 -0800 (PST)
MIME-Version: 1.0
References: <20201120054036.15199-1-ms@dev.tdt.de>
In-Reply-To: <20201120054036.15199-1-ms@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 20 Nov 2020 14:40:35 -0800
Message-ID: <CAJht_EN0vTTzmd3WRLY96M0OO3V8a=Y987pWDu+O-fXQHRQYLg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/5] net/x25: netdev event handling
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

On Thu, Nov 19, 2020 at 9:40 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> Changes to v3:
> o another complete rework of the patch-set to split event handling
>   for layer2 (LAPB) and layer3 (X.25)

Thanks for your work!!
