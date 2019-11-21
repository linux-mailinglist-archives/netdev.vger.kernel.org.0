Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83FBC105082
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKUK37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:29:59 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38722 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUK36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:29:58 -0500
Received: by mail-ed1-f66.google.com with SMTP id s10so2331948edi.5
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SyZ0ktYTKUsMzGS0S9FShiICrSz+wQ1+bOIkCjZ/UJA=;
        b=EbUzyDiADzI4bnWcZPsFFrTU5B+11vhFMhIb0oh3vSL9TFTgV+Z5dB8blnAteytoDG
         WXeyDwYCVC/NWeoeWhoQaUjPzPDn7hTeB/flc2uh3C58YynYnwHdvcLBEbX0lRBk46YL
         QN0lfRZAin9Xj/7TB975IHwyBEz+CTWoSqufIFtBO1JSuYr/vqoJhufC27YF/j7/Q82E
         AfYEYnSzv/OGJTsTCzFZOqxsrDkkLjchWqLraIbWOKmL/vN1fiSSgVxhDYmxb66oUfRg
         xXF6dLkdti3Nv10Yr/htgGPPnSLVma8yFdS5EpCw0xQiv7ygI3amX22/lW5N7Uu+2HLb
         Wduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SyZ0ktYTKUsMzGS0S9FShiICrSz+wQ1+bOIkCjZ/UJA=;
        b=nAfMd4Kl6Tj1ZIbXsou6x3KwTxmGCmiBJ5Kfa/BmSWPAsf88LR169nB8fwDJv9Vq+0
         mzhEvQthYBlTL6g06Zg2ggDCokeisOTG5wQJByi/KYFusBzQyjBT43pc9ip+orwEPuN+
         kUHJwXRE4kwmogEeqWny9SfB5W8HbKn0oU5SEBGhSMcRyfdzK3CjS9t4s1mh/HNw2zPH
         l2qHa5nFx16sffRcQn6Sas4aqFAfTRIe1QRsCzJ/IN7Sskcv/ddGu0B5hcpW4m7fNRVL
         x3t0fmj+tFzdSMEniIogsOPjCSJkX7IS60L2QH5yB+o/hn7eXUqqacuX4gTHvYOpNEAL
         8ogA==
X-Gm-Message-State: APjAAAWo510p4eZtfSUHm/PavFMvi3h2MAwwqAWXg6AkCPyQZMTKRRl/
        khEpu1uUCcz2dO7BxdRkD0/iVSm8yoITzox3yQI=
X-Google-Smtp-Source: APXvYqzLYEQsg+2dWY097gnTx8UARjiFg4EgFieaLgGig6n4bx0eOkvAawAx+mmTQ2xEbwdu/bbblAUsfQqLb03TlXU=
X-Received: by 2002:a17:906:70e:: with SMTP id y14mr12814950ejb.70.1574332195468;
 Thu, 21 Nov 2019 02:29:55 -0800 (PST)
MIME-Version: 1.0
References: <20191117211407.9473-1-olteanv@gmail.com> <78f47c04-0758-50f6-ad59-2893849e7dea@gmail.com>
In-Reply-To: <78f47c04-0758-50f6-ad59-2893849e7dea@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 21 Nov 2019 12:29:44 +0200
Message-ID: <CA+h21hpWXj9bFHg4sec2=8KEaXJ2sN4pvyftL4muBCEwrCzEDQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: tag_8021q: Allow DSA tags and VLAN
 filtering simultaneously
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Nov 2019 at 06:30, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 11/17/2019 1:14 PM, Vladimir Oltean wrote:
> [snip]
>
> > +best_effort_vlan_filtering

[snip]

> > +                     - Cannot terminate VLAN-tagged traffic on local device.
> > +                       There is no way to deduce the source port from these.
> > +                       One could still use the DSA master though.
>
> Could we use QinQ to possibly solve these problems and would that work
> for your switch? I do not really mind being restricted to not being able
> to change the default_pvid or have a reduced VLAN range, but being able
> to test VLAN tags terminated on DSA slave network devices is a valuable
> thing to do.
> --
> Florian

I took another look at the hardware manual and there exists a feature
called the Retagging Table whose purpose I did not understand
originally. It can do classification on frames with a given { ingress
port mask, egress port mask, vlan id }, and clone them towards a given
list of destination ports with a new VID. The table only has space for
32 entries though. I think I can use it to keep the CPU copied to all
non-pvid VLANs received on the front-panel ports. The CPU will still
see a pvid-tagged frame for each of those, but with the PCP from the
original frame. The result is that VLAN filtering is still performed
correctly (non-member VIDs of the front-panel ports are dropped), but
the tag is consumed by DSA and sockets still see those frames as
untagged. To me that's fine except for the fact that the CPU will now
be spammed by offloaded flows even if the switch learns the
destination to be a front-panel. Just wanted to hear your opinion
before attempting to prototype this.

Thanks,
-Vladimir
