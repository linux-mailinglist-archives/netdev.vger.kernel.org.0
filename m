Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AE3233C37
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgG3XjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgG3XjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:39:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5440F20829;
        Thu, 30 Jul 2020 23:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596152345;
        bh=SvS/XCiOujXAhARua2c/qZzQDkWcOIx8TMvOXmq2or4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OgWM8vR492lr7jG2x3ns/3t2txQf8S11GtACTJKKTOJK2qXko6UnAoDLjEugUFPtu
         hBsdMBRo8AmSPyYnuntgeKS/eCHD5dQqPU+HTDBAml8j3+fGfskg4asGvEwPYvmAqQ
         OR3pmCorDtALTuZgdbkqyruW10/Wham2qGWzUnl4=
Date:   Thu, 30 Jul 2020 16:39:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH net-next 0/4] s390/qeth: updates 2020-07-30
Message-ID: <20200730163903.002a49d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200730150121.18005-1-jwi@linux.ibm.com>
References: <20200730150121.18005-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020 17:01:17 +0200 Julian Wiedmann wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series for qeth to netdev's net-next tree.
> 
> This primarily brings some modernization to the RX path, laying the
> groundwork for smarter RX refill policies.
> Some of the patches are tagged as fixes, but really target only rare /
> theoretical issues. So given where we are in the release cycle and that we
> touch the main RX path, taking them through net-next seems more appropriate.

First 2 patches look good to me:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
