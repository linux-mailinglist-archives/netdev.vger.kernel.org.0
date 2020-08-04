Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA2823B881
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgHDKNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgHDKNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 06:13:11 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F6FC06174A;
        Tue,  4 Aug 2020 03:13:11 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o5so3847752pgb.2;
        Tue, 04 Aug 2020 03:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VUZ+5uaWO5tygxXuvOm55d3w56P1W5CNtNbPKcozm+o=;
        b=BbsTPuA4f+c97Mqm4Dhm66f9TB6s3p0y9+fl9la8dSQZ1b2w4EnvmGOkSZBlZVxEQi
         +mAkU4d3/nigMTMcM7HEC6B7H+1drbyVBb0RJc7P0/JU3g595pcwSRPU7RMk6djLgmZA
         Tbl1Dvre/iCIBqpldW1K0yGa6l7xkuj3dk/8rQVSOEgOCjCiEwzYUv6gSZQC4P6uwLcL
         MAq4Fwc9SDNxh0PEm2MTNSNHRODPIBO7AFqc+IkxqPjybdG1dyf5SgMd9VnehbaP8hw/
         6fhPTL/NW+557guMWBZx68Sjj5L1z4eX5LvEFxXfC2M4t3j/QQl0EdlFy/RAepYcv2r5
         Edhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VUZ+5uaWO5tygxXuvOm55d3w56P1W5CNtNbPKcozm+o=;
        b=fUeeWvd2ZRejQZ1sWQrw256P97RzM4EbMsJVtqowW9H2Y3RFKi9vHSKKHb23bDF0uB
         A9+EBVVHyz5hqsYSufAFR8NyB+EtgFOBPCGbD4e1tnVvm3XHZbGZF10RpgvGkDQsHxOz
         1Oz3hA0Tzpf4MNq6qOAvVFDuQVLCQ4/z5FigXLEQPGS8ZLDTSPWdhLosVlSa6IqiDSYw
         Lo/zglcq0yfNyT+MHLUOaR9hUO0Blua4VIQsPZxdU07TPEG0xpJnp8cmRhhPeHxa22Nm
         K6o3OmXBTLFoUtO4I52kjqwAqF2IXuf26QDefTApr5mo0FLH9VVu224gRdLi8Kq6SIT9
         jDpw==
X-Gm-Message-State: AOAM533szIRmvwyPzx+9BmUbxlyq2ejjP9N7w7ZSMJSVfDp7587711Fv
        glscVrFiURINRX4SHjreuNY0FwFi+9OydCxjTFY=
X-Google-Smtp-Source: ABdhPJyKMDJtC/pI434FF62GRZ35Xm2o0EpxfqLH2ESt2EmF/5liRp8UjeIexAeqMr2Xm0lz1ysYmDrSXO5yB3E4XyA=
X-Received: by 2002:a63:5412:: with SMTP id i18mr19181541pgb.63.1596535990834;
 Tue, 04 Aug 2020 03:13:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200730073702.16887-1-xie.he.0141@gmail.com> <CAJht_EO1srhh68DifK61+hpY+zBRU8oOAbJOSpjOqePithc7gw@mail.gmail.com>
 <c88c0acc63cbc64383811193c5e1b184@dev.tdt.de> <CA+FuTSeCFn+t55R8G54bFt4i8zP_gOHT7eZ5TeqNmcX5yL3tGw@mail.gmail.com>
 <CAJht_EOeCpy_SLKk2KXJHBj79VCujUZWiZou_BDfMr+pVWKGPA@mail.gmail.com>
In-Reply-To: <CAJht_EOeCpy_SLKk2KXJHBj79VCujUZWiZou_BDfMr+pVWKGPA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 4 Aug 2020 03:13:00 -0700
Message-ID: <CAJht_EN5fRKMHZRtqOgYKZ4wmOZOQcrGnarEPWUxRD31eaftRA@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Willem de Bruijn <willemb@google.com>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 3:07 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> Maybe we could contact <majordomo@vger.kernel.org>. It seems to be the
> manager of VGER mail lists.

Oh. No. Majordomo seems to be a robot.
