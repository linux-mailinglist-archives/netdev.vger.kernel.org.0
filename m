Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BFA19C676
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 17:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389621AbgDBPwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 11:52:36 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36036 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389573AbgDBPwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 11:52:35 -0400
Received: by mail-ed1-f66.google.com with SMTP id i7so4839817edq.3
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 08:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mvuCHuhbBzMcGG0ZLHrAh/9qewolRGbNx9EmUWYK4zw=;
        b=P2J3m3cf79/yXomk+CYy0qOG9lg2Qv/NTqDxEGL2XTsf3jh6nmhWz5jYM5shiyca7o
         Xp3KBI2jP6RbeMS9kjdo/ZnM8brtQI9eCRduyK9z5/VA7TQzLprLQrN2Etkrsl0chmjG
         XnEYra4bC2vPGa1V2fSXZq5qL7p24WR/Ugn0d91yZ7TY9VYYPRAZX4EAsQF9uklqJA2d
         69w3ysf3bnMKcOO0qRD6CdzABj1kUNR4Lqa4WHzwVDzOLGs9pUP8znWjnnG78YHtqYIX
         xBs2bJ9wB2iwuiJAd+WXEcOSNsaFP2IWloszKSZeZdWdpXYUfOtXFwzc314tM557o9P/
         KukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvuCHuhbBzMcGG0ZLHrAh/9qewolRGbNx9EmUWYK4zw=;
        b=ZNXnHZi2t9DPN+bmyD//vrT8hkHrsWpcob30aVNGUqCJ5idta4XaupYNk4r5LMPhay
         6aV3/Y+y+An2m/n5m6y9Ky1jy3tDR0m4Iitxfuk5KmbvWsMGKrBaJ8EGYWIqRK0ldoGO
         Wv7IQJqfg5ny2VI/Hn+LgtUm9K47vEfN9p2rK+x2JKJ+KCGDf3z83CPhK4JwpnLSTKaZ
         rxs9Pw4u/ZY2W9mWgCB7x56Z2m/fpJwj8/j2NZR1ManR634vJS+Bb3uqjiKwxNUhnbIW
         KZrgVuvw0uVBzWqxBvJy8GQGCvia0KbUDLD4oJMQiWjq2bDhxUuWs4J+N867mU8YLRNV
         4N1g==
X-Gm-Message-State: AGi0PuYFIFVE79Sb3tW9+7XfZOAbg4a7TkRUPwU5DSQzb3f+s5eyOytH
        Wo3xJS7+mFOcQwUleRK34jGntqOT6ZCyS3kCGaefeFnmZdT+fw==
X-Google-Smtp-Source: APiQypJHc3ginXPPR75E0f+23+eIpfIkE4XkvemgCf61OaXu2X6ELg001VuCCaFmr94048PG1GWWmZ7us7vElcOx+dk=
X-Received: by 2002:a17:906:e99:: with SMTP id p25mr4103108ejf.6.1585842753921;
 Thu, 02 Apr 2020 08:52:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200402102819.8334-1-olteanv@gmail.com> <20200402114710.GD1775094@t480s.localdomain>
In-Reply-To: <20200402114710.GD1775094@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 2 Apr 2020 18:52:22 +0300
Message-ID: <CA+h21hqJo=ss21Xu+Yj=gTtdK7JCBeLvtLg8myjkgB0gwa8o-Q@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: dsa_bridge_mtu_normalization() can be static
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Apr 2020 at 18:47, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> On Thu,  2 Apr 2020 13:28:19 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > From: kbuild test robot <lkp@intel.com>
> >
> > This function is not called from any other C file.
> >
> > Fixes: bff33f7e2ae2 ("net: dsa: implement auto-normalization of MTU for bridge hardware datapath")
> > Signed-off-by: kbuild test robot <lkp@intel.com>
>
> Did you mean Reported-by? I don't think kbuild test robot signed that.
>

Yes it did?
https://patchwork.ozlabs.org/patch/1265415/
But the sha1sum of the commit is wrong.

> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Jason sent a patch already.

Yes, I saw too late.
But it looks like even Jason was too late, David already picked up the
kbuild robot's RFC. I wasn't sure he was going to do that since it was
an RFC.

>
> Thanks,
> Vivien

-Vladimir
