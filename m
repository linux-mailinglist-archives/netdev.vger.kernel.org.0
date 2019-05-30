Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952003018D
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfE3SMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:12:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56520 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3SMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:12:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C48814D8BB6B;
        Thu, 30 May 2019 11:12:35 -0700 (PDT)
Date:   Thu, 30 May 2019 11:12:34 -0700 (PDT)
Message-Id: <20190530.111234.228447416363288012.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     saeedm@mellanox.com, jasowang@redhat.com, brouer@redhat.com,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        sthemmin@microsoft.com
Subject: Re: [PATCH PATCH v4 0/2] XDP generic fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528184731.7464-1-sthemmin@microsoft.com>
References: <20190528184731.7464-1-sthemmin@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:12:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Tue, 28 May 2019 11:47:29 -0700

> This set of patches came about while investigating XDP
> generic on Azure. The split brain nature of the accelerated
> networking exposed issues with the stack device model.

Series applied.
