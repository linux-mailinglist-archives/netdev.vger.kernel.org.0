Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D927175705
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfGYSez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:34:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfGYSez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:34:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87B1D1434E354;
        Thu, 25 Jul 2019 11:34:54 -0700 (PDT)
Date:   Thu, 25 Jul 2019 11:34:53 -0700 (PDT)
Message-Id: <20190725.113453.1170410853110888774.davem@davemloft.net>
To:     leon@kernel.org
Cc:     leonro@mellanox.com, dledford@redhat.com, jgg@mellanox.com,
        linux-rdma@vger.kernel.org, talgi@mellanox.com,
        yaminf@mellanox.com, saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] DIM fixes for 5.3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723072248.6844-1-leon@kernel.org>
References: <20190723072248.6844-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 11:34:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Tue, 23 Jul 2019 10:22:46 +0300

> Those two fixes for recently merged DIM patches, both exposed through
> RDMa DIM usage.

Series applied.
