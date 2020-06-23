Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1ED204889
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 06:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbgFWELB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 00:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgFWELA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 00:11:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A26C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 21:11:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A6E31210BB97;
        Mon, 22 Jun 2020 21:11:00 -0700 (PDT)
Date:   Mon, 22 Jun 2020 21:10:59 -0700 (PDT)
Message-Id: <20200622.211059.1719425362483428714.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, mstarovoitov@marvell.com
Subject: Re: [PATCH net-next 0/6] net: atlantic: additional A2 features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200622145309.455-1-irusskikh@marvell.com>
References: <20200622145309.455-1-irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 21:11:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Mon, 22 Jun 2020 17:53:03 +0300

> This patchset adds more features to A2:
>  * half duplex rates;
>  * EEE;
>  * flow control;
>  * link partner capabilities reporting;
>  * phy loopback.
> 
> Feature-wise A2 is almost on-par with A1 save for WoL and filtering, which
> will be submitted as separate follow-up patchset(s).

Series applied, thank you.
