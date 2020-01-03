Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C897912F233
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgACAbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:31:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55782 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:31:41 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7121815728C58;
        Thu,  2 Jan 2020 16:31:41 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:31:41 -0800 (PST)
Message-Id: <20200102.163141.1473240611016870659.davem@davemloft.net>
To:     Julia.Lawall@inria.fr
Cc:     madalin.bucur@nxp.com, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] fsl/fman: use resource_size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577900990-8588-5-git-send-email-Julia.Lawall@inria.fr>
References: <1577900990-8588-1-git-send-email-Julia.Lawall@inria.fr>
        <1577900990-8588-5-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:31:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julia Lawall <Julia.Lawall@inria.fr>
Date: Wed,  1 Jan 2020 18:49:44 +0100

> Use resource_size rather than a verbose computation on
> the end and start fields.
> 
> The semantic patch that makes these changes is as follows:
> (http://coccinelle.lip6.fr/)
> 
> <smpl>
> @@ struct resource ptr; @@
> - (ptr.end + 1 - ptr.start)
> + resource_size(&ptr)
> 
> @@ struct resource *ptr; @@
> - (ptr->end + 1 - ptr->start)
> + resource_size(ptr)
> </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Applied to net-next.

Thanks Julia.
