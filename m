Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8721C9C4E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgEGU0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGU0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:26:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB9CC05BD43;
        Thu,  7 May 2020 13:26:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D58481194F0E1;
        Thu,  7 May 2020 13:26:46 -0700 (PDT)
Date:   Thu, 07 May 2020 13:26:46 -0700 (PDT)
Message-Id: <20200507.132646.1593649729884576295.davem@davemloft.net>
To:     chenzhou10@huawei.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: ipa: remove duplicate headers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507133945.25601-1-chenzhou10@huawei.com>
References: <20200507133945.25601-1-chenzhou10@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:26:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Zhou <chenzhou10@huawei.com>
Date: Thu, 7 May 2020 21:39:45 +0800

> Remove duplicate headers which are included twice.
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>

The net-next tree already has this fixed.
