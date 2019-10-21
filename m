Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306CCDF45B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfJURgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 13:36:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfJURgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 13:36:43 -0400
Received: from localhost (unknown [4.14.35.89])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 568021411B0DE;
        Mon, 21 Oct 2019 10:36:42 -0700 (PDT)
Date:   Mon, 21 Oct 2019 10:36:39 -0700 (PDT)
Message-Id: <20191021.103639.726699695480790734.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH v5 net-next 0/7] add XDP support to mvneta driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1571472169.git.lorenzo@kernel.org>
References: <cover.1571472169.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Oct 2019 10:36:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 19 Oct 2019 10:13:20 +0200

> Add XDP support to mvneta driver for devices that rely on software
> buffer management. Supported verdicts are:
> - XDP_DROP
> - XDP_PASS
> - XDP_REDIRECT
> - XDP_TX
> Moreover set ndo_xdp_xmit net_device_ops function pointer in order
> to support redirecting from other device (e.g. virtio-net).
> Convert mvneta driver to page_pool API.
> This series is based on previous work done by Jesper and Ilias.
> We will send follow-up patches to reduce DMA-sync operations.
 ...

Series applied, thank you.
