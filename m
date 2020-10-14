Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986D428E8FF
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgJNXAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgJNXAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:00:45 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD27520776;
        Wed, 14 Oct 2020 23:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602716445;
        bh=0yFMeVxJSFee7hyJocT4ZeyIzid2yFVT0Ff0q160Phs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ABAN+jQI6eY+2CZX08Qe77LK0AYi1r7zx0qpx+ByTBpx0RHsQ1BLv1G6wM8wTWZai
         ULHDEwQ9euZZbap3Mg2fN5DPEElL2H6ME5hmAIzb3M5KIcNiNey9rSjexhkodJIHQO
         6cv9yjqDGrkWy2SVioRuq1VHiG9s99ymIM0OkV0w=
Date:   Wed, 14 Oct 2020 16:00:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 04/10] bridge: cfm: Kernel space
 implementation of CFM. MEP create/delete.
Message-ID: <20201014160042.4967a702@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012140428.2549163-5-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
        <20201012140428.2549163-5-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 14:04:22 +0000 Henrik Bjoernlund wrote:
> with restricted management access to each other<E2><80><99>s equipment.

Some Unicode funk in this line?
