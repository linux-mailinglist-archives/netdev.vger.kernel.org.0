Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6991C9BA1
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgEGUGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbgEGUGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:06:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F81C05BD43;
        Thu,  7 May 2020 13:06:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1FE9A119504E1;
        Thu,  7 May 2020 13:06:11 -0700 (PDT)
Date:   Thu, 07 May 2020 13:06:10 -0700 (PDT)
Message-Id: <20200507.130610.2218488895332459354.davem@davemloft.net>
To:     Po.Liu@nxp.com
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, dan.carpenter@oracle.com,
        claudiu.manoil@nxp.com
Subject: Re: [net-next] net:enetc: bug fix for qos sfi operate space after
 freed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507105738.29961-1-Po.Liu@nxp.com>
References: <20200507105738.29961-1-Po.Liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:06:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <Po.Liu@nxp.com>
Date: Thu,  7 May 2020 18:57:38 +0800

> 'Dan Carpenter' reported:
> This code frees "sfi" and then dereferences it on the next line:
>>                 kfree(sfi);
>>                 clear_bit(sfi->index, epsfp.psfp_sfi_bitmap);
> 
> This "sfi->index" should be "index".
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Po Liu <Po.Liu@nxp.com>

Applied.
