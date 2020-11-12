Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF86A2B1151
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgKLWVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:21:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKLWVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:21:00 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3B5922227;
        Thu, 12 Nov 2020 22:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605219660;
        bh=gLWQTwmaDjkK/PdIdNy3QO7HTB0ZhCkLdFGee2ddIFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BgmbZiLe+MgScSAfI9GsSY692N/i9xK32YzbHS1EOTZTEMlXkXIUqGn2pTz4w3eEF
         /6JF1itWG0UdBU+WAEfqE5Tb3n5yq/SiBsLwgG6T3NCSTCOmeRvGtE09OV2+R25MQw
         vvZ9/n3OqJfDF/iyz1WjC8qPEL66JaT3Hyr1b+M0=
Date:   Thu, 12 Nov 2020 14:20:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     marcelo.leitner@gmail.com, vladbu@nvidia.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict
 packet fragment support.
Message-ID: <20201112142058.61202752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
        <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 11:24:57 +0800 wenxu@ucloud.cn wrote:
> v7-v10: fix __rcu warning 

Are you reposting stuff just to get it build tested?

This is absolutely unacceptable.
