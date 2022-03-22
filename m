Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FD94E3C13
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 10:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiCVKAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 06:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiCVKAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 06:00:52 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C756C92E
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:59:23 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id w7so28854195lfd.6
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LBiQvx2LWy5w+xI6TfvH1394ERrpiuM6QsohcKDoyGM=;
        b=FrmwXrcDCDVi46QYb02thf92OZRwYdzewlhUZLyIXd7VVAijJZG/dIK5vhsnv3IuYE
         Av5pP38/VxNpZnurRBzfc5hELUnozMh26rIcxwMod8RUXUA77jVlUraAfuQb3qX/JJNc
         pJsj5wOf5oNAUq6EcejPEGsZm7Cmqt0BpAyVMiovuDd3toLX/dROVg9A82HWcP/00YCT
         wOBndOBa0hf1hXHuSRGH3+ay+wsY2FGItAXeoLMuCs76eh7l5XRx9jyH/k/6RwC27Cwt
         0bS6FiCS5HDEfhyum51NNSwjvlDUU2mB6wqz/Zs4FROg2Ohjglr1QeXWfDMep5oq2kCE
         F8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LBiQvx2LWy5w+xI6TfvH1394ERrpiuM6QsohcKDoyGM=;
        b=nCjYBS/jXgf636j48qj7s6ekQRHX0V5IjsU5xCTrCtGESLqp6itJEktssqhIBkWO5s
         28gfnzbSxwe4xnxlQ+itHnWecqp5ELQU0N2zWuKXJXz3ArmBZWdFQBtyoCQ5BWhwPkLs
         4OaAVCBVw1UxSUcwIg/7qkTFnUYw30wNRtaldBAHvFQyKFHjAsRFc/AwZ5WesV4MlCbI
         un04otEnBo+/s2gqB4VYnze9tyaNs7qPqjYbPwAJ6tTkiayNREzmRg00tBt1AbH8e1lg
         oveTiT3U1LNZ1bVAE00p5gCDPRhIdHxVGLM2I5LOHTJnmtnsMNN1uXTlI4rUaZ1StFQZ
         wQqg==
X-Gm-Message-State: AOAM532GujHUkV5eFwPGqMfTLaKcyh64TiOxhHp08qvNtEvoDBEiujnO
        uJRNk7PjeQkatDW/CpVB1+Y=
X-Google-Smtp-Source: ABdhPJzQKZcOfXs661zz9si1uYGXNnVLjJlKUjByrVfUAku+in8SStkCw9vsGLxZGYUNHmqD31cowA==
X-Received: by 2002:a05:6512:1111:b0:44a:1035:7a1f with SMTP id l17-20020a056512111100b0044a10357a1fmr12013138lfg.182.1647943162054;
        Tue, 22 Mar 2022 02:59:22 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id o2-20020a2e7302000000b00249820fb8c5sm759899ljc.4.2022.03.22.02.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 02:59:21 -0700 (PDT)
Date:   Tue, 22 Mar 2022 10:59:20 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 2/2] net: sparx5: Add mdb handlers
Message-ID: <20220322095920.hptmgkby3tfxwmw4@wse-c0155>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
 <20220321101446.2372093-3-casper.casan@gmail.com>
 <23c07e81392bd5ae8f44a5270f91c6ca696baa31.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23c07e81392bd5ae8f44a5270f91c6ca696baa31.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So this was already merged, but I have some comments on the feedback for
the follow up patch.

> > +static int sparx5_handle_port_mdb_add(struct net_device *dev,
> > +                                     struct notifier_block *nb,
> > +                                     const struct switchdev_obj_port_mdb *v)
> > +{
> > +       struct sparx5_port *port = netdev_priv(dev);
> > +       struct sparx5 *spx5 = port->sparx5;
> > +       u16 pgid_idx, vid;
> > +       u32 mact_entry;
> > +       int res, err;
> > +
> > +       /* When VLAN unaware the vlan value is not parsed and we receive vid 0.
> > +        * Fall back to bridge vid 1.
> > +        */
> > +       if (!br_vlan_enabled(spx5->hw_bridge_dev))
> > +               vid = 1;
> > +       else
> > +               vid = v->vid;
> > +
> > +       res = sparx5_mact_find(spx5, v->addr, vid, &mact_entry);
> > +
> > +       if (res) {
> > +               pgid_idx = LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_GET(mact_entry);
> > +
> > +               /* MC_IDX has an offset of 65 in the PGID table. */
> > +               pgid_idx += PGID_MCAST_START;
> 
> This will overlap some of the first ports with the flood masks according to:
> 
> https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.html?select=ana_ac,pgid
> 
> You should use the custom area (PGID_BASE + 8 and onwards) for this new feature.

I'm aware of the overlap, hence why the PGID table has those fields
marked as reserved. But your datasheet says that the multicast index 
has an offset of 65 (ie. MC_IDX = 0 is at PGID = 65). This is already 
taken into account in the mact_learn function. I could set the
allocation to start at PGID_BASE + 8, but the offset still needs to 
be 65, right?

BR
Casper
