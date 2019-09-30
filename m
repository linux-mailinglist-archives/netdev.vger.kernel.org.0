Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48165C1B24
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 07:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfI3Fvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 01:51:37 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45385 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfI3Fvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 01:51:37 -0400
Received: by mail-qk1-f194.google.com with SMTP id z67so6705835qkb.12
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 22:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=29/RGaCsqpRpLez91U4QTD/pfk2SBpNVpqNGNmRaLJY=;
        b=UZDzgxT9uwLsGof3tyuRhKum7x/NK4Ei0w/zIbbQVWo0L2/wvtr2ly8pszlnYZ4CdF
         un9Zo8/5g0JHpse9qvvkGc5Oo+7HIjONiLkxSKfwmB5BCY4hv5bMtMO86jbqBYLnPtBs
         ZPaPRjBgmlffIRsiTephuOPelf5eKpb1ZR/RaifkL8toBF+qMgTwIYC9V0ykeT83n4hE
         6oEdW0ephCxNJyeICY+SkYSjLjvPpf4d3lshz+VGnA5Xx4eIAddleL4EshmDr8BDL9bg
         rz/luetWFXsaUDxIHi6hT7e4/ZxrTHoazoNUjatQsSrHXfm4Jzvh0v0wdp86z3OEfyCp
         9mTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29/RGaCsqpRpLez91U4QTD/pfk2SBpNVpqNGNmRaLJY=;
        b=lSlD6JUmCYM+zClIEorne/b33/GnHOXSTf9KIz+RgUUQc1fJ3ueae1iMvsfNDEj0aO
         jtlY6SMPJwgpleukmADKtZ3MMoEYwZsEsdd1vMTPqAriez5RjDhW6uvNUia2N0vkhItg
         RoyIF7yMB4w77AYrHYc5ul5bN0A+kYZxnil71qT864/SsXHGc2ns/h/te2lKHATCur9+
         pj20oTOFK6oAF1K7EuQtVuAwCcar8LJSFijMJr7NSIhOeDS3TzCEE3t70Sgb+y5UOatu
         1oXSIhsUdi2wyftjSHJ5/jbvbMiLS7iJF8tBloAy1joLJmu318ZGZiPLZVmyu+Cm7q08
         +TYg==
X-Gm-Message-State: APjAAAXyHshhiJq8ciQoDm5sZujrb384dehw7fcJv5wkhR43cmoZH7BK
        RNrBSls+lkO3mS7T6SOqzYH3NBF1JDEEdPNVICcBm4aHdGo=
X-Google-Smtp-Source: APXvYqyeS1BZLA392odikR7RXCI0Pv2e0XcfGrl2i2jEHdiGb6P9PQuaRYL5jnq7HNzlWzlbXs5vkZ8Hrnx9DNyvM88=
X-Received: by 2002:a37:424d:: with SMTP id p74mr16332373qka.118.1569822696256;
 Sun, 29 Sep 2019 22:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAGAf8LzeyrMSHCYMxn1FNtMQVyhhLYbJaczhe2AMj+7T_nBt7Q@mail.gmail.com>
 <20190923191713.GB28770@lunn.ch> <CAGAf8LyQpi_R-A2Zx72bJhSBqnFo-r=KCnfVCTD9N8cNNtbhrQ@mail.gmail.com>
 <20190926133810.GD20927@lunn.ch> <CAGAf8LxAbDK7AUueCv-2kcEG8NZApNjQ+WQ1XO89+5C-SLAbPw@mail.gmail.com>
 <20190928152022.GE25474@lunn.ch> <CAGAf8LzJ56wjWxywnGWB1aOFm9B8xQhMgHFQfkVgOFWePzDfsw@mail.gmail.com>
 <20190930014440.GC6032@lunn.ch>
In-Reply-To: <20190930014440.GC6032@lunn.ch>
From:   Zoran Stojsavljevic <zoran.stojsavljevic@gmail.com>
Date:   Mon, 30 Sep 2019 07:51:25 +0200
Message-ID: <CAGAf8LyaneLN0zA9x0HYczTw6f49CiewTg8TJf+eMKdDATpWLg@mail.gmail.com>
Subject: Re: DSA driver kernel extension for dsa mv88e6190 switch
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The very last line is wrong.
> ifconfig eth0 192.168.1.4 up

Typo. It was fixed after few hours I created the gist.

> You should put the IP address on the bridge, not the master
> device eth0.
> ip addr add 192.168.1.4/24 dev br0

Noted. Thank you.

> FYI: ifconfig has been deprecated for maybe a decade?

I am an old dog, and old dogs could not be tough to new tricks. ;-)

This is why I always install on Debian additional net-tools package.

I guess, time to move to modern ip command.
_______

Please, please, keep me in the loop about DSA patches.

Many many thanks for advises/emails,
Zoran
_______


On Mon, Sep 30, 2019 at 3:44 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > I wrote my (very first) public GIST about that. Please, could you
> > review it, and point to the any logical bugs in there?
> > https://gist.github.com/ZoranStojsavljevic/423b96e2ca3bd581f7ce417cb410c465
>
> The very last line is wrong.
>
> ifconfig eth0 192.168.1.4 up
>
> You should put the IP address on the bridge, not the master device
> eth0.
>
> ip addr add 192.168.1.4/24 dev br0
>
> FYI: ifconfig has been deprecated for maybe a decade?
>
>    Andrew
