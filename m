Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CC71D8C5E
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgESAf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgESAfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:35:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AC5C061A0C;
        Mon, 18 May 2020 17:35:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40D2612765131;
        Mon, 18 May 2020 17:35:25 -0700 (PDT)
Date:   Mon, 18 May 2020 17:35:24 -0700 (PDT)
Message-Id: <20200518.173524.1936417656093227828.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: move the SIOCDELRT and SIOCADDRT compat_ioctl handlers v3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200518062808.756610-1-hch@lst.de>
References: <20200518062808.756610-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 May 2020 17:35:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Mon, 18 May 2020 08:28:04 +0200

> this series moves the compat_ioctl handlers into the protocol handlers,
> avoiding the need to override the address space limited as in the current
> handler.
> 
> Changes since v3:
>  - moar variable reordering
> 
> Changes since v1:
>  - reorder a bunch of variable declarations

Series applied to net-next, thank you.
