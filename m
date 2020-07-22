Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0AD229DBD
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731480AbgGVRER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgGVREQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 13:04:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D468206F5;
        Wed, 22 Jul 2020 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595437456;
        bh=sFfeeAJ6hZhq5ZRZbGt9R4XjP5lNgXgiXOuKYFr338E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sFzKWumrU4lZc40uflxwKDbVMe8HKeLBNHh4ayzT6L8/w0Y4X9g+9ILZokru3mzRY
         avne6VNIsS8TtZ8h7cwyrFMhNJNZSJFF1ccsxej2g1ac+HPBovw7CXYWAJ+1zmFPYl
         HD7gMY74Iorapq0Zmv+Qwm0cSdSZcqqCqmLIlxNg=
Date:   Wed, 22 Jul 2020 10:04:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com
Subject: Re: [PATCH net-next v2] cxgb4: add loopback ethtool self-test
Message-ID: <20200722100414.6e4e07ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200722135844.7432-1-vishal@chelsio.com>
References: <20200722135844.7432-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 19:28:44 +0530 Vishal Kulkarni wrote:
> In this test, loopback pkt is created and sent on default queue.
> 
> v2:
> - Add only loopback self-test.

Thanks for dropping the rest of the patches. Is it worth specifying
what level of loopback this test is? PCI / MAC / PHY / other?
