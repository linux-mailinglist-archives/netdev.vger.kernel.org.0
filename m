Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1F0570474
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiGKNjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiGKNjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:39:02 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29B532471;
        Mon, 11 Jul 2022 06:38:58 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id r14so7079523wrg.1;
        Mon, 11 Jul 2022 06:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=ijkgD7ZriVJmUcfff67pNvWh6S6gwoHm/DJ12ZvJ9uA=;
        b=e1h/336AU3nLPRUhstVU3Zt54ZKFfwqDbDZrHkci4ufZvR41oQG3QHh917PrOnzbmX
         etinpldZ3qW8q4BjMe4zNjyUmN6gZMW62KNhQOZZJrbNZw7wC/X6rwrYrNlw5plpPVi8
         IHmxuyiTUF4R77svK2aC8Rc4iCzjjOQVjzLB3q4G/1GHIu+/Odmo0AdIRhZMdLIdF14o
         Hd8Pho1MClLLqTq6yeYYIwwZZf41HaOaixfaMP2xGEinBOq00En9bkzMz6wsiuTmxeB5
         fI9ZD6tCnit+KDMooQ7Z0H3QVXVKCVT9SDClG1q3SXdaxO/La4ApaftoQiTtbyycX++R
         WA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=ijkgD7ZriVJmUcfff67pNvWh6S6gwoHm/DJ12ZvJ9uA=;
        b=C5oy8s8RmkNwEUAT+zp/ZQXS75Ej7DKvDsSj02D64KV1ut5sVh9ByWu3VBFoi0djSq
         dhYLkHpRX2ofZl1AV0vlzkNs/bA/kSreX+Fb9neOWcD94LStHIxKi+2KCOXMckW3h+OR
         5f+9HG4UciPDJ3iDqNPFZtnU1f4Et733o9hjMENxC3EvL7pSyXumW2bQ3MzQN3bgkH/k
         0O5qLQa2uTAeVzWoY2lIlzxhgKvt+pjyhpXPY94vGorC+mBls0Dx+IfXdaJmUBh8VSlg
         /+1+bTv684Gbvn6K6cp7qdZjPqeem0y0V+LFZ/Frk8vp2FJwlfV8agKlFKF7I1FfO3y6
         ukTw==
X-Gm-Message-State: AJIora8saWO5gAP03dLCFoy9pXfPpvPwOnLMNzoB8kU3saFd6wtppRvX
        6iIEnqoiH5McFXTdn/yMdoM=
X-Google-Smtp-Source: AGRyM1s1l03Qmp8/F9WVwyipXx6JeVkeH8936Z/lS/k2eMqhzt0t4DbF29+0Ns6/hr1NHmDgBLjlsw==
X-Received: by 2002:a5d:4982:0:b0:21d:6e04:1fb3 with SMTP id r2-20020a5d4982000000b0021d6e041fb3mr16929899wrq.69.1657546737253;
        Mon, 11 Jul 2022 06:38:57 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id h126-20020a1c2184000000b003a18de85a64sm6910219wmh.24.2022.07.11.06.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 06:38:56 -0700 (PDT)
Date:   Mon, 11 Jul 2022 14:38:54 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/2] sfc: Add EF100 BAR config support
Message-ID: <Yswn7p+OWODbT7AR@gmail.com>
Mail-Followup-To: Bjorn Helgaas <helgaas@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <165719918216.28149.7678451615870416505.stgit@palantir17.mph.net>
 <20220707155500.GA305857@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707155500.GA305857@bhelgaas>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 10:55:00AM -0500, Bjorn Helgaas wrote:
> On Thu, Jul 07, 2022 at 02:07:07PM +0100, Martin Habets wrote:
> > The EF100 NICs allow for different register layouts of a PCI memory BAR.
> > This series provides the framework to switch this layout at runtime.
> > 
> > Subsequent patch series will use this to add support for vDPA.
> 
> Normally drivers rely on the PCI Vendor and Device ID to learn the
> number of BARs and their layouts.  I guess this series implies that
> doesn't work on this device?  And the user needs to manually specify
> what kind of device this is?

When a new PCI device is added (like a VF) it always starts of with
the register layout for an EF100 network device. This is hardcoded,
i.e. it cannot be customised.
The layout can be changed after bootup, and only after the sfc driver has
bound to the device.
The PCI Vendor and Device ID do not change when the layout is changed.

For vDPA specifically we return the Xilinx PCI Vendor and our device ID
to the vDPA framework via struct vdpa_config_opts.

> I'm confused about how this is supposed to work.  What if the driver
> is built-in and claims a device before the user can specify the
> register layout?

The bar_config file will only exist once the sfc driver has bound to
the device. So in fact we count on that driver getting loaded.
When a new value is written to bar_config it is the sfc driver that
instructs the NIC to change the register layout.

> What if the user specifies the wrong layout and the
> driver writes to the wrong registers?

We have specific hardware and driver requirements for this sort of
situation. For example, the register layouts must have some common
registers (to ensure some compatibility).
A layout that is too different will require a separate device ID.
A driver that writes to the wrong register is a bug.

Maybe the name "bar_config" is causing most of the confusion here.
Internally we also talk about "function profiles" or "personalities",
but we thought such a name would be too vague.

Martin

> > ---
> > 
> > Martin Habets (2):
> >       sfc: Add EF100 BAR config support
> >       sfc: Implement change of BAR configuration
> > 
> > 
> >  drivers/net/ethernet/sfc/ef100_nic.c |   80 ++++++++++++++++++++++++++++++++++
> >  drivers/net/ethernet/sfc/ef100_nic.h |    6 +++
> >  2 files changed, 86 insertions(+)
> > 
> > --
> > Martin Habets <habetsm.xilinx@gmail.com>
