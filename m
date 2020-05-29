Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB0F1E876E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgE2TOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgE2TOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 15:14:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C28C03E969;
        Fri, 29 May 2020 12:14:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 700F3128166EC;
        Fri, 29 May 2020 12:14:44 -0700 (PDT)
Date:   Fri, 29 May 2020 12:14:41 -0700 (PDT)
Message-Id: <20200529.121441.2114086642433348007.davem@davemloft.net>
To:     doshir@vmware.com
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] vmxnet3: use correct hdr reference when
 packet is encapsulated
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529025352.786-1-doshir@vmware.com>
References: <20200529025352.786-1-doshir@vmware.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 12:14:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ronak Doshi <doshir@vmware.com>
Date: Thu, 28 May 2020 19:53:52 -0700

> 'Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
> support")' added support for encapsulation offload. However, while
> preparing inner tso packet, it uses reference to outer ip headers.
> 
> This patch fixes this issue by using correct reference for inner
> headers.
> 
> Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
> Signed-off-by: Ronak Doshi <doshir@vmware.com>

Applied.
