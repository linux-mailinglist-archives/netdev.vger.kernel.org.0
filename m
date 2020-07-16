Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92ECA222F74
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgGPX4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgGPX4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:56:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C553A2076D;
        Thu, 16 Jul 2020 23:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594943796;
        bh=m3W4a6mZcGBNErfi0jzmkZeG7pWDxWdwzWchzY8XPx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bt5RY8B63Vhtg9Nd7/RWJ7IE4n3mJaMsVZgg57n4aAH3+zAlIj5HVFxIjfQwAQKtM
         E/gOdCRS+iIn4Kk0TvrgttXo8OLDTMgKSQXXoKZ6oCUHxANQrmr5m1tYv9bMzqxzJb
         f38yyje3hWRrn6Is3FYbddgatNlzsufSBTNdoB74=
Date:   Thu, 16 Jul 2020 16:56:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: Re: [net-next PATCH v2 0/9] Add PRP driver and bug fixes
Message-ID: <20200716165634.5a57d364@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715164012.1222-1-m-karicheri2@ti.com>
References: <20200715164012.1222-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Murali,

thanks for the patches. 

It seems like at least the first patch addresses a problem which exist
in Linus's tree, i.e. Linux 5.8-rc.

Could you please separate bug fixes like that out to a new series
addressed to the net tree, and add appropriate Fixes tags?
