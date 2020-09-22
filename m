Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3279C273A69
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 07:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgIVFyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 01:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgIVFyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 01:54:43 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAD9623A9B;
        Tue, 22 Sep 2020 05:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600754083;
        bh=qinHNa98lV8Vbex+es8YwI6s9Zh4TPeJErHxYKfr41E=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=pjDKcZ4OtrGP7QNOPqlZ9fFJkM46FuvH3PMLX316DxHEfz9GAJ4Xy3XH0eiyxKr7k
         Jw/Ox28kvFvFlwen7/ZVA0Z65qOZpRrxGtuP3qXHg190hWVU7Dzh1K/B76XFYhsZ2K
         VDT6Lma3m2A+ebXtOiAjZ1rg7HgurHBoKlFHlp9c=
Message-ID: <5d37fdcb0d50d79f93e8cdb31cb3f182548ffcc1.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5: remove unreachable return
From:   Saeed Mahameed <saeed@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>, eranbe@mellanox.com,
        lariel@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 21 Sep 2020 22:54:41 -0700
In-Reply-To: <20200921114103.GA21071@duo.ucw.cz>
References: <20200921114103.GA21071@duo.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-21 at 13:41 +0200, Pavel Machek wrote:
> The last return statement is unreachable code. I'm not sure if it
> will
> provoke any warnings, but it looks ugly.
>     
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> 

Applied to net-next-mlx5.

Thanks,
Saeed.

