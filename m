Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B861DD611
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 03:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfJSBve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 21:51:34 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:38435 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfJSBve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 21:51:34 -0400
Received: by mail-pf1-f173.google.com with SMTP id h195so4897510pfe.5
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 18:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=yG0/m5JG7A5FzJnmQPn2cCrNoOlGYGqoq373oz2RJQA=;
        b=o+UqOM+ZB56tg2UVuAqs1vyv1Zp16+iAWFMKVG6HD8fOzc/iamhsikmWUgTW1aDXrd
         xWgtDTkaH4Z3DfWX1IdBVxz4JKO6UEKeH1ULlSLhg3nMnACHWbgutdvJGjqWyG7PkU7V
         wGbQl0ASf36xu8GbS0P3BZ7Hm1+gNqIL3SCvpzGjl4ZA5W14CbKIxrXnRUUIqHhgGw+w
         SvH5TGgY6YGCDfLmP6RmTEr9oMEkbCvduUScp06rcMFh6gvY8+JnHSa07TdryQ96CguN
         dbSBuodEEKCbpXtcixuXRqznX02Cdyl0OIFlCPLeTY0v7iLXPjNA//Re5hw/MWOktA+S
         scsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yG0/m5JG7A5FzJnmQPn2cCrNoOlGYGqoq373oz2RJQA=;
        b=q87W0RdbwzpTlZ07UhJWsAGrCuPHBVOH8c1O/b1fs7ZgdlTnCQmqouXNq09NzRLrKt
         iEdeIyhTmTCgiULKS1o57OsDEgvA2Ng5AORhYEDoQuWIo9raiS5MBpaLOAJOpM5lZlm8
         uNY8iz0RUqN30isuulK9XdMPIrUb/ebghfkCuCqYzRAkNA04yz0dcZ3U5xGrMr8wq3z6
         Kh3Ah5koMQojxnAKLK32avnSfzTwky9TW3MaE8+mQ8SG1/m6PQE9gZAiPUYzTPlXdGYZ
         XwLbeRSH2rJSmwEwo12sOjI9w9Qqwp/u0DP1Ll/2SsYVfAs42pRzD9N6eHsyzBNx7lJB
         b+cg==
X-Gm-Message-State: APjAAAVJCGGyhW3Ntb8GTs+yROC+nfJGrI71S5bwzasW5RjGmqoEkx4V
        tWxMHcxOmKPgjR5erZ8WEbbf7YE0sCk=
X-Google-Smtp-Source: APXvYqxjE1rBNZHhhnSTd0GbUI27KAUFIv9SG2E9OxilPNJHgw+uidYXWCaPigy21yJIen2y9URNpQ==
X-Received: by 2002:a63:e00e:: with SMTP id e14mr13410874pgh.146.1571449892324;
        Fri, 18 Oct 2019 18:51:32 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id b3sm6323902pjp.13.2019.10.18.18.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 18:51:32 -0700 (PDT)
Date:   Fri, 18 Oct 2019 18:51:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 12/15] net/mlx5e: kTLS, Enhance TX resync flow
Message-ID: <20191018185128.0cc912f8@cakuba.netronome.com>
In-Reply-To: <20191018193737.13959-13-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
        <20191018193737.13959-13-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 19:38:24 +0000, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> Once the kTLS TX resync function is called, it used to return
> a binary value, for success or failure.
> 
> However, in case the TLS SKB is a retransmission of the connection
> handshake, it initiates the resync flow (as the tcp seq check holds),
> while regular packet handle is expected.
> 
> In this patch, we identify this case and skip the resync operation
> accordingly.
> 
> Counters:
> - Add a counter (tls_skip_no_sync_data) to monitor this.
> - Bump the dump counters up as they are used more frequently.
> - Add a missing counter descriptor declaration for tls_resync_bytes
>   in sq_stats_desc.
> 
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Could you document the new counter in tls-offload.rst?
