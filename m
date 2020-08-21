Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B1124DE90
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgHUReF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgHUReD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:34:03 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46CED20702;
        Fri, 21 Aug 2020 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598031243;
        bh=2qDsBcU5fKGwuFBl+QT0kUdzF6jycaxEKjRKIw2bwwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aotIFFgO1PA3morxsaQ6Mk9eleRJSscrejup6/LcrN1KknC77xX54Gz57WqC4s3+P
         EJ+YYUvMgwvksoenbiPC4N32Dn0vN9wJnAZCznwahAiQqDJtbTSKb2rCzdUtlOa3Mw
         QUZzyucuvLzO7o5L9accwk9yd1cWUR0Bc3hJ2jzM=
Date:   Fri, 21 Aug 2020 10:34:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v6 net-next 05/10] qed: health reporter init deinit seq
Message-ID: <20200821103401.50ab4aad@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200820185204.652-6-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
        <20200820185204.652-6-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 21:51:59 +0300 Igor Russkikh wrote:
> Here we declare health reporter ops (empty for now)
> and register these in qed probe and remove callbacks.
> 
> This way we get devlink attached to all kind of qed* PCI
> device entities: networking or storage offload entity.
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
