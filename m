Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E0B2ED713
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbhAGTBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728131AbhAGTBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:01:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9592E23435;
        Thu,  7 Jan 2021 19:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610046036;
        bh=p32R4l2X6LHNmx9grMRpGwJQbqqjiSd9GjOECry6HnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=axxIuOuqXiLkWme/VC3uZF44PqCBCJiWJMT/re8CAu5PSKDx/EIsji3NazzX3P540
         uPQFUbNhsN94SxpvMw0IopAg1lLV2hoOH/m/W3VlKtQAQJ8n+a70jJAWojRbcEbKdt
         awEal5YWBvGTbfXuRKFHzw8D6CKBoXDcoYSOyIthFMXhOpSTd4hiUsiCmDccklqaFp
         wzmSwBZIdZq9yMKhdH/wiBFpwm06haZONpSuwGkBewHZgyiKJc5ZQEXFJKsISRV5s6
         VgSEzHQQ3Z+5XZMT4avqXtXS8/XDnMg6vxnVeZtHxXSHSQ5oq9Rv9AYu0mwWv1fdgO
         +sdOwlYv8mXSA==
Date:   Thu, 7 Jan 2021 11:00:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>
Subject: Re: [net-next 15/19] can: tcan4x5x: rework SPI access
Message-ID: <20210107110035.42a6bb46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107094900.173046-16-mkl@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
        <20210107094900.173046-16-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 10:48:56 +0100 Marc Kleine-Budde wrote:
> +struct __packed tcan4x5x_map_buf {
> +	struct tcan4x5x_buf_cmd cmd;
> +	u8 data[256 * sizeof(u32)];
> +} ____cacheline_aligned;

Interesting attribute combo, I must say.
