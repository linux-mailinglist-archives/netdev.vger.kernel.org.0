Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F5E117963
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfLIWed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:34:33 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43362 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfLIWed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:34:33 -0500
Received: by mail-pg1-f193.google.com with SMTP id b1so7820467pgq.10
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 14:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=21rRHFPvjZK3p9sHxqd95tcXX0jutqdzXHdUpefK27I=;
        b=xLXQN/34gfNkqvPZgEQz5Mq2sz3JTIRFKKDEMrDkmN9SNnGVD53BM76EFsQtm821z3
         hm9bSpkCxRvaWD1KfrbJ7hlkJ8VA5ZlaTFYQk0XbDUXYYMx5rCg1d1ikljOOpsjdJkPS
         hjHSCCvznTKb6zNNsxcgeIfoCwMyt81+ZLXU2qboyA2JCpkA+mLfutk1hi1BV6IeDk6L
         TmiMYvyJqB0bK7OVhFYbnhwGPtWwSC+FB1Pek0CPLTRBaaC3dplL3ozbtwJj6mBgwOvD
         ETQiaILMphm0U2UVlSF6pcFu87BIJo7ISADkLLAvGwQJQtR7oSc3LS19I6lhW8NQnfIV
         8nmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=21rRHFPvjZK3p9sHxqd95tcXX0jutqdzXHdUpefK27I=;
        b=tTNUCFDDVmvnKL5wVa2I5y0wR5Up0iS0GG2rJ1DFKkSEEpqnw++4Qw/FbfIbN1N/k9
         BQ0SJaBrv6fnvMbRKxM+ByrDN/z3MPHiCR5/yaDhT2c+YISP4quDtd2ltQ9rLMlrMb6W
         22lhLCy8Aedz4iO8nnKmwbAoi1fPuBSoGr6tUikozB7ACMS2cBUX4ehu3HNvNl60jFkv
         /SaeB+eyK+xU5Ow5RDlaKUxTaGm2QE9dbCMphwObN/S8W4/G311UKwZFeekijAy3aKbJ
         4A+0k50q0G8qQ3zLpB6VHNP+5t2zOwnY/Jn8SZY0JkTCH/b2ec5IAcpU6fxt56hd41j9
         cUnQ==
X-Gm-Message-State: APjAAAX8bQXRnzXPkTSuV4xKlC5J0lLzFYxFIl+0dALr3vZ0opptd2Jm
        fMHhkYiLdqV6ucgYBJD5/cmRqg==
X-Google-Smtp-Source: APXvYqx5Y6yN8qanz5HKz3fNJcveqsP9bTjS52aSSqGDmRYhlpXPSa30Muh8LSeXdJMwe2m6+QFIWw==
X-Received: by 2002:a63:444b:: with SMTP id t11mr20591062pgk.72.1575930871906;
        Mon, 09 Dec 2019 14:34:31 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w8sm460267pfn.186.2019.12.09.14.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 14:34:31 -0800 (PST)
Date:   Mon, 9 Dec 2019 14:34:23 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH iproute2] iplink: add support for STP xstats
Message-ID: <20191209143423.7acb2f4b@hermes.lan>
In-Reply-To: <20191209211841.1239497-2-vivien.didelot@gmail.com>
References: <20191209211841.1239497-1-vivien.didelot@gmail.com>
        <20191209211841.1239497-2-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Dec 2019 16:18:41 -0500
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index 31fc51bd..e7f2bb78 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h

These headers are semi-automatically updated from the kernel.
Do not make changes here.
