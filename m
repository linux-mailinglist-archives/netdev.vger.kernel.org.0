Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05E09C8E7
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfHZGAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbfHZGAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 02:00:49 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F3D721848;
        Mon, 26 Aug 2019 06:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566799249;
        bh=MxxkKLpj8ULmvofSbv4en0t3TH6JZHRF2MIgGRmlGMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j/9Ff9bKvhMLwhyo98FL1C1rpKT7amLIPZ6SsswsNN+B1o1EB4EqfEC1rzldKf2Qk
         Hi1qZ7oRx8TQYJivM90m8y8gs5f8Us3tCZxqS04i3fiW/izisMoHrV6PXnwDqZo6gW
         XpjFDYNNEkT7jisvhWct2KO12Qpt4jolqRQFpg5s=
Date:   Mon, 26 Aug 2019 09:00:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vasundhara-v.volam@broadcom.com, jiri@mellanox.com,
        ray.jui@broadcom.com
Subject: Re: [PATCH net-next 03/14] bnxt_en: Refactor bnxt_sriov_enable().
Message-ID: <20190826060045.GA4584@mtr-leonro.mtl.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
 <1566791705-20473-4-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566791705-20473-4-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 25, 2019 at 11:54:54PM -0400, Michael Chan wrote:
> Refactor the hardware/firmware configuration portion in
> bnxt_sriov_enable() into a new function bnxt_cfg_hw_sriov().  This
> new function can be called after a firmware reset to reconfigure the
> VFs previously enabled.

I wonder what does it mean for already bound VFs to vfio driver?
Will you rebind them as well? Can I assume that FW error in one VF
will trigger "restart" of other VFs too?

Thanks
