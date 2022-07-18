Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5555787E1
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbiGRQzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiGRQzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:55:21 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4662B1A4
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:55:21 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h132so11095847pgc.10
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aPS75O8b4pbZpDbG2bChmtA0Qj8YJUSytXojD7AFtS8=;
        b=x87cRKMuprEUTbNLQiIP+cIGJDWLTbdCvj/3U0jH5rpFdIFqPMZPxXuKypdD2KA232
         2gNdZ2RRhhxDNeEz35XFpBStzlfV5Cv0TmPlyMnUXALZLfEDnpgFEH8Sr+dv1M/F9Yd6
         bryduAQgSZxy3xhx/nFYdex3GHebh339ZtCg3IOE6NEXgHamO2pkR25QlO388sVky3Ev
         3JW+zGBLn6kHEkQDzoVtMhI4SQnmOnYp/FF7OzPIUmVXOANV2KMqfbdOtZRESYgjyedk
         niXNMlPqTgmOtLuf2AtSyYeX/YNiS8AfjNO4G1ulk68TDMX2Bh0Wge5QtFhX4SaBjZQ6
         ro0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aPS75O8b4pbZpDbG2bChmtA0Qj8YJUSytXojD7AFtS8=;
        b=0ceboB59me/pnvFZSkqgeJuKtJX88MepvoWY9X1exBg7OJvHI1rLPR5Rv4t4MYkZGB
         iRlFdjA32QSvPzySLQaNetAPOFR3PND50ELDSvxu74DWKyu14Z0/1JqH7OwmMysUSv8F
         EbUXYFZXKadbIuBxpUA0/Tl/VAe9cP50Sg73uc8QZSSS6oVZQV2J5rbLzEdI/jgim9mr
         vLf/3kjc+x5QJDXQOsR2CKglRqve5S1jRCfz5BWnGfSJ2kMUBIOQDLXd5FnRHrMEgH4z
         KspnA10KzK626h9b+wiB0fa6R21aMvWTJ8adnAfUUn2reVvpY5ARL+v6M8fE8GNZ6g1B
         bP/g==
X-Gm-Message-State: AJIora/KtfGr+clCmSJlnxEtgE68AuroNVmmTLhv5t9GmNy41Ojd8r16
        r1QfHD/MJqw6gs1+0seY1wIkUVPKIjV0fg==
X-Google-Smtp-Source: AGRyM1s4+yRM3MLycKK1nWj8mNQzaYfEhRMXzKvtRLKmBy4+VhF8f74NtM60SraqMRWx2g6WcBfwbA==
X-Received: by 2002:a63:141a:0:b0:411:a3b7:bb19 with SMTP id u26-20020a63141a000000b00411a3b7bb19mr25500763pgl.518.1658163320743;
        Mon, 18 Jul 2022 09:55:20 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id ne19-20020a17090b375300b001f1eb2e3c00sm83957pjb.34.2022.07.18.09.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 09:55:19 -0700 (PDT)
Date:   Mon, 18 Jul 2022 09:55:15 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] uapi: add vdpa.h
Message-ID: <20220718095515.0bdb8586@hermes.local>
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

> We kept this in vdpa/include/uapi/linux/vdpa.h after inputs from David.
> This is because vdpa was following rdma style sync with the kernel headers.
> Rdma subsystem kernel header is in rdma/include/uapi/rdma/rdma_netlink.h.
> 
> Any reason to take different route for vdpa?
> If so, duplicate file from vdpa/include/uapi/linux/vdpa.h should be removed.
> So that there is only one vdpa.h file.
> 
> If so, should we move rdma files also similarly?
> 
> Similar discussion came up in the past. (don't have ready reference to the discussion).
> And David's input was to keep the way it is like rdma.

RDMA is different and contained to one directory.
VDPA is picking up things from linux/.
And the current version is not kept up to date with kernel headers.
Fixing that now.
