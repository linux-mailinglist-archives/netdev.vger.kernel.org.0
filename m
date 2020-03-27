Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D719195D01
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgC0RkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgC0RkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 13:40:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EFBC206F1;
        Fri, 27 Mar 2020 17:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585330801;
        bh=oZrY6Vd6EhJoBxvZFvYtZLJ/SeVENhiTZxJxBDy+btM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SXzv6FWFW4ujnh9piNSZWErKCdVRv6XKItJ21rr8vsPzLMvezw7m+4MPiu4mpmRng
         5MxVNVfdPVU94Px+cjfIr2JedmQRwWaqJ+94ssx3wHNF/LtznDx8mn8WhEZO4TwIVe
         yVoFfhEaHkJQ8sOhSNR8ealH001UMPUJa3leGGy8=
Date:   Fri, 27 Mar 2020 10:39:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/6] bnxt_en: Updates to devlink info_get cb
Message-ID: <20200327103959.60692e7a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1585301692-25954-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585301692-25954-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 15:04:50 +0530 Vasundhara Volam wrote:
> This series adds support for a generic macro to devlink info_get cb.
> Adds support for fw.mgmt.api and board.id info to bnxt_en driver info_get
> cb. Also, updates the devlink-info.rst and bnxt.rst documentation
> accordingly.
> 
> This series adds a patch to fix few macro names that maps to bnxt_en
> firmware versions.

Great, thank you!

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
