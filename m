Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF769574C25
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 13:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiGNLcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 07:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiGNLcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 07:32:18 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6023011161;
        Thu, 14 Jul 2022 04:32:17 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id q9so2151419wrd.8;
        Thu, 14 Jul 2022 04:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=tCZ7lsnCbDc60EXUrQNEsOicMsLkNCFOVPMlzUByVj4=;
        b=gs4nyJPBX03XqZJNm/F85YUZ14SKg6feQrV2ADINjD4vJ75/NN4lol4lmHA60NVwWI
         hceFs2CK3lOh5LhyYZ/hc0xdihnUVfJVaRwY2JtL50unDzOVO57jmzKm8v/sdS5rB0ud
         meqtqz6AYNbiwYkvsDgTqS3GT6yEvnotvaKV8dqrijOiUQYMJdU/CH8AutoPJBOMN+iM
         FgPF+vDZfsGZ15XbNijCto21e99O3XmGrVbN/33lzktS2HAnMWpQ/QAQdgjf0WuPxItT
         s+5iK5p2OfLB0v61GFixVhpoeyhvWVFNo9evK5aBfB6DLJad8ncTNfevg4ceqqRCTiC4
         5D+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=tCZ7lsnCbDc60EXUrQNEsOicMsLkNCFOVPMlzUByVj4=;
        b=7JJoEj4GC3HjQGlPrCTphxfsWdiKJ6grDY5yVbeu0oaZFIE0/UtG4I7qOQe3HGQfPt
         1gn3Aq7fptw5mXFr8EqmTMeZbeApoCH34o4JrQSpJ5T2DDZr/+iEerOhSG9wYyThTv/A
         mUVZKp55tsw8raq8S6kNG+QnRBG3RUYaXN4nTbV6hvIaTHmimRF0AGh65KjNeiJB3ig9
         lLq+98GnaSeqrQnD5tx5ROIM8quCN+1Mpo27dUEEI5kZ9iX9byW/es/mMUHP8dqjI09Z
         /HzzVUUQ5dSUQRwK9acn4AVHVAG+UKi8uYZkZ2oYDQUj3aXNVz8wZJWZCeE0xZYqQa7W
         xuag==
X-Gm-Message-State: AJIora80Ck3KdX6OjWMI2+jJ/hoVUOErmzWKdScWxg281WwuLsrNHraS
        XYm7NPoUe1bbEhrWIYm0mvA=
X-Google-Smtp-Source: AGRyM1vuoVneLFzH3m7NGSqOYprjQjpD7vRvnn6thiy3XdsLcSbbtruj1KnmO31mpGCRTpeDXXtVxA==
X-Received: by 2002:a05:6000:1e11:b0:21d:a4b1:e1f9 with SMTP id bj17-20020a0560001e1100b0021da4b1e1f9mr7714894wrb.104.1657798335869;
        Thu, 14 Jul 2022 04:32:15 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id r16-20020a5d52d0000000b0021dabdc381fsm1216653wrv.22.2022.07.14.04.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 04:32:14 -0700 (PDT)
Date:   Thu, 14 Jul 2022 12:32:12 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/2] sfc: Add EF100 BAR config support
Message-ID: <Ys/+vCNAfh/AKuJv@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <165719918216.28149.7678451615870416505.stgit@palantir17.mph.net>
 <20220707155500.GA305857@bhelgaas>
 <Yswn7p+OWODbT7AR@gmail.com>
 <20220711114806.2724b349@kernel.org>
 <Ys6E4fvoufokIFqk@gmail.com>
 <20220713114804.11c7517e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713114804.11c7517e@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 11:48:04AM -0700, Jakub Kicinski wrote:
> On Wed, 13 Jul 2022 09:40:01 +0100 Martin Habets wrote:
> > > So it's switching between ethernet and vdpa? Isn't there a general
> > > problem for configuring vdpa capabilities (net vs storage etc) and
> > > shouldn't we seek to solve your BAR format switch in a similar fashion
> > > rather than adding PCI device attrs, which I believe is not done for
> > > anything vDPA-related?  
> > 
> > The initial support will be for vdpa net. vdpa block and RDMA will follow
> > later, and we also need to consider FPGA management.
> > 
> > When it comes to vDPA there is a "vdpa" tool that we intend to support.
> > This comes into play after we've switched a device into vdpa mode (using
> > this new file).
> > For a network device there is also "devlink" to consider. That could be used
> > to switch a device into vdpa mode, but it cannot be used to switch it
> > back (there is no netdev to operate on).
> > My current understanding is that we won't have this issue for RDMA.
> > For FPGA management there is no general configuration tool, just what
> > fpga_mgr exposes (drivers/fpga). We intend to remove the special PF
> > devices we have for this (PCI space is valuable), and use the normal
> > network device in stead. I can give more details on this if you want.
> > Worst case a special BAR config would be needed for this, but if needed I
> > expect we can restrict this to the NIC provisioning stage.
> > 
> > So there is a general problem I think. The solution here is something at
> > lower level, which is PCI in this case.
> > Another solution would be a proprietary tool, something we are off course
> > keen to avoid.
> 
> Okay. Indeed, we could easily bolt something onto devlink, I'd think
> but I don't know the space enough to push for one solution over
> another. 
> 
> Please try to document the problem and the solution... somewhere, tho.
> Otherwise the chances that the next vendor with this problem follows
> the same approach fall from low to none.

Yeah, good point. The obvious thing would be to create a
 Documentation/networking/device_drivers/ethernet/sfc/sfc/rst
Is that generic enough for other vendors to find out, or there a better place?
I can do a follow-up patch for this.

Martin
