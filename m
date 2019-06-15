Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E6646DDD
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfFOCl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:41:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57636 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFOCl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:41:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A14881254E0CC;
        Fri, 14 Jun 2019 19:41:58 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:41:58 -0700 (PDT)
Message-Id: <20190614.194158.1580252220317832150.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org, toke@toke.dk,
        tariqt@mellanox.com, toshiaki.makita1@gmail.com,
        grygorii.strashko@ti.com, ivan.khoronzhuk@linaro.org,
        mcroce@redhat.com
Subject: Re: [PATCH net-next v1 00/11] xdp: page_pool fixes and in-flight
 accounting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156045046024.29115.11802895015973488428.stgit@firesoul>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:41:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 13 Jun 2019 20:28:01 +0200

> This patchset fix page_pool API and users, such that drivers can use it for
> DMA-mapping.
 ...

Please address the minor nits and respin and I'll apply this.

Thanks.
