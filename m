Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93784DDFC7
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 19:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfJTRhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 13:37:34 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33524 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfJTRhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 13:37:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so6863988pfl.0
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 10:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vmU9pgUKQcEuMSYv/BBcahpMF4UtOam9a0i9ZLAtxwE=;
        b=qKEkBRN+OgbmOLStSpTKuai/Xfu9qXtg1CINfl5SyuNp17UtrCIRg4cYlTHvTP7jvi
         iySsIaj77Mkq5ikwpFE1Xm/HeB9gXw7gMQ9+8+PbXbc8crqm0BUMsyzxHH8y43gvMhWM
         ZPqaZTwEpYG8bwy6YiqNQc1EtjsPyI3fSxBuepTvDf3qjb3uJLon9kJhgE/dinrNL/1d
         KZru/zmy2IyvTIGkhnRqVhuRfzge3ksp3hSNQjh9rO7kaCgQf1K9d8g2B0hgk4eiYUK6
         2caH3dikfd1EuVemAEzIBBhrl8BglKur+OZCB/z0GRnm39nGICVdA73ecO+5tC5KLM6h
         coHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vmU9pgUKQcEuMSYv/BBcahpMF4UtOam9a0i9ZLAtxwE=;
        b=gK87HxLDcW6juS7vYkIs77JyHugfE3S3RvHYcdp2iOAjc0+pArHq6cxpWwJsvSo2Yp
         JQcEGY2AsKnBkytmTd4Gm/7kFPx+KeVD93aP0qA8BQQhZJHRpljFxKgBNXh8oE88wHnf
         +Huu3LnKdDhacOnCKR62mP2B/p04zYx3iltCAk4+JomOFOlAr1akS8s9uaVF3pBqy2Ki
         NcIM7zUmvGyG+cKUyC1TgWH4ZxchDAU9teRBkG+RZjyXJBo/+b+LYhjN2Oa+lf34Dhe8
         P6an/V5ByoDmsV0l6miWtmGXweoLTm75gIkggM4LTv8agcrqzR4zYIjFsVW+bWiQclfR
         Pj/A==
X-Gm-Message-State: APjAAAWNLc+d6GPFsCLpWWgSSOvWP4RNnRRc5L+b9NS95hWUu8KbZt8x
        zFyBFp7bBSW3J8Wzci8KdPHR1g==
X-Google-Smtp-Source: APXvYqyeYLW2YaKmo1xJfJxB58IOQE39T7c3Z1n8MrWodF2BnuK8nbT7D29rYLyZtNnd4qsV0pqqdw==
X-Received: by 2002:a63:4622:: with SMTP id t34mr21669219pga.0.1571593052820;
        Sun, 20 Oct 2019 10:37:32 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id e192sm13018937pfh.83.2019.10.20.10.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 10:37:32 -0700 (PDT)
Date:   Sun, 20 Oct 2019 10:37:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 0/8] net: hns3: add some cleanups &
 optimizations
Message-ID: <20191020103729.0aebf696@cakuba.netronome.com>
In-Reply-To: <1571472236-17401-1-git-send-email-tanhuazhong@huawei.com>
References: <1571472236-17401-1-git-send-email-tanhuazhong@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Oct 2019 16:03:48 +0800, Huazhong Tan wrote:
> This patchset includes some cleanups and optimizations for the HNS3
> ethernet driver.
> 
> [patch 1/8] removes unused and unnecessary structures.
> 
> [patch 2/8] uses a ETH_ALEN u8 array to replace two mac_addr_*
> field in struct hclge_mac_mgr_tbl_entry_cmd.
> 
> [patch 3/8] optimizes the barrier used in the IO path.
> 
> [patch 4/8] introduces macro ring_to_netdev() to get netdevive
> from struct hns3_enet_ring variable.
> 
> [patch 5/8] makes struct hns3_enet_ring to be cacheline aligned
> 
> [patch 6/8] adds a minor cleanup for hns3_handle_rx_bd().
> 
> [patch 7/8] removes linear data allocating for fraglist SKB.
> 
> [patch 8/8] clears hardware error when resetting.
> 
> ---
> note:
> In previous patchset, there are some bugfixes which needs below
> new feature, which is only in 'net-next' but not in 'net' now:
> net: hns3: support tx-scatter-gather-fraglist feature
> net: hns3: add support for spoof check setting
> 
> So, these bugfixes will be upstreamed when the patch needed is
> on 'net' tree.

Thanks! Looks good to me now.
