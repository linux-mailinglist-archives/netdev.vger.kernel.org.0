Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744B8DD538
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbfJRXNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:13:11 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:40632 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfJRXNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:13:10 -0400
Received: by mail-lj1-f182.google.com with SMTP id 7so7770164ljw.7
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lMOb9C0PqUJAWM9u2GttgPjvLUYO42E/bAOC+rUMuzQ=;
        b=eIykwJcq11geUDU9fOWUPSEWj/V35fSw9xpH5XkqS5KLTycJlCaWuzDsxXFaFA9DAw
         zYfA+pY8fvkiBNbjFimBPFsex12F7De/tuLJvN5LQOGsN4BLRxKcvIvAh6my40MBXznI
         dAiaj0VxYBtn97cAcUBwEIDpigz8Zy6extoL8Thig5C6OcRLHANpIYNtXychdKw8xw3x
         AKK64EMtaZICPICsX4YeAY5PUVMtaSboCr79kFc8VFxYfY+GCxGgXU815f9sw3IB290E
         oFKgmDM1zoO1K1V08pfz1aFY487uQiayXEsgSRjU0j+VoIg1RoThBIA7PNcCgQnF0J3g
         0HbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lMOb9C0PqUJAWM9u2GttgPjvLUYO42E/bAOC+rUMuzQ=;
        b=eDH2ZSYfQH+IEhXgSr2Hap+v14ZXVLz3PNSFmhCukaMNtDPHDInONnLdurzlV8IwD+
         TnP9sIZH8f2D2uq06zWdK+Z+B7z2OSbhMUv26l4gSt2yZovSKNisOyRfyBTzxURCyHDU
         htl7OpLSKe2+wuikcK/S+WMep0+6UMvdiBZ54Z8nQdIq1uVgjVrfV8YDPbUR35nEztS6
         ALTyqYpTAmYIr1DzkgEKASTCwXwOjjN8Lo6iQA9H7inH0aJTOQEpb8BkpVIB7flGMl1L
         pO4U8stKvSAlpivqqqIPS1fOuki2LzesEC9Y8ZOIuMZBqvwGQ9y0HidpCf5/Y1QdUchz
         bb6A==
X-Gm-Message-State: APjAAAVajtoiQ3YkV6XRNr6JtzKsJA5Zj6xsa1vdf+VLGRJL2//LTPVQ
        xe88QRsZthdoE56QPZWgEQEvKmY2Qew=
X-Google-Smtp-Source: APXvYqwnQNH0DWq9MwMSfefK0drn6lzMLWYs3Dz2dZubcBPo6Q+IrRpOp4okQmkFa21HnJp4rBNfmg==
X-Received: by 2002:a05:651c:292:: with SMTP id b18mr6742135ljo.167.1571440388621;
        Fri, 18 Oct 2019 16:13:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k68sm3417958lje.86.2019.10.18.16.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 16:13:08 -0700 (PDT)
Date:   Fri, 18 Oct 2019 16:13:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net 04/15] net/mlx5e: kTLS, Size of a Dump WQE is fixed
Message-ID: <20191018161302.7dffc832@cakuba.netronome.com>
In-Reply-To: <20191018193737.13959-5-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
        <20191018193737.13959-5-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 19:38:09 +0000, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> No Eth segment, so no dynamic inline headers.
> The size of a Dump WQE is fixed, use constants and remove
> unnecessary checks.
> 
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Is this a fix?
