Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20BC3B2821
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 09:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhFXHFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 03:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbhFXHFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 03:05:02 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDA5C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:02:42 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gt18so7796669ejc.11
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6fkn1t48QSmhqLF7tpQ8HdI9mch/4nD22eLGhQXr89M=;
        b=li+Bmsz8k5mzK0dHHAkT9RzpuRjTw0nvuyLE9GRXWxo5CYnV+pDcbdopPCFmkzxLx5
         6CNh1RXlh4kWAfjxKxKbw+h4JakrmwwrTfNoIaTdpG2u4zD/fgArPCbIigRJeL6RQdmg
         1KjUFy6pAR4HS8T2vxi5w5CfDiShwnogPEQh+gsOe1DpiVAom5sUodOA6O8E8MBZFgff
         egoTkEWDy1wysuo8f6+4tEpZBcmbcIT4r9hm09465rOQdujdoPt2Egn7vbSieXqDdUGd
         ZFVCnKo9ZHTBJDMZRJ0RJmhfXytOD41AlURh+/rNfxzCkNdzUhE30idaq2+JYh+F4oEW
         s/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6fkn1t48QSmhqLF7tpQ8HdI9mch/4nD22eLGhQXr89M=;
        b=dteQfI4ROK3nWy6zXSCWoYnvBZk5Sdq8O5Jmt9Gd2DYmNNglWJKDu4cckWB3VFPurZ
         v+oThrBstrVBZEa68dPFdAq/RASndPNR7E4KLD0zmb+Z0jvIGbLmzwNO18X+hSJiLdmY
         bpjBdW4z2aH43TcxRxRY+rzpdMPV+srYmmEBU2kr55ISWj93kozXboD+RQibAZTdXHLc
         55E/UI/keRdgeRDYOr6Puzm0ngGTx2zn0c8fzgJL/j6mWRO3iDB+jXL5AfqqyjywaBwY
         9w/uPxh4EkGO2waxO7y9jwVmmIgfnlsCXjHptmpchtHyhV5GtBvL9cubVs3fpXG2Tu8K
         xbPQ==
X-Gm-Message-State: AOAM532g52txPIkSfBFla/L4dFhz3y4ZG7ZL4JwEclAvSiR8OAGoD2GW
        9WzSxGyJa95dgWCX0yoZVlFocwmYitwnVauVeWw=
X-Google-Smtp-Source: ABdhPJw8FgdRYyVha0iWDEJAGnV3FKiv6xDqv5zj82sKU1Vk+lpLgEy68jUJIQ+6fsQsHVoFN5unxY5K5vkVYE1iWOU=
X-Received: by 2002:a17:907:94ca:: with SMTP id dn10mr341073ejc.527.1624518161502;
 Thu, 24 Jun 2021 00:02:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210624041316.567622-1-sukadev@linux.ibm.com> <20210624041316.567622-3-sukadev@linux.ibm.com>
In-Reply-To: <20210624041316.567622-3-sukadev@linux.ibm.com>
From:   Johaan Smith <johaansmith74@gmail.com>
Date:   Thu, 24 Jun 2021 02:02:30 -0500
Message-ID: <CAJAjEthEoZk8LLWhhwMaTy0nrh5qaeY6ouUu--Uv2D_Zr+1pug@mail.gmail.com>
Subject: Re: [PATCH net 2/7] Revert "ibmvnic: remove duplicate napi_schedule
 call in open function"
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com,
        Abdul Haleem <abdhalee@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 11:17 PM Sukadev Bhattiprolu
<sukadev@linux.ibm.com> wrote:
>
> From: Dany Madden <drt@linux.ibm.com>
>
> This reverts commit 7c451f3ef676c805a4b77a743a01a5c21a250a73.
>
> When a vnic interface is taken down and then up, connectivity is not
> restored. We bisected it to this commit. Reverting this commit until
> we can fully investigate the issue/benefit of the change.
>

Sometimes git bisect may lead us to the false positives. Full investigation is
always the best solution if it is not too hard.
