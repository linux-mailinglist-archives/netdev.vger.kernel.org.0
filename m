Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944DC26E866
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 00:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIQWar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 18:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgIQWar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 18:30:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D404C2064B;
        Thu, 17 Sep 2020 22:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600381847;
        bh=ibaysV44jMPsE3MQFwPYlK+xmlXm8IhXSjW1aIde7Qo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oYt+2QeqFzcSY06zW/1qG8f1Rbrz6dqTd/Tuy+ibgBCx71mZmsFmdIWRwsdNepuGk
         UXj0SM09jXWO9twYo7GsP4jq09BONb9Zc+4hKbLMdD94OwYizB4Qeuy9ACmhnIdWKd
         9oZKxwhVQqiLs2vXDQP03TBMb+uXyHMzhBYPs964=
Date:   Thu, 17 Sep 2020 15:30:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Srujana Challa <schalla@marvell.com>
Cc:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>
Subject: Re: [PATCH v3,net-next,0/4] Add Support for Marvell OcteonTX2
 Cryptographic
Message-ID: <20200917153044.7123aabc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200917132835.28325-1-schalla@marvell.com>
References: <20200917132835.28325-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 18:58:31 +0530 Srujana Challa wrote:
> The following series adds support for Marvell Cryptographic Acceleration
> Unit(CPT) on OcteonTX2 CN96XX SoC.
> This series is tested with CRYPTO_EXTRA_TESTS enabled and
> CRYPTO_DISABLE_TESTS disabled.

No writeable debugfs files, please.

Please provide more information about how users are going to make use
of the functionality and what the capabilities are. You add 10K LoC 
and patches barely have barely a commit message.
