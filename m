Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F4E20689D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387647AbgFWXrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731990AbgFWXrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 19:47:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C797320780;
        Tue, 23 Jun 2020 23:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592956032;
        bh=sbwFeWd36wBwHvKRl+Dc2tGqh12fOKqg+gfbDmDR+4o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pt9CClq9XYkfel7xWnh0DDiTfhprFF4xkj0WMBuoom81qPCuzLoR3SGKqph+iAeXW
         PJlP51KMhfgnKWh8SBp5Tf3wNyldeut9ztZW/6AX2cHur0lronk3JkLmAL4dfnyad0
         /f5e9Zeufrycg0jelGzi08sReX8ZkOq55LNeeyi8=
Date:   Tue, 23 Jun 2020 16:47:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/4] bnxt_en: Do not enable legacy TX push on older
 firmware.
Message-ID: <20200623164710.5719438e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1592953298-20858-3-git-send-email-michael.chan@broadcom.com>
References: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
        <1592953298-20858-3-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 19:01:36 -0400 Michael Chan wrote:
> Older firmware may not support legacy TX push properly and may not
> be disabling it.  So we check certain firmware versions that may
> have this problem and disable legacy TX push unconditionally.

For the future this commit message should have been clearer on user
impact. What are the symptoms? Will the TX hang because of this? 
Will the performance be low?
