Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DEE578B97
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 22:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbiGRUSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 16:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiGRUSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 16:18:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747782C139
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 13:18:32 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p9so12763074pjd.3
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 13:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KfhKOXmubx1EKGY3mvILRN1AcjqBpxBYNJ/41G4gW1Y=;
        b=ua/uURpJyXoJzC/VHGiL1rPLY6gDHuF2SutmgdUJqjeKPc53XnWrMKFeCOJtirDSaj
         at8qNlxji1ck2004MwidpZcnVJ3WNxAUx7BsG0m728OgOBAR8JHRqmEQUXkPXGz/vWRX
         pOov3Y+qBsycj69xxKaeMkZ4794/dnEI2LtArRJ7MpIDQ5FMP9vaZpwnyrPCa5yxJI0M
         tF3XDGCZuHHzIeBGOWoXZMD3ePD55XFojzHOp9Cc2q/2F6nAsSnbWRNiIp028d/HKqZs
         1kA9tkrzjGfD26LFhtEjxlOMMp72smbj9f0JxzvIghL9XHerV0nsIe+EM/dDRJs0h08/
         2iwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KfhKOXmubx1EKGY3mvILRN1AcjqBpxBYNJ/41G4gW1Y=;
        b=2qzLJJVu6RIYN3zoE4iBF/Kgp4NGKUA+yigrrJFgFOyPM2euPThTUPrAYE2gxjCPM0
         oRM2inaWMqSxp/MUBu7zpNH83VaLCT+u/LMNV9ADFQhOyPkFHhApMG+3UCxrB1iJk3qc
         iIw5bbxjVkChr7rxDoHxws8bIDH0kAYdXLN8JuDYueN5kT8swj7SnnxXPI4m4HgAISaQ
         Y+OtBnyjVxryb0THyWsPu42ZTPxKs6LUufrNn7M0uQpoxddtEW9JTuQQiG47JEw/GGAb
         WRRIb0DGF2vxzZDi5v7WfxolbxWVBx5A8GAtzp8O8G+TpfpD1uOo/YDXKoaxcup/b/55
         zQ8w==
X-Gm-Message-State: AJIora8qch/91SbJjvYN3YnJZV/lJ98r1VYBjABB44SXcRp5k7WugQH5
        025i5shc4KWrj622Wa50XYuhsQ==
X-Google-Smtp-Source: AGRyM1vdf132yTgKhBucuzaF4/O3fZY3Xr2AffP4k67ujeQGXylwc28AiTOMFn3ejbSrF1q+PbQM+g==
X-Received: by 2002:a17:90a:5514:b0:1f1:f37f:ecc1 with SMTP id b20-20020a17090a551400b001f1f37fecc1mr685358pji.70.1658175511930;
        Mon, 18 Jul 2022 13:18:31 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id bc7-20020a170902930700b001635b86a790sm9876833plb.44.2022.07.18.13.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:18:31 -0700 (PDT)
Date:   Mon, 18 Jul 2022 13:18:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2] uapi: add vdpa.h
Message-ID: <20220718131828.65dd561a@hermes.local>
In-Reply-To: <97faec92-f2d0-ab5e-4fdd-bfd2e2e911e8@gmail.com>
References: <20220718163112.11023-1-stephen@networkplumber.org>
        <PH0PR12MB5481AAD7096EA95956ED6801DC8C9@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220718095515.0bdb8586@hermes.local>
        <97faec92-f2d0-ab5e-4fdd-bfd2e2e911e8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jul 2022 11:51:09 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 7/18/22 10:55 AM, Stephen Hemminger wrote:
> > On Mon, 18 Jul 2022 16:40:30 +0000
> > Parav Pandit <parav@nvidia.com> wrote:
> >   
> >> We kept this in vdpa/include/uapi/linux/vdpa.h after inputs from David.
> >> This is because vdpa was following rdma style sync with the kernel headers.
> >> Rdma subsystem kernel header is in rdma/include/uapi/rdma/rdma_netlink.h.
> >>
> >> Any reason to take different route for vdpa?
> >> If so, duplicate file from vdpa/include/uapi/linux/vdpa.h should be removed.
> >> So that there is only one vdpa.h file.
> >>
> >> If so, should we move rdma files also similarly?
> >>
> >> Similar discussion came up in the past. (don't have ready reference to the discussion).
> >> And David's input was to keep the way it is like rdma.  
> > 
> > RDMA is different and contained to one directory.
> > VDPA is picking up things from linux/.
> > And the current version is not kept up to date with kernel headers.
> > Fixing that now.  
> 
> Updates to vdpa.h do not go through net-next so moving it to
> include/uapi/linux can cause problems when trying to sync headers to
> net-next commits. That's why it was put under vpda, similar to the rdma
> model.

Ok, will make sure the update script for current picks it up correctly.
