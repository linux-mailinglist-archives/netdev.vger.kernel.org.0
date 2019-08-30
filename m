Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFBA3A3390
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfH3JSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbfH3JSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 05:18:43 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C71123426;
        Fri, 30 Aug 2019 09:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567156722;
        bh=IAUSTF9TEBfRDzY8p26O+nFVOIg/dmdQKrX677szCsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KvUTyY+ofw8twJEGz6lZViriMqU4cvg5i9CVxZHergp7tep/DZt7FlqMki8UNUD+o
         3sDieMdcHFfgwRHGuc/W0zPZ0sTHDUAVYvAYV+umXCoJY1ROXNQCy81AmcTydIMfUb
         rUVR8IyyJUVAKwYQW6u67fRR/kIFcMSyqu2SQ0WU=
Date:   Fri, 30 Aug 2019 12:18:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vasundhara-v.volam@broadcom.com, jiri@mellanox.com,
        ray.jui@broadcom.com
Subject: Re: [PATCH net-next 03/14] bnxt_en: Refactor bnxt_sriov_enable().
Message-ID: <20190830091838.GC12611@unreal>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
 <1566791705-20473-4-git-send-email-michael.chan@broadcom.com>
 <20190826060045.GA4584@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826060045.GA4584@mtr-leonro.mtl.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 09:00:45AM +0300, Leon Romanovsky wrote:
> On Sun, Aug 25, 2019 at 11:54:54PM -0400, Michael Chan wrote:
> > Refactor the hardware/firmware configuration portion in
> > bnxt_sriov_enable() into a new function bnxt_cfg_hw_sriov().  This
> > new function can be called after a firmware reset to reconfigure the
> > VFs previously enabled.
>
> I wonder what does it mean for already bound VFs to vfio driver?
> Will you rebind them as well? Can I assume that FW error in one VF
> will trigger "restart" of other VFs too?

Care to reply?


hanks

>
> Thanks
