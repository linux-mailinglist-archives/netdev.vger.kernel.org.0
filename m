Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640C428F8AB
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbgJOScb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728820AbgJOScb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 14:32:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E3AC2073A;
        Thu, 15 Oct 2020 18:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602786750;
        bh=Kpud85qELF40vnqk+B5Z67jKUhtJC7jAEuZLwQUo2ng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZF6+fyQfRDzHVgq/5QDBU7R1OHiB2CtW2sIdIOguX1KmtBmohza7OYBiwZvo/2p6y
         3GHNe1JkExp/ue/D/2wrZVdOs5FUcrEVYut4VXvGut1YgvtCjeSe5W026FEotPg/vN
         Ljg9ZkqaqOFO5SzNdsgy3xQ+Tsq3OZdk2EZOoGB8=
Date:   Thu, 15 Oct 2020 11:32:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v4 2/4] gve: Add support for raw addressing to
 the rx path
Message-ID: <20201015113228.4650680e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014222715.83445-3-awogbemila@google.com>
References: <20201014222715.83445-1-awogbemila@google.com>
        <20201014222715.83445-3-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 15:27:13 -0700 David Awogbemila wrote:
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index 008fa897a3e6..47d0687aa20a 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -6,6 +6,7 @@
>  
>  #include "gve.h"
>  #include "gve_adminq.h"
> +#include "linux/device-mapper.h"
>  #include <linux/etherdevice.h>

Why are you including the device mapper?
