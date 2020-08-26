Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5197D25397C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 23:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgHZVBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 17:01:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:32934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbgHZVBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 17:01:21 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 164EC20737;
        Wed, 26 Aug 2020 21:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598475681;
        bh=GD6OvGa4Wp+R3OcV8g1tkgRHdjhiBkmffqfJCfxqQN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jgtmRCnGwoEaBLFymhvzpnr6wYBb1xT7kGgQ+kJ/Jg7IeDdAhx+pd7gMadyT5zh8p
         6DqjwSfRZhNagAhIdyyYeNczwLzZT8zSddIatAipTStX7fa9QGFY4FX5c4dKn8m5wO
         9P5QeF+lk5x+PgA/ikUF29umtYlp3jthX098Xj0c=
Date:   Wed, 26 Aug 2020 14:01:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 07/12] ionic: reduce contiguous memory
 allocation requirement
Message-ID: <20200826140119.3a241b0b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200826164214.31792-8-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
        <20200826164214.31792-8-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Aug 2020 09:42:09 -0700 Shannon Nelson wrote:
> +	q_base = (void *)ALIGN((uintptr_t)new->q_base, PAGE_SIZE);

PTR_ALIGN()
