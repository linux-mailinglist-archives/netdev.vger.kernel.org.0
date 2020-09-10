Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41222650AD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgIJUYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgIJUWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:22:53 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03AFC061573;
        Thu, 10 Sep 2020 13:22:53 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 37so6491912oto.4;
        Thu, 10 Sep 2020 13:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mk7sGg44/yfsC54l9DhzF/KZwI1G0H7I8q5/FXcWot8=;
        b=dYRIVK9q1YNOCb/49YAdSVDbKASdIkffMCjYsBImAED8c5cPTuP2fAfOx5qKE26+i+
         Lqov4lgCQVgxsVxmC+intTJOZv1wMIAPWQnswyf3pwdeP+Zg3NcY2WxABiZHEm5KzSXP
         n4bODewAAaXPMYryXbxmRQmw0lKUuWz3HaVNju1rAf0OzbIWw2ZrP0e2GaYWRE55mOe9
         M2xlYN5RbybDV0fqt1Fm+vAVOXIB6Ad3gk8+pf+3/ls+IhgaZlS0hFLfyuAGrnHpUzLr
         +52yA4icGa5AywGoCQwy44waGPhL4ClayeL8i0p/GeggKkUao8euYDZFyCXpgWzCsYlu
         T2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mk7sGg44/yfsC54l9DhzF/KZwI1G0H7I8q5/FXcWot8=;
        b=fI0b8YQaN7rmBbftFIuSXMbaXAQWtSEMxYN0fdcJsLPF9Yo5FXpVYFxF3TrIggCHyU
         4zSg8ijDwNcWFJqBdHRsY9meKrSRKihrhFOM7v50Cf/DWKPg6mDnF2M8NgycKHXFMa5j
         NEcqpGrjAzrooRsAFNuRAmRN4IxIr3aVXfrdIkuUuNzmcsP9ZE0WtuwWIIaZKR69gNKs
         JaZ2YJlwy/7ni6Tz4kBo0yr6mFVB2orgSuM06ujTS8Ayw9ge1HQjWlRzCzrrSZdhZSzL
         P0oHn6Wg5SXYQDmdubfqDACl/9VvKmjJ4W4/B3NvwOFdblPw2Xxay3AnhHonwk5mpBM9
         /Qkw==
X-Gm-Message-State: AOAM531pWL1ZtTzxEc9UhsZxrmfN6ALKy+O1NpatafKGSOupO9I4YgPh
        NlLQ1PD1S+UoP46rcEl6fcKaqMPjOpSKI2e6Q4w=
X-Google-Smtp-Source: ABdhPJzodRgtioNMRusqjX8bwcL7duveaj8vNv5MRDuM5tBV9WmgYZ/S4Z9o5pf1y4JwpSguO5WvxeE+Dq2FBOnuHl4=
X-Received: by 2002:a9d:66cf:: with SMTP id t15mr5324699otm.143.1599769373093;
 Thu, 10 Sep 2020 13:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161126.30948-1-oded.gabbay@gmail.com> <20200910161126.30948-14-oded.gabbay@gmail.com>
 <20200910201951.GG3354160@lunn.ch>
In-Reply-To: <20200910201951.GG3354160@lunn.ch>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Thu, 10 Sep 2020 23:22:25 +0300
Message-ID: <CAFCwf10W_gzrZi4PtiQpjHCvi+ioS9xCS42q9sWSxOd0VOA4xg@mail.gmail.com>
Subject: Re: [PATCH 13/15] habanalabs/gaudi: Add ethtool support using coresight
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Omer Shpigelman <oshpigelman@habana.ai>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:19 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static int gaudi_nic_get_link_ksettings(struct net_device *netdev,
> > +                                     struct ethtool_link_ksettings *cmd)
> > +{
> > +     struct gaudi_nic_device **ptr = netdev_priv(netdev);
> > +     struct gaudi_nic_device *gaudi_nic = *ptr;
> > +     struct hl_device *hdev = gaudi_nic->hdev;
> > +     u32 port = gaudi_nic->port, speed = gaudi_nic->speed;
>
> Please go through the code and fixup Reverse Christmas tree.
Of course, we will fix this.

>
> > +
> > +     cmd->base.speed = speed;
> > +     cmd->base.duplex = DUPLEX_FULL;
> > +
> > +     ethtool_link_ksettings_zero_link_mode(cmd, supported);
> > +     ethtool_link_ksettings_zero_link_mode(cmd, advertising);
> > +
> > +     ethtool_add_mode(cmd, supported, 100000baseCR4_Full);
> > +     ethtool_add_mode(cmd, supported, 100000baseSR4_Full);
> > +     ethtool_add_mode(cmd, supported, 100000baseKR4_Full);
> > +     ethtool_add_mode(cmd, supported, 100000baseLR4_ER4_Full);
> > +
> > +     ethtool_add_mode(cmd, supported, 50000baseSR2_Full);
> > +     ethtool_add_mode(cmd, supported, 50000baseCR2_Full);
> > +     ethtool_add_mode(cmd, supported, 50000baseKR2_Full);
> > +
> > +     if (speed == SPEED_100000) {
> > +             ethtool_add_mode(cmd, advertising, 100000baseCR4_Full);
> > +             ethtool_add_mode(cmd, advertising, 100000baseSR4_Full);
> > +             ethtool_add_mode(cmd, advertising, 100000baseKR4_Full);
> > +             ethtool_add_mode(cmd, advertising, 100000baseLR4_ER4_Full);
> > +
> > +             cmd->base.port = PORT_FIBRE;
> > +
> > +             ethtool_add_mode(cmd, supported, FIBRE);
> > +             ethtool_add_mode(cmd, advertising, FIBRE);
> > +
> > +             ethtool_add_mode(cmd, supported, Backplane);
> > +             ethtool_add_mode(cmd, advertising, Backplane);
> > +     } else if (speed == SPEED_50000) {
> > +             ethtool_add_mode(cmd, advertising, 50000baseSR2_Full);
> > +             ethtool_add_mode(cmd, advertising, 50000baseCR2_Full);
> > +             ethtool_add_mode(cmd, advertising, 50000baseKR2_Full);
> > +     } else {
> > +             dev_err(hdev->dev, "unknown speed %d, port %d\n", speed, port);
> > +             return -EFAULT;
> > +     }
> > +
> > +     ethtool_add_mode(cmd, supported, Autoneg);
> > +
> > +     if (gaudi_nic->auto_neg_enable) {
> > +             ethtool_add_mode(cmd, advertising, Autoneg);
> > +             cmd->base.autoneg = AUTONEG_ENABLE;
> > +             if (gaudi_nic->auto_neg_resolved)
> > +                     ethtool_add_mode(cmd, lp_advertising, Autoneg);
> > +     } else {
> > +             cmd->base.autoneg = AUTONEG_DISABLE;
> > +     }
> > +
> > +     ethtool_add_mode(cmd, supported, Pause);
> > +
> > +     if (gaudi_nic->pfc_enable)
> > +             ethtool_add_mode(cmd, advertising, Pause);
> > +
> > +     return 0;
> > +}
> > +
> > +static int gaudi_nic_set_link_ksettings(struct net_device *netdev,
> > +                             const struct ethtool_link_ksettings *cmd)
> > +{
> > +     struct gaudi_nic_device **ptr = netdev_priv(netdev);
> > +     struct gaudi_nic_device *gaudi_nic = *ptr;
> > +     struct hl_device *hdev = gaudi_nic->hdev;
> > +     u32 port = gaudi_nic->port;
> > +     int rc = 0, speed = cmd->base.speed;
> > +     bool auto_neg = cmd->base.autoneg == AUTONEG_ENABLE;
>
> It appears you only support speed and auto_neg. You should check that
> all other things which could be configured are empty, e.g. none of the
> bits are set in cmd->link_modes.advertising. If you are requested to
> configure something which is not supported, you need to return
> -EOPNOTSUPP.
>
>         Andrew

Thanks Andrew,
We will do that and send an updated version.
Oded
