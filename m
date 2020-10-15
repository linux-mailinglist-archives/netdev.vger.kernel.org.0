Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFCA28F7AB
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 19:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731213AbgJORee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731190AbgJORee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 13:34:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51DFC2225F;
        Thu, 15 Oct 2020 17:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602783274;
        bh=DNxvAuV7cKNsPEncClCJJJ0vr4kkwu9AJqh2X91MJ+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ma63it46MNeYoPlFyYS5c1K5Cr4yl4b0mvpITcv+TdQSvEqmopd6R4HZanFaS0Ga3
         Sg9uHJdGQ51/ZZRXYNcxvJph/r1CpZQxyJWJzJhM7/JtRPWs7mYClAwKFR7Swjx7/8
         48jSLBH9u8JSFCL2ndfp0McKVKoUbsT8Lq397YIg=
Date:   Thu, 15 Oct 2020 10:34:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v6 07/10] bridge: cfm: Netlink SET
 configuration Interface.
Message-ID: <20201015103431.25d66c8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015115418.2711454-8-henrik.bjoernlund@microchip.com>
References: <20201015115418.2711454-1-henrik.bjoernlund@microchip.com>
        <20201015115418.2711454-8-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 11:54:15 +0000 Henrik Bjoernlund wrote:
> +	[IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL]	 = {
> +	.type = NLA_U32, .validation_type = NLA_VALIDATE_MAX, .max = 7 },

	NLA_POLICY_MAX(NLA_U32, 7)

Also why did you keep the validation in the code in patch 4?
