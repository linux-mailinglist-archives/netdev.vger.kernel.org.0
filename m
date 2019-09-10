Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B26AF25E
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 22:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfIJUqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 16:46:37 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39936 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfIJUqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 16:46:36 -0400
Received: by mail-ed1-f65.google.com with SMTP id v38so18555892edm.7;
        Tue, 10 Sep 2019 13:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=FHzCSzk/2F4WEi0ssp/MuqreT3AyNbr4d9w+cOv5C0k=;
        b=m5SjcWhY8h3raUlGZ99t3qeAQ2t3krAD/KbeRc7KFZzaT6ZkR6Q4vibZkyxYyZ7wUV
         bOitVTAnQRH3AgZYZLTe9eoHcaBrekaHnP2vBpb0IdghoHaXypKQ5OUs8P1ZCSRKESmC
         LN8Hb0Qc5USujWtlvPA/KyyeKv7sIoHgwmp5sEa0jXHyW//slKNd5jTu2uKxGX09ZQzE
         /i1999i7kZPoNkpyWcm8UBEl6U7LlBQtZfdyP0ukPfxsC7esw9NhuDPb48dsvRfU0Haa
         YmsAuP+lPFhoHzoystGMIeyAfdRDRvyaJbvZNRHjrZi2m0aSrBvW7Vq8coDoptkK11zq
         IElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=FHzCSzk/2F4WEi0ssp/MuqreT3AyNbr4d9w+cOv5C0k=;
        b=lGFJ0odsG7Ht0HXy/PQ8cz9lJj1LLikLPu3AjVrN46/1bAru6wz2BMMfmCM8S0eTzk
         v3uXs1H7TRbBhkUAsZq0WcfggZxB3GIvq406I+H3KAwmSjMYq7BhgfM9tf/OlA5VczDE
         BdW+BKOY7zzQkpMgJV4ruk/XhRnZljM70mO+KiadFFUBnorQ8kE1FhZlVXuyXB+O6sOM
         nFCW2Cd7JUMnvluWLMzgLweuCgg1g729ZMbQXlsMqRImimoYHxHUESkcrPOT0ebmUHKc
         mG+B+tr1nZ1UTWhPGAchIrmT/Dfgg/1jiQWJyTyStxhLZtuyISdcovosSAHXsPJZB/6u
         LQ6A==
X-Gm-Message-State: APjAAAVJxizP+Y5DwpyHNwN5bYo6ycQGgp2OfXbUuM7pBX9por3evIJV
        ZySyJ2bxqAkPPNOTZzCur7cfWbz+RUC4NWQ+rws=
X-Google-Smtp-Source: APXvYqzj9/FbOE2ReaUBgrcXgifimtd8vb9VA9oTV2k7jlzGpqC2PVqmgSgGuJqgcGPNhcGQsCPCX6Z1uHCoVZ5IKa0=
X-Received: by 2002:a17:906:400c:: with SMTP id v12mr26284439ejj.15.1568148394995;
 Tue, 10 Sep 2019 13:46:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:e258:0:0:0:0 with HTTP; Tue, 10 Sep 2019 13:46:34
 -0700 (PDT)
In-Reply-To: <20190910124952.GG32337@t480s.localdomain>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910154238.9155-4-bob.beckett@collabora.com> <23101286-4da2-2a53-e7cd-71ead263bbaa@gmail.com>
 <20190910124952.GG32337@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 10 Sep 2019 21:46:34 +0100
Message-ID: <CA+h21hpS9YYDwv0JzmA5BBSanV+w2jvyZdtFqYt=GL+hEc=ufA@mail.gmail.com>
Subject: Re: [PATCH 3/7] dt-bindings: mv88e6xxx: add ability to set default
 queue priorities per port
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Robert Beckett <bob.beckett@collabora.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi guys,

On 10/09/2019, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> Hi Robert,
>
> On Tue, 10 Sep 2019 09:42:24 -0700, Florian Fainelli <f.fainelli@gmail.com>
> wrote:
>> This is a vendor specific driver/property,
>> marvell,default-queue-priority (which be cheapskate on words) would be
>> more readable. But still, I have some more fundamental issues with the
>> general approach, see my response in the cover letter.
>
> As Florian said, the DT is unlikely to welcome vendor specific nodes for
> configuration which may be generic through standard network userspace
> tools.
>
>
> Thanks,
>
> 	Vivien
>

While I do agree that the DT bindings are a big no-no for QoS
settings, the topic is interesting.
What is the user space knob for configuring port-default priority (say
RX queue)?
Something like this maybe? (a very forced "matchall" with rxnfc)
ethtool --config-nfc eth0 flow-type ether src 00:00:00:00:00:00 m
00:00:00:00:00:00 action 5

Regards,
-Vladimir
