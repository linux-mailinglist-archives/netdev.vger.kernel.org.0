Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FFB339C5
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 22:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfFCUa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 16:30:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34768 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfFCUa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 16:30:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F104B14D70B8A;
        Mon,  3 Jun 2019 13:30:56 -0700 (PDT)
Date:   Mon, 03 Jun 2019 13:30:56 -0700 (PDT)
Message-Id: <20190603.133056.1755579912817273080.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com
Subject: Re: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603144329.16366-1-sameehj@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 13:30:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Mon, 3 Jun 2019 17:43:18 +0300

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This patchset introduces the following:
> 
> * add support for changing the inline header size (max_header_size) for applications
>   with overlay and nested headers
> * enable automatic fallback to polling mode for admin queue when interrupt is not
>   available or missed
> * add good checksum counter for Rx ethtool statistics
> * update ena.txt
> * some minor code clean-up
> * some performance enhancements with doorbell calculations
> 
> Differences from V1:
> 
> * net: ena: add handling of llq max tx burst size (1/11):
>  * fixed christmas tree issue
> 
> * net: ena: ethtool: add extra properties retrieval via get_priv_flags (2/11):
>  * replaced snprintf with strlcpy
>  * dropped confusing error message
>  * added more details to  the commit message

Series applied.
