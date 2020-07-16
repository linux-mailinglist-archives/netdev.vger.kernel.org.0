Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532BB22191E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 02:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgGPAxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 20:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGPAxy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 20:53:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE5E520658;
        Thu, 16 Jul 2020 00:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594860834;
        bh=5SfCsBhyh5PKiykxkZLei29fsfceunyloFYOBrhtjsM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cYv56p7Bxny0O7PoNFhQ8XDqOjTviIN1L118CGFdkC7VN9nrym45kPOHNgRH1hkbf
         rRDQEAmXTxzKRwaT5v8Kfh0doBYxFhuVI7h511xvZSLvOskEJnTAsiYCwVlsvDuBX6
         B9YJQYZdwgKZQn9QO1YvFhMTw1MqifOLA2cPb61I=
Date:   Wed, 15 Jul 2020 17:53:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        richardcochran@gmail.com, sorganov@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH v2 net-next] docs: networking: timestamping: add section
 for stacked PHC devices
Message-ID: <20200715175352.51f9df14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709201733.71874-1-olteanv@gmail.com>
References: <20200709201733.71874-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 23:17:33 +0300 Vladimir Oltean wrote:
> The concept of timestamping DSA switches / Ethernet PHYs is becoming
> more and more popular, however the Linux kernel timestamping code has
> evolved quite organically and there's layers upon layers of new and old
> code that need to work together for things to behave as expected.
> 
> Add this chapter to explain what the overall goals are.
> 
> Loosely based upon this email discussion plus some more info:
> https://lkml.org/lkml/2020/7/6/481
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Richard Cochran <richardcochran@gmail.com>

Applied, thanks!
