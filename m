Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCB8416211
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242024AbhIWPcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241994AbhIWPcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 11:32:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BC8761029;
        Thu, 23 Sep 2021 15:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632411033;
        bh=8x9ryewjp8UQlWp0zAsTYiuxAhasVj5OVljia3433Uo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=izDbJzrfzNNlLVjSjKuj9vpb/UW63E4c1uyNOBmLPppz9q3Xng5MVgERCo+MEH7JR
         DHwAWWO7nFqoo7rrnZ0Vb1LfW+Rk/AdtuvNOJe8QdTQ7BzmZU7UEXFbpaae5PlZADD
         MVLqRKcvzprBsciri67zrR0UyuUERC14eiYwXF7p+XvQLsE4KcNclP0FdK7758vDIL
         njqCYDWqHnyAezUkQVY42HQTBj70eyrQj3kam074V6qCqBvbPYNnNHg2TohyaKenM8
         OPNz77ql8QfASbkRYaKaWYFQqod/61jT3avHCLnEDaY2nvj2939ieIHjST9CIIqXpD
         cg7QRkjlbp+bA==
Date:   Thu, 23 Sep 2021 08:30:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lee.jones@linaro.org>
Subject: Re: [PATCH net-next] ptp: clockmatrix: use rsmu driver to access
 i2c/spi bus
Message-ID: <20210923083032.093c3859@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1632319034-3515-1-git-send-email-min.li.xe@renesas.com>
References: <1632319034-3515-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Sep 2021 09:57:14 -0400 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> rsmu (Renesas Synchronization Management Unit ) driver is located in
> drivers/mfd and responsible for creating multiple devices including
> clockmatrix phc, which will then use the exposed regmap and mutex
> handle to access i2c/spi bus.

Does not build on 32 bit. You need to use division helpers.
