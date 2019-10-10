Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E34D343E
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfJJXUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:20:22 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43504 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfJJXUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:20:22 -0400
Received: by mail-qt1-f193.google.com with SMTP id t20so5886729qtr.10
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 16:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nRzsXUYX1Vn9zmeoL5CxM2e+8mSHdi5U0zkrK8ruq28=;
        b=u7STbV6Nf9BEb8lek2LE5FxFx/KCqYCiqLxJ0+6iTzXY2X79xfL5KJ1u7BnF5zhjM/
         PHXsqq7fbqivrD6tGPTmFKF3PNajAflnKX2p6VcXQ27pxz8wxWb+lOLZl+9bzy825zxF
         /3os/Biu3HXlbXL4Md9kEXt00bqyubT09mYoRFXIfb8sAoHOzVnm52nKgS+tusX1L0KD
         XXRERzp6WH2WqnefLyxsVUi4lj0yM/5kl9pf1MCPuE62UD4TpbQ3dQKXSWY4/FNo/Cat
         Bg0VenxuSzQwoi9448aaOj4SLtm47glnjhGzllhVfMYEAqaFXzckOtDaV4LxucXNtPDA
         UdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nRzsXUYX1Vn9zmeoL5CxM2e+8mSHdi5U0zkrK8ruq28=;
        b=LuN4vL2OLu1C48g2S4Mt1rFteQXvK0ESg5Dz9FnoMUOtCUdQQO7GVlQ1c56bIKqoRf
         Vr7bW9YrCkJmk/ADEzsSR6vSCW5EE3JHd2yHrVUVxzshcVXkoa2F4ilW9vhxZZRgln1g
         xZ40MbO7vjsj5Rken4SZw14G0o280KYew8SrLzb+MHupNr/NfEeQNd9n+lilNUlwnlp5
         gjZqiBYgLBpSvVUMzc8a+5GDc6WH4N/WMYJVJgrHXrhX74hh836JWsB0XFLMPRuRZe33
         E6Kd50qxgCw+TuPAsig6vUColCePF26B/OP4FtVt+JIA1U49pkvmTqm3WK8wsn3F3fCh
         VlAQ==
X-Gm-Message-State: APjAAAU5lDzq3xf0Nh1KuR9Ii1/k8OMdcjM5xhaZ10e9TeQkojNuHOf2
        cZ/ksKkOmJRtJzIZY40EO3BCzA==
X-Google-Smtp-Source: APXvYqwp7UVXtdlmZp2oYKdWOn7HN7Z1Oxpb2JTm5wkzLcWIIVpO9P3FGDk5Ts36dpPUCPSX5q3DrA==
X-Received: by 2002:a05:6214:13e3:: with SMTP id ch3mr13118794qvb.215.1570749619676;
        Thu, 10 Oct 2019 16:20:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h9sm3538762qke.12.2019.10.10.16.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 16:20:19 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:20:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        David Miller <davem@davemloft.net>, linux-doc@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH] Documentation: networking: add a chapter for the DIM
 library
Message-ID: <20191010162003.4f36a820@cakuba.netronome.com>
In-Reply-To: <e9345b39-352e-cfc6-7359-9b681cb760e8@infradead.org>
References: <e9345b39-352e-cfc6-7359-9b681cb760e8@infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 15:55:15 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Add a Documentation networking chapter for the DIM library.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Tal Gilboa <talgi@mellanox.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> ---
>  Documentation/networking/index.rst   |    1 +
>  Documentation/networking/lib-dim.rst |    6 ++++++
>  2 files changed, 7 insertions(+)
> 
> --- linux-next-20191010.orig/Documentation/networking/index.rst
> +++ linux-next-20191010/Documentation/networking/index.rst
> @@ -33,6 +33,7 @@ Contents:
>     scaling
>     tls
>     tls-offload
> +   lib-dim
>  
>  .. only::  subproject and html
>  
> --- /dev/null
> +++ linux-next-20191010/Documentation/networking/lib-dim.rst
> @@ -0,0 +1,6 @@
> +=====================================================
> +Dynamic Interrupt Moderation (DIM) library interfaces
> +=====================================================
> +
> +.. kernel-doc:: include/linux/dim.h
> +    :internal:
> 
> 

CC: linux-doc, Jake

How does this relate to Documentation/networking/net_dim.txt ?
(note in case you want to edit that one there is a patch with 
updates for that file from Jake I'll be applying shortly)
