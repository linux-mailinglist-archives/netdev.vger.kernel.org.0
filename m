Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B6A29473C
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440151AbgJUEYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407107AbgJUEYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 00:24:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CF0121BE5;
        Wed, 21 Oct 2020 04:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603254258;
        bh=8HQq8UVTQ1yUS+8KnatoCdzOsnRFGcQPH6XBeMsfWT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QYqwoWUd7qjpu1M3FKBbEErz+zkNpeXyADbzSeYiMQdryxRIvVL7rUMPn3W+1V30B
         Kf6oUlCkYxIpk3urZ00U10NFomLun/ZLzSbj4FTGhQln5A3USrhQq8S7PYWNutamQq
         Du0VZ9OwQFNdhhOhfWRJWfeyoBzrLduNURhzpsEs=
Date:   Tue, 20 Oct 2020 21:24:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net] sfc: move initialisation of efx->filter_sem to
 efx_init_struct()
Message-ID: <20201020212416.6d494027@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <24fad43e-887d-051e-25e3-506f23f63abf@solarflare.com>
References: <24fad43e-887d-051e-25e3-506f23f63abf@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 15:35:08 +0100 Edward Cree wrote:
> efx_probe_filters() has not been called yet when EF100 calls into
>  efx_mcdi_filter_table_probe(), for which it wants to take the
>  filter_sem.
> 
> Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and related gubbins")
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied, thanks!
