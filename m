Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911C828E91C
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgJNXQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727567AbgJNXQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:16:13 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2841020776;
        Wed, 14 Oct 2020 23:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602717372;
        bh=2d5aAUYPl3e685Wtq1LeFikIS8MayVnNbjd2tNE9i9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Iz0fyNozvpie0bXmK4hoQHzraMjPyvp0QW3mT+3Ti1faJvaOcW4gPqXzwNQDry8H9
         1jEo7vI+K2S5eYyq7wsBzWOMzYPR4JlNlRupwiohEtd7jWV93etZ2WSyn/G390H6ys
         sf5oPSzHY+NMmEr2hFe3iQ/iPJMKNpVoAYaQsoAI=
Date:   Wed, 14 Oct 2020 16:16:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 06/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame RX added.
Message-ID: <20201014161610.46dd5785@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012140428.2549163-7-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
        <20201012140428.2549163-7-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 14:04:24 +0000 Henrik Bjoernlund wrote:
> +struct br_cfm_status_tlv {
> +	__u8 type;
> +	__be16 length;
> +	__u8 value;
> +};

This structure is unused (and likely not what you want, since it will
have 2 1 byte while unless you mark length as __packed).
