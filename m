Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F24413F49
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 04:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhIVCOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 22:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhIVCOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 22:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B05610E8;
        Wed, 22 Sep 2021 02:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632276791;
        bh=/VSLMQvR0xx7W4SzgZAxelEATW9AL1OLM9sdObQ2fTw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U+ywfGg9LpT49NN3smYbpxRvyt5Hoj2kEzOY6LU2iQUtZzHGXJqOFLfUdL/ch/Z2x
         SAsiAxwL3M+2YWqIhwFKkFe8Uzr6Izl+1nWWc+HlUZEfMTuxzTlTNCqMuyHmUKJqhM
         0B3PTqVhyWABaa5GuaXns/Bt38J8dv+NoywU3Iyg0jz+Rf/YhVLlZFcHRvkiXsz39D
         /TboH1QoM4YXRXLnsUyRSH+F4BKfiUGhFMq1zEymvike54oQ1GHjCrRPg8gImA+R/c
         mzrGk7BzFwY9zWj3uuOpm0ke5lfZE+RpmTaSvOH5KYHabXdQyxw2zo3SYDOG9hGdfu
         ZypmbOWlAiS7Q==
Date:   Tue, 21 Sep 2021 19:13:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lee.jones@linaro.org>
Subject: Re: [PATCH net] ptp: clockmatrix: use rsmu driver to access i2c/spi
 bus
Message-ID: <20210921191306.34b9c561@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1632251697-1928-1-git-send-email-min.li.xe@renesas.com>
References: <1632251697-1928-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021 15:14:57 -0400 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> rsmu (Renesas Synchronization Management Unit ) driver is located in
> drivers/mfd and responsible for creating multiple devices including
> clockmatrix phc, which will then use the exposed regmap and mutex
> handle to access i2c/spi bus.

I think you meant to post this against the net-next tree.

Please resend with [PATCH net-next] in the subject, the build bot can't
check this since it doesn't apply to net.
