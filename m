Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3589F186538
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 07:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgCPGtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 02:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbgCPGtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 02:49:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CCFC20674;
        Mon, 16 Mar 2020 06:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584341392;
        bh=+dcUeMrqmKmfdmJS6N9Yfqs/Q2ZViUYs3pQMA4vqaVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IWHU1YlXYRAyDaMFEOjVlseuPg1W639UcznsOBnfg2fm1kHPO8KnU61IDLcQfPuOd
         iTsZl+zZ6eRquT96bAS76cP1pDH+/kNavDl6FzsEwzOuiY9w5aF2IBRoGAHP0AxW12
         Swinfy0yeb+O15yvMdbj9bT+2D1oSoUj1Q6zARjU=
Date:   Mon, 16 Mar 2020 08:49:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 5/5] ionic: add decode for IONIC_RC_ENOSUPP
Message-ID: <20200316064948.GB8510@unreal>
References: <20200316021428.48919-1-snelson@pensando.io>
 <20200316021428.48919-6-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316021428.48919-6-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 07:14:28PM -0700, Shannon Nelson wrote:
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_main.c | 3 +++
>  1 file changed, 3 insertions(+)
>

Please try to refrain from patches with empty commit messages.
See submitting-patches guide, section about canonical patch format.
https://elixir.bootlin.com/linux/latest/source/Documentation/process/submitting-patches.rst#L665

Thanks
