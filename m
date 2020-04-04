Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9B319E382
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 10:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgDDIh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 04:37:58 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:45590 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgDDIh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 04:37:58 -0400
Received: by mail-ed1-f52.google.com with SMTP id dj7so10356371edb.12
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 01:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NdncJq6TyRNuMWff3n2CGYlgIuwe5C9Z8UuDDdT/jB8=;
        b=Is6eAJ8tn/MI14RCf34hYHeqnBZ/BrE5H/iRE8N0t/xdnGNXP/cxBzxxCXkFy7RYbq
         PwtSMr3j7W0IW0URVHoGlqk8MYqV0sdOuG7Hsfbkpan4K5axdiG6fRifLGCeDySJCYBA
         iWstK4PZX1duTn9YBz8eT/KUO1rSmPJW7Npa8ISEP7geCVHmrHLYxI4t+nOTR4bcSKEF
         GZWZncSj2EMx4DP70ik0kg3ZSjdOpOpfE1bBX4As6SlTPZr9Ab4EPy8sIcVdPP9vm5YK
         1Yl+zCUE3Gd1cCSQPQzxmp7j4ZjMWl0F69aY5MtS/Y6DAlEzNzQ7BkCBtuCNc6yZDW4I
         XOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NdncJq6TyRNuMWff3n2CGYlgIuwe5C9Z8UuDDdT/jB8=;
        b=un39n3POpSQ6f4lCrspJ+oCenA8tQZLqX2RvWhVspKs1KSj8Tncuv9HgoXGIRpmm0n
         ZTdFDkwgG4srIB31qmnXKw4SCOGK9KvHUmT2KDvT13aoN9sDkAn69JWl6ch8nMwHIxbA
         CaXQMO5v+8YK8XLbBkCtxJFZ6nGEP+tOKZOEfMeNL03DBLCnrjEizDr+9oIJBW9Pr8Rj
         SCXRuiaiBMJbyygO45IrwQxg2cmM83tGd1qQB00uMJ0BRDN+aHGZFJTOvJsGttw9XJdN
         LoUInCuJnNPdoZGyHrdwHlBmFWFI4l86LG2m0M/WdvWwdGtHQF4gWnCdQMfNTJZn48Lt
         4CGw==
X-Gm-Message-State: AGi0PuY7q8Yzd+sCPNLS3/4Ns8rfDMMHmSVaJBrzuneE7qTu5VSeUyge
        kI06odc5agqtepeK1lsQ3aBdWKrFNqvsmh8jrCs=
X-Google-Smtp-Source: APiQypK7oTvg443IxlMzdnqUe+iHqhQWXC6wb4tiX4t8AsczKpcChhQ+/7RJzOWskAiDG/4obH5iAI5qLYISNavF8uo=
X-Received: by 2002:a17:906:fc18:: with SMTP id ov24mr11601440ejb.189.1585989475914;
 Sat, 04 Apr 2020 01:37:55 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.21.2004031542220.2694@hadrien> <CA+h21hrP-0Tdpqje-xbPHmh+v+zndsFyxaEfadMwdAHY+9QK+g@mail.gmail.com>
 <7fc8f8d5-285a-9ec0-23c5-c867347c4feb@gmail.com> <4e26a79ed71bd41b3bf2f65e48c4e4c41094fddc.camel@perches.com>
In-Reply-To: <4e26a79ed71bd41b3bf2f65e48c4e4c41094fddc.camel@perches.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 4 Apr 2020 11:37:45 +0300
Message-ID: <CA+h21hqo0U=dnUto=evXi_tavGBmJ++_0iNjikQCuAjoazh-1g@mail.gmail.com>
Subject: Re: question about drivers/net/dsa/sja1105/sja1105_main.c
To:     Joe Perches <joe@perches.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        netdev <netdev@vger.kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 Apr 2020 at 00:12, Joe Perches <joe@perches.com> wrote:
>
> On Fri, 2020-04-03 at 23:02 +0200, Heiner Kallweit wrote:
> > It's right that this is not correct. You can check genphy_read_status_fixed()
> > for how it's done there.
>
> There is no SPEED_UNKNOWN in that function.
>
>

Correct, there isn't.
The bitwise value of the 2 speed bits from MII_BMCR is:
Bits [6,13]:
1 1 = Reserved
1 0 = 1000 Mbps
0 1 = 100 Mbps
0 0 = 10 Mbps
So basically the PHY library assumes that no piece of hardware will
ever set the speed bits to 11, as that would invalidate the spec.

-Vladimir
