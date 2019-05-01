Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4928810CB4
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 20:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfEASd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 14:33:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37484 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfEASd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 14:33:56 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00B4A126474C3;
        Wed,  1 May 2019 11:33:51 -0700 (PDT)
Date:   Wed, 01 May 2019 14:33:50 -0400 (EDT)
Message-Id: <20190501.143350.1670159610613632442.davem@davemloft.net>
To:     esben@geanix.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, mcgrof@kernel.org, yang.wei9@zte.com.cn,
        yuehaibing@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/12] net: ll_temac: x86_64 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430071759.2481-1-esben@geanix.com>
References: <20190429083422.4356-1-esben@geanix.com>
        <20190430071759.2481-1-esben@geanix.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 11:33:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>
Date: Tue, 30 Apr 2019 09:17:47 +0200

> This patch series adds support for use of ll_temac driver with
> platform_data configuration and fixes endianess and 64-bit problems so
> that it can be used on x86_64 platform.
> 
> A few bugfixes are also included.

Series applied to net-next.
