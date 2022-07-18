Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474E55787CB
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiGRQuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbiGRQui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:50:38 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC7E2B263
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:50:33 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r186so11108110pgr.2
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4n6js8E2WeYhhPyAy0LXnhMR+2Lyu81yrdUw4lukj/Q=;
        b=XxCP3hMIhptKiTODsRhVC/+5CpuleB1RT8z6dM9SwBQyhsYuKoraTiFhDWEyCROE39
         AU/KUzr41XW2L1SnUbM9KicLrTG7/Bn5fhLW7RojBtoNQCDAuEH4HdppFa6nABV9CtAb
         ZIRPg5zPF7RXGq/RASwRa5BSwM5OM/4wjhtf0mPfYvVK6YusQw7FZRYSTeY/QHnkOYJL
         4aTCVsCHHOY2VMJWE5P9K4fmKrRJnxL/Ibcmc2MeUEQdfrprvZYgSrQUyDS0wqY4nBzN
         jGlcBoZ1n7uyLvrI7Je+zhhPUM3PKckrQHUp83vliMRrA+i3Ybk8vBT0mfZnRfKzCD2O
         FalQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4n6js8E2WeYhhPyAy0LXnhMR+2Lyu81yrdUw4lukj/Q=;
        b=vLHhLRpcg3Re++NwfsD686r2jn4VpkEKWFHBwr+8vzOrLE4aoEHVCCU/dQ6N31V844
         5eORj409MA8dsH4ZYpB40m2P7H1TWR6vxAWAQlTgkHmMU83Knlz5F6ThgIRopkzSCi3p
         ySInyCFazhrMGXKsuQdD9hUq6IJ+UsWgHMwJqjmx0sinMJCQmJJvwx0OvG/81JEhcSsu
         hxBDif86UTiMUKmP02i7kNSAMbFMqwU5jq1TDzl5jMKdqGiVIvMcua2vceiqwygX++5R
         h+1JA28OzBG7MVd0rwVbF294YSYVNkZJaQy1kX10lToWnOiTzUlD2Dpl4PPWCDEMX1HX
         7lsg==
X-Gm-Message-State: AJIora/nLKHmrgmp2zTLZaAwaPaNt/tYsOKt5uzxU/pmrqnVUh1ybdP3
        OGjTnOkEC8/5cM47dG7K8uEwOw==
X-Google-Smtp-Source: AGRyM1ssZ0LIrtHiVnK2+cQdSaOAlu5O/cSFpspTmseRXD4RBZKApkyXeQTHpGhihrZtSK9v7byjTA==
X-Received: by 2002:a05:6a00:1590:b0:52a:eb00:71dc with SMTP id u16-20020a056a00159000b0052aeb0071dcmr29636017pfk.64.1658163033417;
        Mon, 18 Jul 2022 09:50:33 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id o24-20020a63fb18000000b00419cde333eesm7298954pgh.64.2022.07.18.09.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 09:50:31 -0700 (PDT)
Date:   Mon, 18 Jul 2022 09:50:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] uapi: add vdpa.h
Message-ID: <20220718095027.1ea6bbbc@hermes.local>
In-Reply-To: <PH0PR12MB5481AAD7096EA95956ED6801DC8C9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220718163112.11023-1-stephen@networkplumber.org>
        <PH0PR12MB5481AAD7096EA95956ED6801DC8C9@PH0PR12MB5481.namprd12.prod.outlook.com>
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

On Mon, 18 Jul 2022 16:40:30 +0000
Parav Pandit <parav@nvidia.com> wrote:

> + David
> 
> Hi Stephen,
> 
> > From: Stephen Hemminger <stephen@networkplumber.org>
> > Sent: Monday, July 18, 2022 12:31 PM
> > 
> > Iproute2 depends on kernel headers and all necessary kernel headers should
> > be in iproute tree. When vdpa was added the kernel header file was not.
> > 
> > Fixes: c2ecc82b9d4c ("vdpa: Add vdpa tool")
> > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>  
> 
> > ---
> >  include/uapi/linux/vdpa.h | 59
> > +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 59 insertions(+)
> >  create mode 100644 include/uapi/linux/vdpa.h
> > 
> > diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h new file
> > mode 100644 index 000000000000..94e4dad1d86c
> > --- /dev/null
> > +++ b/include/uapi/linux/vdpa.h  
> 
> We kept this in vdpa/include/uapi/linux/vdpa.h after inputs from David.
> This is because vdpa was following rdma style sync with the kernel headers.
> Rdma subsystem kernel header is in rdma/include/uapi/rdma/rdma_netlink.h.
> 
> Any reason to take different route for vdpa?
> If so, duplicate file from vdpa/include/uapi/linux/vdpa.h should be removed.
> So that there is only one vdpa.h file.

Ok, sorry the semi-automated scan script didn't find the other one.
