Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8B843E1AB
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhJ1NLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhJ1NLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:11:53 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A7CC061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 06:09:26 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id k13so10548481ljj.12
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 06:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V6ZL1OGgX8rsUyYsshahG2gHTRwFOBR0b0scI77E6sA=;
        b=C+33LEenZhqhtIisZkyD5LMm6GoaLBHjAdY8AeOgTOOBQ7XU3OSar4BN4l34Xy6Glc
         fRgOwEO4l01i25hOY07nwIbQ8TY/CucvXtGja5oWS/NjsMFbmqX/KDb5M/BtESc6nxK4
         3P38XCRDO3I79J7Oute6xS1GQZigieOIkqThhCyuu0XNOuisgdXkcoHv4UWqDsM1O3jZ
         h6JFe8X0iNffGj+R6BKoUMizmih0av5+ANXk4wOQEEspVI0/pICMeJolFTInO/TmveoB
         VdFcKkACsjaekLMje22yCNTl/aj2EVCbDaoK+7XWVT+oKEUy3ntr8BJFbhYn2Pb9e83z
         89TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V6ZL1OGgX8rsUyYsshahG2gHTRwFOBR0b0scI77E6sA=;
        b=4RTlQZzwtjDEZeQIl+YvIHZNBRQKyN9sECocn99os5hbUgOZ8gpxiYJ3AZxPe/hB6q
         tch7Xq5F1vKL3GateqXsAS8PG3Amu8jCzQBkB/PAp7tB8IC+g+JxxPndmqcBZsTCyr1K
         Ufk4ZDiYcjb8OdNN0lSOEOSERQjhZHA3i3Bytbv9ufv7fY2gNunvqz4x4cImphE4FaOY
         vVEiLRTYunGLS3LXnow357bo3n/RRXCb4mOwCT7gNvpizgpAN4jPOl+kF3RbBDaIcc1v
         aXWvRsYxjGmqie06VxqcSrISBjxNsYIDUQeAP3X5udOJuoeogBv7admE9k9WjS7E/8qN
         Qp2w==
X-Gm-Message-State: AOAM532jXdQy5OFuej1P5F+NarxQV6IA/vSoMhnexmaFLMv/C1dWYsjO
        KAgIz6KdALzjdWm0A0R7C6Koa5+U/Pg95jNxYi0=
X-Google-Smtp-Source: ABdhPJwMsGztEfvwfrNmICJ/hqDYbbxsc6NntdQXPCYINKH9efvl87ci14Mu58FY2Zd2JojB/tPi3Ag++9ldBHRLC2g=
X-Received: by 2002:a2e:a277:: with SMTP id k23mr4658618ljm.22.1635426564329;
 Thu, 28 Oct 2021 06:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <SN6PR17MB26569E9922568671944F1D2B9D829@SN6PR17MB2656.namprd17.prod.outlook.com>
In-Reply-To: <SN6PR17MB26569E9922568671944F1D2B9D829@SN6PR17MB2656.namprd17.prod.outlook.com>
From:   Ruud Bos <kernel.hbk@gmail.com>
Date:   Thu, 28 Oct 2021 15:09:13 +0200
Message-ID: <CAA0z7Bx7_SUpxwTLOFF3QVDim_o6jieJ_seX8K3hc238_L6RRQ@mail.gmail.com>
Subject: Re: igb: support PEROUT and EXTTS PTP pin functions
To:     Jaideep Sagar <jaideep.sagar@keysight.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jaideep Sagar,

On Sun, Oct 24, 2021 at 8:57 AM Jaideep Sagar
<jaideep.sagar@keysight.com> wrote:
> I also needed the 1PPS-out on SDP from i350 to give as 1PPS-in to our Timing FPGA for PTP. In our design SDP2 is used and the patch _does not_ work with SDP2 or SDP3, but only with SDP0 and SDP1.
>
> The issue in igb_main.c and igb_ptp.c level/level_mask assignments.

Thanks for the heads up!
I only tested PEROUT using SDP0 and SDP1 and just assumed it would
work for SDP2 and SDP3 as well :-S

I will send out a v2 containing your suggestions later today.

> Food for thought: Adding TimeSync registers dump in igb_ethtool would be really nice to watch what is happening in realtime. Currently there are no TS registers in its dump.

Yes agreed, that would indeed be very helpful.

Ruud
