Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2F1274786
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIVRdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgIVRdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 13:33:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C56CB22206;
        Tue, 22 Sep 2020 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600795993;
        bh=9ibXDw+mz2QyfRLC7VIAPmBs3Hdm/qokhlQTYYE64DI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JWMsgN+3t2S3/EGk8dCBAVzkiCm//4yPct9hwZehZaGm4DuV4YHoZQKY2Ys7LyZN0
         1rJEjfdHPFbATbdavqZaz4P/ymVNZ4AedBB5s8TUFCvFUuNd577zd0oLQ7aakDSzzp
         ahPrVZpmp7Wgb4YcLBdpV94k8LuQ/eSXs/ZFRGC4=
Date:   Tue, 22 Sep 2020 10:33:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v2 2/3] gve: Add support for raw addressing to
 the rx path
Message-ID: <20200922103311.5db13ae1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200922155100.1624976-3-awogbemila@google.com>
References: <20200922155100.1624976-1-awogbemila@google.com>
        <20200922155100.1624976-3-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 08:50:59 -0700 David Awogbemila wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> Add support to use raw dma addresses in the rx path. Due to this new
> support we can alloc a new buffer instead of making a copy.
> 
> RX buffers are handed to the networking stack and are then recycled or
> re-allocated as needed, avoiding the need to use
> skb_copy_to_linear_data() as in "qpl" mode.

Please separate page recycling into a separate commit.
