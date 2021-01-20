Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A342FD59E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390305AbhATQ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 11:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbhATQ0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 11:26:45 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3981C061757
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 08:26:00 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id 143so25804586qke.10
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 08:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HhCjQrI5oCirKKd6rj6b/GW4mkL5QCbT6rFd4TvDZw4=;
        b=Kjteni6ztRnYBoq3yFBCJzWyHg5ARcqrhXC56uDpvKBhiwARuy9qcVIYrNMZSsAJL9
         yPFQ+i6PzdZFjyrO3Q0y6oK2eaW4fF0/3aPiCUt5KjJglALn9WwSl7REzz1aEs8k+v8m
         BfWjoMORc7sP+2V3bVHcXFXBNnbsAs3+cGQGFZ5fdaMcVprQNqDsMugvu0ZlYr3l8NNV
         unoaPZm9LZStbB3QBsuVu1VMWXVXu1n2b8fnNQTRfuj44bgYLmfah+NKZzy+4H+GEm2h
         0RuavLmWjd7FMskpjaAflW8VLzLIxwakRKReVs+4zjbeM1THXsc1Y35Vog2ygv6qSxwX
         xbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HhCjQrI5oCirKKd6rj6b/GW4mkL5QCbT6rFd4TvDZw4=;
        b=CSGajiimQN6T9/GTPrul0sSPsBiTJPIXWsOdhNMSw5xAC9vpqUBjtwppLmuGznZ0WQ
         ZzqgebrDJ3MKqI29cwKZ4W+Jn6KKpQtdtWjq8zrDFyrWMQ7k6bITKrR46yE7MKJKVksB
         hMncV1tD6Wi8fhjk4l452Vf0xFpD3GFz3HkZgnIZh0FFEeydtOGliZd3K4/RYjSHeizH
         p0FD2rEOxi27wGlt1LD3/xeXhhRDOiDKOJRHQsVzu8YmVYjgLim3i4Rk7xliGRvGZo7w
         3s6/FlkbAS1prErO6iyZbFmmrWonSUcJ0BRlmdK6FNs8xfFvyYkhn1HJYO0iwzpz+MZC
         5NEA==
X-Gm-Message-State: AOAM532Cn05bTN002fD/xky0/X2hSZ3PhCcSOeHgyg2ydcMrePM86AQk
        gR0sXlQ5UfwKh9i48QTd5aU=
X-Google-Smtp-Source: ABdhPJweaIR1X4vinNvotpvEPda98Vjs1wKssB9r5gbEHLfX8ZUtrhgFNvBC1DS2d9E6eD4aaeHJWg==
X-Received: by 2002:a37:a085:: with SMTP id j127mr10050903qke.273.1611159959751;
        Wed, 20 Jan 2021 08:25:59 -0800 (PST)
Received: from horizon.localdomain ([2001:1284:f016:4ecb:865e:1ab1:c1d6:3650])
        by smtp.gmail.com with ESMTPSA id a77sm1647010qkg.77.2021.01.20.08.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 08:25:59 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id DB5FAC0EA1; Wed, 20 Jan 2021 13:25:56 -0300 (-03)
Date:   Wed, 20 Jan 2021 13:25:56 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next v2] tc: flower: add tc conntrack inv
 ct_state support
Message-ID: <20210120162556.GA3863@horizon.localdomain>
References: <1611111132-25552-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611111132-25552-1-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 10:52:12AM +0800, wenxu@ucloud.cn wrote:
> +++ b/tc/f_flower.c
> @@ -340,6 +340,7 @@ static struct flower_ct_states {
>  	{ "trk", TCA_FLOWER_KEY_CT_FLAGS_TRACKED },
>  	{ "new", TCA_FLOWER_KEY_CT_FLAGS_NEW },
>  	{ "est", TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED },
> +	{ "inv", TCA_FLOWER_KEY_CT_FLAGS_INVALID},
Sorry for the late nit picking but, missing a  ^^  space here.

Otherwise, LGTM.
