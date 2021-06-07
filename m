Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7681939E49F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFGRBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhFGRBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 13:01:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF11BC061787
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 09:59:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l10-20020a17090a150ab0290162974722f2so428387pja.2
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 09:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ley0ZV8wDk+WyRdH1QdkNT8cH2cyBlW9JyOpeJgzHEI=;
        b=dS2FsnITrxu/HHyNu4GkyWB5mSo2cwU9z3MazXFOzlF0WolGpGWbhAQozatjm/EOH4
         ToCzVzAcX/93SoX4NpmSoSVykXyY49TZmB/iJdUD92GAo2HiECTfY6QsZTrH4Q42m+qj
         OfZbBR6kj8ea0i8RQxtuZXSXL2wIN3Qbb0Wy7P1ksm2gAXoDKYTX6sGLN/4egmAtAcjV
         tEum9+ZE987fULyC6UzYRrBQsido6zeY/dqnvRpvKtxiRywyZIb6Qa669eNDcpe/ebst
         EuXOd0JPASJPY31vdx3+1eOgdEuCcN/To+E/ckNU6LAApUzah2LIDZccnWu9B7dFFBOy
         BnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ley0ZV8wDk+WyRdH1QdkNT8cH2cyBlW9JyOpeJgzHEI=;
        b=eqn0SnhR9IaV7h64yKgE6mu/BhJ0KjoiBIhgNZnAxLwUsToTRGSDu0BwhRpAYoQNRe
         61+fkExL/+dxZCdU4WzVj4/edx96t4cBvSnpAJeWkUCDLJOVScMIrrBzbiX6ZMWcWYRx
         5H1ngOGpPgiWXnU3794RJYbkkG9bDJUJDVTKB63omUnh8I8myH653iY/pC/nBIqaTMMA
         Gmhu8W0IrN6zuL7hnfnmvOwYv/kAC9sFnL+m8O9thZsHewP3SEjhX2I0UIksfjP+kNuQ
         p8BVvgjahHTsdlLWVLYTpzGBc+Ofrurpp0UyPwlIpMw8aF5MqTGwQeh3unzspy0qrqzX
         x6RA==
X-Gm-Message-State: AOAM5325g6T1KEiWmC7sbeWyrdxJZA4XkZcdmRRMcb9SLaJJnHTpeoPV
        5PL4lyDTspN/2Ukc4QVO08nNZw==
X-Google-Smtp-Source: ABdhPJwripROeUdXi7hrC8E5sTFgtkqi2SA988n1L0PKbrgULaPn+XXQLmeHBuoeMqgKLN3OjTYzwA==
X-Received: by 2002:a17:90b:517:: with SMTP id r23mr17470053pjz.209.1623085157403;
        Mon, 07 Jun 2021 09:59:17 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id e188sm8425877pfe.23.2021.06.07.09.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 09:59:17 -0700 (PDT)
Date:   Mon, 7 Jun 2021 09:59:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ujjal Roy <royujjal@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, Kernel <netdev@vger.kernel.org>
Subject: Re: net: bridge: multicast: Renaming of flag BRIDGE_IGMP_SNOOPING
Message-ID: <20210607095913.32c17900@hermes.local>
In-Reply-To: <CAE2MWkkL9x+FRzggdOSPcyFpguwP9VuQPD9AJWLTsfLzaLodfQ@mail.gmail.com>
References: <CAE2MWkkL9x+FRzggdOSPcyFpguwP9VuQPD9AJWLTsfLzaLodfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Jun 2021 21:29:34 +0530
Ujjal Roy <royujjal@gmail.com> wrote:

> Hi Stephen,
> 
> Can we rename this flag BRIDGE_IGMP_SNOOPING into something like
> BRIDGE_MULTICAST_SNOOPING/BRIDGE_MCAST_SNOOPING? I am starting this
> thread because this BRIDGE_IGMP_SNOOPING flag holds information about
> IGMP only but not about MLD. Or this is not a common name to describe
> both IGMP and MLD. Please let me know about my concern, so that I can
> change the code and submit a patch.
> 
> Thanks,
> UjjaL Roy

It is part of user API at this point so not possible to remove old definition.
