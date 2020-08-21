Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2B924DE95
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgHURfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgHURfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:35:00 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C4E420702;
        Fri, 21 Aug 2020 17:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598031299;
        bh=GzkFByxY1b4Op3xm41k14aceQDgTPbbFHP9Qp3EAiBA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0MFlncaVzB5eIsMQVajfl/5QD8X58A24LDHthsz34RlD1hXnB+xtrUnVfZg7g4o3D
         apWdgahdr8T36BUIEOm8oeVQuoAspKj5n4Kj0ayITugEkTzczEW+bHLqDOjoIvXWwv
         qVhFKQvNdXSCtKVlIwrzVwixWJ07am5VPBCO2a7w=
Date:   Fri, 21 Aug 2020 10:34:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v6 net-next 06/10] qed: use devlink logic to report
 errors
Message-ID: <20200821103458.269e68c7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200820185204.652-7-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
        <20200820185204.652-7-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 21:52:00 +0300 Igor Russkikh wrote:
> Use devlink_health_report to push error indications.
> We implement this in qede via callback function to make it possible
> to reuse the same for other drivers sitting on top of qed in future.

Acked-by: Jakub Kicinski <kuba@kernel.org>
