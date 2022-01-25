Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35B949B7EC
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 16:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582391AbiAYPrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 10:47:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50476 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356552AbiAYPpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 10:45:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73C7A61708;
        Tue, 25 Jan 2022 15:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D28C340E8;
        Tue, 25 Jan 2022 15:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643125513;
        bh=CcIRjfm17aVakeeVnaDmo1N/8z0dKUqDwIOCF455pyg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PzdVvAi+XKWBtlAo5HeCx7ZHwYJbZQti60n0ZrEtI+d4JBsSQ5AwRR6lMIYnMjYrC
         wkpZ9/oLtxf7lblkl2jlbwO6hzrCZpZGHtB81cY1rfoC4ZhBwuImj52ynbKWr9Eww5
         pz1u/LklUez7FC4055Mq/DvOfYNzM0/45E//yBMRZHpnNmkFAoPVZbrwSAEl0aQ+Zf
         IrIF4sAiXT2oceh/uclpaCPoQj9c2mKYACQTQ1JO9TOXHuAuujH0p7lsKTZHNLh8V2
         6dByHdZT57tNcmD9DdUZJ+X8YURpRJ49bCkEmWVlpdfQDyvRsA5hfCeJaS0RTgCF01
         gwCsfmW6MwheA==
Date:   Tue, 25 Jan 2022 07:45:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Colin Ian King <colin.i.king@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tulip: remove redundant assignment to variable
 new_csr6
Message-ID: <20220125074512.73cc5cec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125141401.GV1951@kadam>
References: <20220123183440.112495-1-colin.i.king@gmail.com>
        <20220124103038.76f15516@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220125141401.GV1951@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 17:14:01 +0300 Dan Carpenter wrote:
> You're looking at the wrong function.  This is pnic_do_nway() and you're
> looking at pnic_timer().

Ah, that explains it! Thanks, applied now.

> Of course, Colin's patch assumes the current behavior is correct...  I
> guess the current behavior can't be that terrible since it predates git
> and no one has complained.

Entirely possible this driver was never used in the git era.
