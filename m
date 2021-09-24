Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2063041791C
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 18:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344221AbhIXQxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 12:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344120AbhIXQxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 12:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A28861250;
        Fri, 24 Sep 2021 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632502333;
        bh=IECb5dYeCmTpgU+P1bTx6mph+EuLtBFK0vxCU3fFBjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ou8RbEZPKARt7J5RKIbFG64VSKN3Re8uohNKhw7qPojU7z2MKbHCKQPNWS5dFrvZJ
         ZR6JQXH1lFg/vKggP1VfkosGHvvXys8pVnhA0KrqTYpZHl+99MWpDN0qNjsSjuo2VQ
         JJ5gK2UTr84th9DKdTjDP8pgHVirGl46ECQfvyZfzxw2BL9VSsciaRBeC/QXvhwbuX
         YONWFXcIy4Z6bTRge8ICRaY1e44K4YNYTvBPkAyadlseTqOzj61grUL1Nq2y7DUs++
         3X0ti+Dgp0qJfqwlUveQHlgOjtUmAUZ4l6d/XxW328wSi0PrY6q4vG1qjSQuhVzAl0
         RxvwQ4oUJAK/w==
Date:   Fri, 24 Sep 2021 09:52:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lee.jones@linaro.org>
Subject: Re: [PATCH net-next v2] ptp: clockmatrix: use rsmu driver to access
 i2c/spi bus
Message-ID: <20210924095212.44e90704@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1632496702-15948-1-git-send-email-min.li.xe@renesas.com>
References: <1632496702-15948-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sep 2021 11:18:22 -0400 min.li.xe@renesas.com wrote:
> +		return 18 * (u64)NSEC_PER_SEC / fodFreq;

This one is 64b as well.
