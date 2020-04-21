Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544101B2568
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 13:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgDUL4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 07:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726403AbgDUL4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 07:56:49 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F6DC061A0F;
        Tue, 21 Apr 2020 04:56:49 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id l3so7081752edq.13;
        Tue, 21 Apr 2020 04:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HDl4PcryGuPjgJh8iajtlR3OBsl1Kn7J0vY5z+ZmlDQ=;
        b=FQK8jSBm3fq1kmBDwPBY92h9XWiG4/47OGHLQx7mjNgD0YuiMeLzKlLHV06th5Tghl
         6JjDzkbBNWH/jxmQj8kpLLjdS9cvxmYVMQA7jxf5ljQc7AKr6e6MzSS/l2bbPXopaAXS
         DmsWdo9943w3scHjLvFOHDfDeCffjlY6DnAIkAS5Ulqoa6D5fzZ5bTjAlYzbklCHQ66T
         95wzL4IsPparxs0UYYk1qMEfk6KMAX9sGf3tZE6vELjjTNA11Wdh7tFW7HV5vQjr3BYX
         6eGc9lgmpO7uY/aVX66i3Hv24F2PhKOALyHOq2GZBEu7J0kGPkU8zk6DCqNjJ7msUrl+
         +Gjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HDl4PcryGuPjgJh8iajtlR3OBsl1Kn7J0vY5z+ZmlDQ=;
        b=mVT8omN+WM0vFHfE/ykTNzrW0FgQpXUTIRujsMji8zTODdE14+JO2xI7vSQVEbInoz
         Ofn9eVB7PccBmQos6qI1o/Kx0wYn9fcZ7dOr/qBpNEJx9E4lx3GXRG3JtVw+3mNiwCCr
         M6gIwS5WDUmyR2nWuO+HY/ulXDrO5Nkp13tasVgun/F5sy8RF+aTOgf5RLCVltgFjaC+
         W8JbrVKpNw+Q/1LJ7YAT4SL7LJ4cQMsckpEJDuyOmnSeH4GrltXqc+wxnn+WFUICO4zY
         MOAuJ6w3heeea8fx8T2Bu75FZ67PmRh6Fw2ujtsTlUTeEwdh+26YaIFOKjcflN6W2R8D
         vV9w==
X-Gm-Message-State: AGi0Pua540wdUV1mi7ahtO3D0WsyKnMJU9w4txZWkbqGyHkr4qBN/iXq
        yvMKmc6b3S2j6625y/fkoCT3mU3yqfeDNwdoKec=
X-Google-Smtp-Source: APiQypI0MWThGq6YBjMemZa0yhIY9LEoNJt9Db1HDYRxRrxiOj9Aio9OF32UVFWaOjR1CDfAOJPT+nthCqzMLc1vWG0=
X-Received: by 2002:a50:f288:: with SMTP id f8mr13696974edm.337.1587470208280;
 Tue, 21 Apr 2020 04:56:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200421113324.vxh2lyasylf5kgkz@pengutronix.de>
In-Reply-To: <20200421113324.vxh2lyasylf5kgkz@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 21 Apr 2020 14:56:37 +0300
Message-ID: <CA+h21ho2YnUfzMja1Y7=B7Yrqk=WD6jm-OoKKzX4uS3WJiU5aw@mail.gmail.com>
Subject: Re: dsa: sja1105: regression after patch: "net: dsa: configure the
 MTU for switch ports"
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        David Jander <david@protonic.nl>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Tue, 21 Apr 2020 at 14:33, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Hi Vladimir,
>
> I have a regression after this patch:
> |commit bfcb813203e619a8960a819bf533ad2a108d8105
> |Author:     Vladimir Oltean <vladimir.oltean@nxp.com>
> |
> |  net: dsa: configure the MTU for switch ports
>
> with following log:
> [    3.044065] sja1105 spi1.0: Probed switch chip: SJA1105Q
> [    3.071385] sja1105 spi1.0: Enabled switch tagging
> [    3.076484] sja1105 spi1.0: error -34 setting MTU on port 0
> [    3.082795] sja1105: probe of spi1.0 failed with error -34
>
> this is devicetree snippet for the port 0:
>         port@0 {
>                 reg = <0>;
>                 label = "usb";
>                 phy-handle = <&usbeth_phy>;
>                 phy-mode = "rmii";
>         };
>
>
> Is it know issue?
>
> Regards,
> Oleksij
> --
> Pengutronix e.K.                           |                             |
> Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

The code which is causing problems seems to be this one:

    mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
    old_master_mtu = master->mtu;
    new_master_mtu = largest_mtu + cpu_dp->tag_ops->overhead;
    if (new_master_mtu > mtu_limit)
        return -ERANGE;

called from

    rtnl_lock();
    ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
    rtnl_unlock();
    if (ret && ret != -EOPNOTSUPP) {
        dev_err(ds->dev, "error %d setting MTU on port %d\n",
            ret, port->index);
        goto out_free;
    }

Before this patch, it was silently failing, now it's preventing the
probing of the ports which I might agree with you is not better.
Andrew warned about this, and I guess that during probe, we should
warn but ignore any nonzero return code, not just EOPNOTSUPP. I'll
send a patch out shortly to correct this.

Out of curiosity, what DSA master port do you have? Does it not
support an MTU of 1504 bytes? Does MTU-sized traffic pass correctly
through your interface? (you can test with iperf3)

Thanks,
-Vladimir
