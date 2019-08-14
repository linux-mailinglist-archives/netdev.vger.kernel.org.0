Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2102E8C59F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 03:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfHNBpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 21:45:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44174 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfHNBpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 21:45:03 -0400
Received: by mail-qt1-f195.google.com with SMTP id 44so77457732qtg.11
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 18:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=TaeTgbEgKeuniyhRwODvYXoOfpd7liiFN1SmAcX8His=;
        b=D5MI5hS3Z1Jgemg4DrYqGP17fMcHm0JpxwJcpNvoWNsj9m55kKOhGNz7Ta26mGwbzK
         TDVNht+PlBGpX4kqCxct5XbJEvEw9LSvyjNG2LRVYHr2UTeggtsx6y/4RBCKuCpNtF2U
         RXRknaznhjOiORNj8Wi96Qtaim/55hfk5lf4n+HjxI0nsI04U863RMOEW/EnK1H+11mt
         ABIdwf6vbmUkMW4Gfaowf51vrgv3RkqSNpPoliP/NqjpKufiphtFymGJ1x2uH540o0Cw
         eNBd7C43j8TKQqqcFbb517ucRt5YGX+hhmUOcMDHJtu0EuP3XPFHBNyaUMx8v0z4sxU7
         +tDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=TaeTgbEgKeuniyhRwODvYXoOfpd7liiFN1SmAcX8His=;
        b=FtZ4AkkGUk0PUrg5AQ/0cNSp2vrMOG6x5v+KDTH7jxfEoE4jlLc7bkhzgIAWhNHJTp
         FlkdvHkjkj/mcWbyK32IsumQ5+CJmQ+g9n5jOzsUukVgl56ztnBiKkjFE89E5Ztsn7y6
         aAooCsnzr18zmXARiKO1XugBPJVMZhLKbN7ISPyjEkGjn/Zbd+lERlS0wqHEUunzLb9K
         Y5YQLQocyHKmnieIz1016iLjAoOarM1LYTEY+gAqeuaDbLYcWYv5lbqEkiDFOLQHhHrf
         A86qJwUWLpkO5kz4WFWBmdsHRADnT9R5j/peW49W+SCcAYz6G8pesZwxL1wWl+Hd32VN
         GsVg==
X-Gm-Message-State: APjAAAXBmjdu9J38sdbBNRzbq1weAC4AFWgtgoqotf+gL6GXxIwL34Sm
        mUi+bioljAs/pXsZn9pQPlduvg==
X-Google-Smtp-Source: APXvYqzbhn8NqzEGJVbU57O7LKKv9OdJArZr/SzVPFpL91z597fJFlJVlO75QdF3OHLAsBg++MaU8A==
X-Received: by 2002:ac8:22b9:: with SMTP id f54mr10674838qta.45.1565747102917;
        Tue, 13 Aug 2019 18:45:02 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z2sm12025172qtq.7.2019.08.13.18.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 18:45:02 -0700 (PDT)
Date:   Tue, 13 Aug 2019 18:44:50 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/17] Netfilter/IPVS updates for net-next
Message-ID: <20190813184450.3e818068@cakuba.netronome.com>
In-Reply-To: <20190813183701.4002-1-pablo@netfilter.org>
References: <20190813183701.4002-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 20:36:44 +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter/IPVS updates for net-next:
> 
> 1) Rename mss field to mss_option field in synproxy, from Fernando Mancera.
> 
> 2) Use SYSCTL_{ZERO,ONE} definitions in conntrack, from Matteo Croce.
> 
> 3) More strict validation of IPVS sysctl values, from Junwei Hu.
> 
> 4) Remove unnecessary spaces after on the right hand side of assignments,
>    from yangxingwu.
> 
> 5) Add offload support for bitwise operation.
> 
> 6) Extend the nft_offload_reg structure to store immediate date.
> 
> 7) Collapse several ip_set header files into ip_set.h, from
>    Jeremy Sowden.
> 
> 8) Make netfilter headers compile with CONFIG_KERNEL_HEADER_TEST=y,
>    from Jeremy Sowden.
> 
> 9) Fix several sparse warnings due to missing prototypes, from
>    Valdis Kletnieks.
> 
> 10) Use static lock initialiser to ensure connlabel spinlock is
>     initialized on boot time to fix sched/act_ct.c, patch
>     from Florian Westphal.

Pulled, thanks.
