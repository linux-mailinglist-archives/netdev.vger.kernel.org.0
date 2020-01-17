Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC566140179
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 02:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388427AbgAQBdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 20:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388395AbgAQBdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 20:33:24 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0228820728;
        Fri, 17 Jan 2020 01:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579224804;
        bh=iE5UX2pNQqnBzpF2XPvEmUyMo5dWXK2NwcsvPvm41DQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=09aWOXsl1FINA/6/6ReJNzQXU+84bfDPstwqdmcTGgA4ekdOUF0SkGsvVD5zDNs4G
         aCzKroE7vgkYgFOznUF/jkCVyDvIricVuSS6ecEERxYRH/RBtSciuYRo1jQ7nygBve
         EHPmXWQpmVCsJDMWaN2ycIvSJjIEs0Q6hOTdjuVY=
Date:   Thu, 16 Jan 2020 17:33:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v3 14/17] octeontx2-pf: Add basic ethtool support
Message-ID: <20200116173322.47271aad@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1579204053-28797-15-git-send-email-sunil.kovvuri@gmail.com>
References: <1579204053-28797-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579204053-28797-15-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jan 2020 01:17:30 +0530, sunil.kovvuri@gmail.com wrote:
> +#define DRV_NAME	"octeontx2-nicpf"
> +#define DRV_VERSION	"1.0"

> +	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> +	strlcpy(info->version, DRV_VERSION, sizeof(info->version));

We generally discourage the user of DRV_VERSION these days and suggest
to return the kernel version here. With backports and heavily patched
distro kernels this number quickly becomes counter-informative.

Thanks for the changes to the stats!
