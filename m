Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C173A26051E
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 21:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgIGTaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 15:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgIGTa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 15:30:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EC312145D;
        Mon,  7 Sep 2020 19:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599506552;
        bh=nHPlYH6o2gKiuqBpa6mV+jL/hiwn+YGj2MPz5n883Fo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XF97lPqttyoijejcPGmucnP6lVcCO9q+uObQJFh6mZ+1uGQW0T+GPs+VVc/qHX6tw
         d1WBZE1UTzzebAcqwQgJhGHTDeJkSE5ZCizyCE3kvCFuOjlmY4JJ69r8JLQiHIn+KE
         kIwx5bLdwsJ4AcsgR5AXQ5iJGYgyOmWC8lq8Cy1k=
Date:   Mon, 7 Sep 2020 12:22:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/6] sfc: remove phy_op indirection
Message-ID: <20200907122230.47ccfd55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9cc76465-9c1c-ec10-846a-b58f16d0d083@solarflare.com>
References: <4634ee2f-728d-fa64-aa2c-490f607fc9fd@solarflare.com>
        <9cc76465-9c1c-ec10-846a-b58f16d0d083@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 17:14:34 +0100 Edward Cree wrote:
>  drivers/net/ethernet/sfc/mcdi_port.c        | 593 +-------------------
>  drivers/net/ethernet/sfc/mcdi_port_common.c | 560 ++++++++++++++++++

Would you mind improving variable ordering and addressing checkpatch
complaints while moving this code? The camel case and breaking up
case statements warning can definitely be ignored, but there are others.
