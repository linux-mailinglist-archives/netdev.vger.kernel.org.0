Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58A7D8714
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 06:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391182AbfJPD7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:59:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391171AbfJPD7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:59:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6EE54108B7CF2;
        Tue, 15 Oct 2019 20:59:44 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:59:43 -0700 (PDT)
Message-Id: <20191015.205943.563728623358766810.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bcmgenet: Add a shutdown callback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191015173624.10452-1-f.fainelli@gmail.com>
References: <20191015173624.10452-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:59:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 15 Oct 2019 10:36:24 -0700

> Make sure that we completely quiesce the network device, including its
> DMA to avoid having it continue to receive packets while there is no
> software alive to service those.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
