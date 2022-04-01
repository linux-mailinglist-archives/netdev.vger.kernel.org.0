Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04A4EE6F7
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244745AbiDADyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiDADyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:54:21 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78710126FAC
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:52:32 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id s8so1427714pfk.12
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KaiLJ4HaVKD4IbYElP7e6+NxB9b9iL+1oO3R0v9aJLE=;
        b=Mzup61Dgynykg7Zu/HeJdj3dbf/4LgU0vBwIyVbx5TpFu+gc0lqetVAHwOonPaKOt5
         QuNy72NiGgej/tOMo98cBp57yWvILCWts5KjZOAioyxHRobC+C728d0nB22/ULCiYpkO
         DN7otblCgY+v//NEKz6fMSNWEaNNBNAmbq+NA5PMq1zu8o1xSoHL0lBGO/qZ2MYUtM5M
         xyUonEdMMGaw/OtuBjVjfSJ4kIMtcfnwladrz591Lg97K6xt8hLOW6Xt7jxOJ8s2pj8v
         72ATJgtyzfgxCCyT6zdp4svKJJ9CaWNxJv5Iv/TMaV2Z9AnKZN2MbslFNJLO4Nzp4JJB
         6VLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KaiLJ4HaVKD4IbYElP7e6+NxB9b9iL+1oO3R0v9aJLE=;
        b=2fle4xSN6OJjUecq+q5SITZvEaYMmb5J/U08UPZ7pfsWflWwZbmn+AQUDU/n/vguVN
         ilxyjIOqFxINOcxzdptGTfTa8gjqZGNge/+YBInuuL6GHNVwkxTSiGOAcZzbFnxhr4EC
         ej7Tc6uSs7hOADQijMZZcZTOAJBi0iTe3W7bxB10+lT6rAGK6FuNUNITvqWjI9wIr5yj
         kGa5xcR8Hf8mUbOcrXApPWseUA6AZyjDGA+qmSgh3YRxO7t4e7BCzQMXA5GVx+kguoLt
         33dJq5JFFUJv5En6TmJL2smdtgEe/CGuSR67pNtpzsw7n4pkQAPDUd+3YvOy/L8S3r7i
         /Bkg==
X-Gm-Message-State: AOAM532Gupc5hEGKQVIeFOboyqnO+BWyqFs9CdUCiKLUSJclOVRuNQzR
        86ODXNOUIF+xzlRppdtzBBPC081n9GO0wr2yQEplG0N40pVdyQ==
X-Google-Smtp-Source: ABdhPJzOshwsNSt5QqA3VHP0glQjQlFp4XQNdaTtwaVhND/FhRE/0mmoT80usrWGQwmUjyyr5WOldf8/HW5Uu6MU9JY=
X-Received: by 2002:a62:5fc4:0:b0:4fa:7a4b:3853 with SMTP id
 t187-20020a625fc4000000b004fa7a4b3853mr42729435pfb.77.1648785151911; Thu, 31
 Mar 2022 20:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220331132854.1395040-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220331132854.1395040-1-vladimir.oltean@nxp.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 1 Apr 2022 00:52:20 -0300
Message-ID: <CAJq09z71vEXMHng1G9fHuJS_nrupcnJTQHxEPny4kQGrKO9hww@mail.gmail.com>
Subject: Re: [PATCH net] Revert "net: dsa: stop updating master MTU from master.c"
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This reverts commit a1ff94c2973c43bc1e2677ac63ebb15b1d1ff846.
>
> Switch drivers that don't implement ->port_change_mtu() will cause the
> DSA master to remain with an MTU of 1500, since we've deleted the other
> code path. In turn, this causes a regression for those systems, where
> MTU-sized traffic can no longer be terminated.
>
> Revert the change taking into account the fact that rtnl_lock() is now
> taken top-level from the callers of dsa_master_setup() and
> dsa_master_teardown(). Also add a comment in order for it to be
> absolutely clear why it is still needed.
>
> Fixes: a1ff94c2973c ("net: dsa: stop updating master MTU from master.c")
> Reported-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/master.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/net/dsa/master.c b/net/dsa/master.c
> index 991c2930d631..2851e44c4cf0 100644
> --- a/net/dsa/master.c
> +++ b/net/dsa/master.c
> @@ -335,11 +335,24 @@ static const struct attribute_group dsa_group = {
>         .attrs  = dsa_slave_attrs,
>  };
>
> +static void dsa_master_reset_mtu(struct net_device *dev)
> +{
> +       int err;
> +
> +       err = dev_set_mtu(dev, ETH_DATA_LEN);
> +       if (err)
> +               netdev_dbg(dev,
> +                          "Unable to reset MTU to exclude DSA overheads\n");
> +}
> +
>  int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
>  {
> +       const struct dsa_device_ops *tag_ops = cpu_dp->tag_ops;
>         struct dsa_switch *ds = cpu_dp->ds;
>         struct device_link *consumer_link;
> -       int ret;
> +       int mtu, ret;
> +
> +       mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
>
>         /* The DSA master must use SET_NETDEV_DEV for this to work. */
>         consumer_link = device_link_add(ds->dev, dev->dev.parent,
> @@ -349,6 +362,15 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
>                            "Failed to create a device link to DSA switch %s\n",
>                            dev_name(ds->dev));
>
> +       /* The switch driver may not implement ->port_change_mtu(), case in
> +        * which dsa_slave_change_mtu() will not update the master MTU either,
> +        * so we need to do that here.
> +        */
> +       ret = dev_set_mtu(dev, mtu);
> +       if (ret)
> +               netdev_warn(dev, "error %d setting MTU to %d to include DSA overhead\n",
> +                           ret, mtu);
> +
>         /* If we use a tagging format that doesn't have an ethertype
>          * field, make sure that all packets from this point on get
>          * sent to the tag format's receive function.
> @@ -384,6 +406,7 @@ void dsa_master_teardown(struct net_device *dev)
>         sysfs_remove_group(&dev->dev.kobj, &dsa_group);
>         dsa_netdev_ops_set(dev, NULL);
>         dsa_master_ethtool_teardown(dev);
> +       dsa_master_reset_mtu(dev);
>         dsa_master_set_promiscuity(dev, -1);
>
>         dev->dsa_ptr = NULL;
> --
> 2.25.1
>

It fixes the issue. Thanks a lot!

Tested-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
