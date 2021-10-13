Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA1442C02C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 14:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhJMMi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 08:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbhJMMiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 08:38:16 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF173C061570;
        Wed, 13 Oct 2021 05:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fV9peFlO4DUJLbO4CO9iO7X9j5LReCBT4N9P5VA0/+8=; b=UFmPeZsEQbq4JZ6BB6P/oc5MiB
        eFuZ8G5HP5fh+qPoGHdWkUeCJXhkBORYR/Rlcne3hmhKeoOX6KIRfpvfCXlql9UCCjbC/L/fcLbnT
        0PpDICr9KMgVEDCKzA3ArnJ4cZnrzYaw4/qrV0hxTceUSyP/gZA10NOb6WnuOOdNASO0bqXL/ytTc
        G8jNtRduVAPqM8ZczldCKuXyMF8CKYF0xGIcKY/hJXPAPb4WmT5ut4eDRw4x+MmDVjsTIJFDHeMMI
        JV3HIvZZRkNk8uvP3D7Uv8I/MInqNxTRdB+qHAteMvsbQVdr8pTMadd368I4b4AmXxc0BivyFK2UC
        JvYo3YMg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1madUQ-00GbDm-IK; Wed, 13 Oct 2021 12:36:10 +0000
Date:   Wed, 13 Oct 2021 05:36:10 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: ath5k: replace snprintf in show functions with
 sysfs_emit
Message-ID: <YWbSuuvR7HlPqjJG@bombadil.infradead.org>
References: <1634095651-4273-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1634095651-4273-1-git-send-email-wangqing@vivo.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 08:27:31PM -0700, Qing Wang wrote:
> coccicheck complains about the use of snprintf() in sysfs show functions.
> 
> Fix the coccicheck warning:
> WARNING: use scnprintf or sprintf.
> 
> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
> 
> Signed-off-by: Qing Wang <wangqing@vivo.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
