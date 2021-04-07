Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761A7356D0F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 15:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352551AbhDGNRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 09:17:18 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:41924 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbhDGNRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 09:17:18 -0400
Received: by mail-wr1-f51.google.com with SMTP id a6so11943162wrw.8;
        Wed, 07 Apr 2021 06:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=reTmhKvBN3tocVTLjIjKXDj59q/Jd1b5uYQWnvwRd4o=;
        b=VQ4Co4YY+mRVlGanNt1ggtNEbSZ+DiSUFpF13wG0de1LE90ByjNYBCj1rkZPrvXFYp
         Fg9KYPilEnrz5QjX1pTe57yCdfhmv2YVsUONR040ix+ZFchJlsClld/4uS6PILEIjEHE
         bcdAmF/eMBjNd7G64nHfTeAXZwDttn7PkFvD8NG3mcKelOvyxlsQQHM3nsvqIVgT/YDa
         anPIxrnlpzKLmL/KyNt9TrF7Hdla5xmXaIIgZgc+cJuXcbxRltrazbmnghGu4xwBEceQ
         MxJcvQBwYr9R4XXA0C6OQEuXldnmnnr7gQVwRM7rWdFFA55+HepByVUqgRro/Cy32uyC
         p2ww==
X-Gm-Message-State: AOAM530t+ojdIuFQI7WA7+9bPe9tRUzX+RT3S2TEp+p5gSvgHCK62O5z
        Uw9DRFCICjwqEGtDdbMJ9lQ=
X-Google-Smtp-Source: ABdhPJzPsLNDRF2MzLLYeZm5jCpcet4IU2A1fqmU0t9Kh5TAb9TNXi4OFwJxlkn3JS5Vd/TS/VuSpA==
X-Received: by 2002:a5d:5051:: with SMTP id h17mr4348268wrt.80.1617801427561;
        Wed, 07 Apr 2021 06:17:07 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id j1sm10292292wrq.90.2021.04.07.06.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 06:17:07 -0700 (PDT)
Date:   Wed, 7 Apr 2021 13:17:05 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        liuwe@microsoft.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <20210407131705.4rwttnj3zneolnh3@liuwe-devbox-debian-v2>
References: <20210406232321.12104-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406232321.12104-1-decui@microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 04:23:21PM -0700, Dexuan Cui wrote:
[...]
> +config MICROSOFT_MANA
> +	tristate "Microsoft Azure Network Adapter (MANA) support"
> +	default m
> +	depends on PCI_MSI
> +	select PCI_HYPERV

OOI which part of the code requires PCI_HYPERV?

Asking because I can't immediately find code that looks to be Hyper-V
specific (searching for vmbus etc). This device looks like any
other PCI devices to me.

Wei.
