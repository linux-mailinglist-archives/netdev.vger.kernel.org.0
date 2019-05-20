Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F54924221
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 22:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfETUda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 16:33:30 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:45553 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfETUd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 16:33:29 -0400
Received: by mail-ed1-f47.google.com with SMTP id g57so25681969edc.12
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 13:33:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oH/OAPGneOjFkSFoA6b4zFTSOdrRNuJCmbxs0xxippE=;
        b=LcD3NTIYn+uRPnQlfcSO9puAdMIuGHgVKE1G0sREpwN2lIuoa/Pp1XDwaDPWsZTwKD
         zk6hSeysZFcozJ6MRMk/iGdYl5vxj8dnCaihGLbGo3l6XDq22NmgpWdWJMVSH3L2wgJg
         QgJI+p51Vj3uXQZsDlapE3JZ2LdefUl2oYumXolHrM9wORGMVdWFT1hJa8L7SGIoVu6B
         fvSkne+eLz7Wgmln6EzyIFkgdUmcJVHZCBjk03f2HB84rfHY4tlSjDwz8mNC/YRJEN97
         07kTmdQvSuXhCgNFazuxpsA6F+TwGUfI4qIcynp39BEFM7N6PsWHYu3rrYT14QBYvdPq
         tuYA==
X-Gm-Message-State: APjAAAX25HX8uYI0ada9JnnaZ+3fakj3ZZiRQX/S2CgrOZknT5jPRxYc
        IzW+hJYvyvdiTQs8csYA/F2a2A==
X-Google-Smtp-Source: APXvYqxM4m/nVtR5we5DLB0A2WVfvJ7tGr0yEEbHcw8aNKwAqzu8rbJqP8DjvMLjgeK/t52GnLoJQg==
X-Received: by 2002:a17:906:6d3:: with SMTP id v19mr24764800ejb.46.1558384408257;
        Mon, 20 May 2019 13:33:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id y21sm5753745eds.31.2019.05.20.13.33.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 13:33:27 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 95757180385; Mon, 20 May 2019 22:33:26 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "M. Buecher" <maddes+kernel@maddes.net>, netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Matthias May <matthias.may@neratec.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: IP-Aliasing for IPv6?
In-Reply-To: <d10e40ae062903f15e84c7e3890a0b40@maddes.net>
References: <5c3590c1568251d0f92b61138b7a7f10@maddes.net> <20190515092618.GI22349@unicorn.suse.cz> <d10e40ae062903f15e84c7e3890a0b40@maddes.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 20 May 2019 22:33:26 +0200
Message-ID: <87pnocvpbd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"M. Buecher" <maddes+kernel@maddes.net> writes:

> On 2019-05-15 11:26, Michal Kubecek wrote:
>> On Tue, May 14, 2019 at 08:49:12PM +0200, M. Buecher wrote:
>>> According to the documentation [1] "IP-Aliasing" is an obsolete way to
>>> manage multiple IP[v4]-addresses/masks on an interface.
>>> For having multiple IP[v4]-addresses on an interface this is 
>>> absolutely
>>> true.
>>> 
>>> For me "IP-Aliasing" is still a valid, good and easy way to "group" ip
>>> addresses to run multiple instances of the same service with different 
>>> IPs
>>> via virtual interfaces on a single physical NIC.
>>> 
>>> Short story:
>>> I recently added IPv6 to my LAN setup and recognized that IP-Aliasing 
>>> is not
>>> support by the kernel.
>>> Could IP-Aliasing support for IPv6 be added to the kernel?
>> 
>> You should probably better explain what is the feature you are using
>> with IPv4 but you are missing for IPv6. The actual IP aliasing has been
>> removed in kernel 2.2, i.e. 20 years ago. Since then, there is no IP
>> aliasing even for IPv4. What exactly works for IPv4 but does not for
>> IPv6?
>
> Used feature is the label option of `ip`, which works for IPv4, but not 
> with IPv6.
>
> Goal: Use virtual interfaces to run separate instances of a service on 
> different IP addresses on the same machine.
> For example with dnsmasq I use `-interface ens192` for the normal main 
> instance, while using `-interface ens192:0` and `-interfaces ens192:1` 
> for special instances only assigned to specific machines via their MAC 
> addresses.

You would generally instruct your daemon to listen to an address rather
than an interface. For dnsmasq you can do this with the --listen-address
option instead of the --interface option, AFAIK.

-Toke
