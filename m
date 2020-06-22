Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7326120441A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbgFVWzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbgFVWzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:55:39 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B827520738;
        Mon, 22 Jun 2020 22:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592866538;
        bh=h7RUpMkxSs5oqYIjSxvm8eVvmxdwLGf66PVYhuB3+uE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nd6w3W6ndCAdPCSJHdWe/uWbTnrELTjzHiOTYik+rX5PH+RkHNUYjGqavhG6yikky
         vaRPtiiRaq615ktjdq98fFJMvLnOudSBW2ds6otXmYVBC1k7vW+DoRU7h/r219di2a
         JwtKLQo1qTcg/5UqRUzQPl2mA1z+INqtfMbWwoJA=
Date:   Mon, 22 Jun 2020 15:55:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: Re: [PATCH net-next 0/6] net: atlantic: additional A2 features
Message-ID: <20200622155537.27913c0b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200622145309.455-1-irusskikh@marvell.com>
References: <20200622145309.455-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jun 2020 17:53:03 +0300 Igor Russkikh wrote:
> This patchset adds more features to A2:
>  * half duplex rates;
>  * EEE;
>  * flow control;
>  * link partner capabilities reporting;
>  * phy loopback.
> 
> Feature-wise A2 is almost on-par with A1 save for WoL and filtering, which
> will be submitted as separate follow-up patchset(s)

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
