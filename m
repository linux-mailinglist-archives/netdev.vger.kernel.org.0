Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B891B13DA
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgDTSEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgDTSEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:04:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E81C061A0C;
        Mon, 20 Apr 2020 11:04:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EC0C127D24B0;
        Mon, 20 Apr 2020 11:04:46 -0700 (PDT)
Date:   Mon, 20 Apr 2020 11:04:45 -0700 (PDT)
Message-Id: <20200420.110445.663501904731751915.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     richardcochran@gmail.com, pbonzini@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ptp_kvm: Make kvm_ptp_lock static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200418015154.45976-1-yuehaibing@huawei.com>
References: <20200418015154.45976-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 11:04:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 18 Apr 2020 09:51:54 +0800

> Fix sparse warning:
> 
> drivers/ptp/ptp_kvm.c:25:1: warning:
>  symbol 'kvm_ptp_lock' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
