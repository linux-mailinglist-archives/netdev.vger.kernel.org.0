Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE88657314D
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiGMIkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbiGMIkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:40:09 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05270E2A2A;
        Wed, 13 Jul 2022 01:40:08 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id o4so14480801wrh.3;
        Wed, 13 Jul 2022 01:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=zOJqqf7JyBVMAL9yebbUBwe99YkdMrpm8IveXxmaD4E=;
        b=kwcx3J8twXX177RpWryqmeYl1wrMa0RLvc70G+KAPEWjskXS8ZGYCILRQfUBZIKr9E
         3URiOgDanlVJsutctnU9BSBJiXtJryb4ugfGnEmDfazBPkv0/wcJiaYGmLzXS0rvR+y+
         JtE9KEfvoyAoUjLPnBNvjfGvBBLbdfdiAnZ+sHrjdufQrFqdstYmoo9gvJD1S4eHmdXL
         LoY8U7s+Hicn2ZGkC+dsV6iyMRIHRhSzXRhN/EyFqkCKRMKPkN9R6iBJPAj1dkjVq6Fw
         NGQmx4d6MevII7YxztaWkK4Y4PRvj0J11fTLKyon/sHXGt8DAsF13qnH9CAu0/dpdtBx
         RsoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=zOJqqf7JyBVMAL9yebbUBwe99YkdMrpm8IveXxmaD4E=;
        b=FwQtdVE10UDRRcjNO5Dv10A34+QM6/teh7Ii9ofuSqtWInIJ9W1y0+PgccY0FjWPMP
         UGDcl7GONlZ7RTNkji3JwTPZRrbxxInjeLYBw3W6LSfJW6vkREFnXWmzhAOJRvbsft+t
         L/Aj86gkb+fvk+UyFTu3XDbrjqBzxdLVZF9DwPGmMfHr+BKxvMWva6P5jDj1oNTrvNUE
         9Mq5qedFTE3NbdscvG69TWD8qlKmgsGIzotlB3EPq+W8sF4H1uIUyzDAhqjk1o1d6noV
         rXU9MVkSso5V7etYiPHqorx+cz8moJDZOq6E4ppQSQFAkeehtHrTIlIs+qyNAj9gpdCH
         YcBg==
X-Gm-Message-State: AJIora9yWAfAScCRwdcHOCJjYa6wYyXgWjdQGih5byosMHvYRiShIPsY
        ETSVJ0HEMjtRoJvXzbicGNc=
X-Google-Smtp-Source: AGRyM1tBY9IWEzflMJmwkIximNJKe4TFmqZy0TKR3QqC3S3e/lSvKz4OrTsABaV4MW00TAm638/Jqg==
X-Received: by 2002:adf:e28a:0:b0:210:b31:722 with SMTP id v10-20020adfe28a000000b002100b310722mr2034100wri.65.1657701606436;
        Wed, 13 Jul 2022 01:40:06 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id co1-20020a0560000a0100b0021cf31e1f7csm10261274wrb.102.2022.07.13.01.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 01:40:05 -0700 (PDT)
Date:   Wed, 13 Jul 2022 09:40:01 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/2] sfc: Add EF100 BAR config support
Message-ID: <Ys6E4fvoufokIFqk@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <165719918216.28149.7678451615870416505.stgit@palantir17.mph.net>
 <20220707155500.GA305857@bhelgaas>
 <Yswn7p+OWODbT7AR@gmail.com>
 <20220711114806.2724b349@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711114806.2724b349@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 11:48:06AM -0700, Jakub Kicinski wrote:
> On Mon, 11 Jul 2022 14:38:54 +0100 Martin Habets wrote:
> > > Normally drivers rely on the PCI Vendor and Device ID to learn the
> > > number of BARs and their layouts.  I guess this series implies that
> > > doesn't work on this device?  And the user needs to manually specify
> > > what kind of device this is?  
> > 
> > When a new PCI device is added (like a VF) it always starts of with
> > the register layout for an EF100 network device. This is hardcoded,
> > i.e. it cannot be customised.
> > The layout can be changed after bootup, and only after the sfc driver has
> > bound to the device.
> > The PCI Vendor and Device ID do not change when the layout is changed.
> > 
> > For vDPA specifically we return the Xilinx PCI Vendor and our device ID
> > to the vDPA framework via struct vdpa_config_opts.
> 
> So it's switching between ethernet and vdpa? Isn't there a general
> problem for configuring vdpa capabilities (net vs storage etc) and
> shouldn't we seek to solve your BAR format switch in a similar fashion
> rather than adding PCI device attrs, which I believe is not done for
> anything vDPA-related?

The initial support will be for vdpa net. vdpa block and RDMA will follow
later, and we also need to consider FPGA management.

When it comes to vDPA there is a "vdpa" tool that we intend to support.
This comes into play after we've switched a device into vdpa mode (using
this new file).
For a network device there is also "devlink" to consider. That could be used
to switch a device into vdpa mode, but it cannot be used to switch it
back (there is no netdev to operate on).
My current understanding is that we won't have this issue for RDMA.
For FPGA management there is no general configuration tool, just what
fpga_mgr exposes (drivers/fpga). We intend to remove the special PF
devices we have for this (PCI space is valuable), and use the normal
network device in stead. I can give more details on this if you want.
Worst case a special BAR config would be needed for this, but if needed I
expect we can restrict this to the NIC provisioning stage.

So there is a general problem I think. The solution here is something at
lower level, which is PCI in this case.
Another solution would be a proprietary tool, something we are off course
keen to avoid.

> > > I'm confused about how this is supposed to work.  What if the driver
> > > is built-in and claims a device before the user can specify the
> > > register layout?  
> > 
> > The bar_config file will only exist once the sfc driver has bound to
> > the device. So in fact we count on that driver getting loaded.
> > When a new value is written to bar_config it is the sfc driver that
> > instructs the NIC to change the register layout.
> 
> When you say "driver bound" you mean the VF driver, right?

For a VF device yes it's the VF driver.
For a PF device it would be the PF driver.

Martin

> > > What if the user specifies the wrong layout and the
> > > driver writes to the wrong registers?  
> > 
> > We have specific hardware and driver requirements for this sort of
> > situation. For example, the register layouts must have some common
> > registers (to ensure some compatibility).
> > A layout that is too different will require a separate device ID.
> > A driver that writes to the wrong register is a bug.
> > 
> > Maybe the name "bar_config" is causing most of the confusion here.
> > Internally we also talk about "function profiles" or "personalities",
> > but we thought such a name would be too vague.
