Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B323D1B517D
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 02:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgDWArb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 20:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgDWArb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 20:47:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B89B12075A;
        Thu, 23 Apr 2020 00:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587602851;
        bh=EdmzjYQAhQBVBR9t2tWCV6yN4tV++RbsoY2zjZRMtJs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aJL0WFBg/4XtuN2ksYY4V1rCo5ZXiFV5qUNFvOAVWhioMr+45B5x+ju6JxR+3ecxw
         94OhGT3rIy0K3ZxvMMfCp/UZ9YWGnk7V2E6R+SAjFbxa4nDv1WzxGM5AhnC3rfyI/F
         xB8tN7fMIxTBcEhefSxP2PCNq05ehRcVvl/okyhU=
Date:   Wed, 22 Apr 2020 17:47:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: Re: [PATCH V1 net-next 08/13] net: ena: add support for reporting
 of packet drops
Message-ID: <20200422174729.19fae03f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200422081628.8103-9-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
        <20200422081628.8103-9-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 08:16:23 +0000 sameehj@amazon.com wrote:
> From: Sameeh Jubran <sameehj@amazon.com>
> 
> 1. Add support for getting tx drops from the device and saving them
> in the driver.
> 2. Report tx and rx drops via ethtool.
> 3. Report tx via netdev stats.

Please don't duplicate what's already reported in standard stats in
ethtool -S.
