Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0531563B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbhBISpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233306AbhBISaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 13:30:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05D5664E56;
        Tue,  9 Feb 2021 18:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612895240;
        bh=ObagXonRqYSXqgEYc7spXkKBXXrROX4Uvuntn3Du9SA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WXKEDtk0sSrW8l1pVMUzwf+2v7CLXSpPpmqAJNm3rtl/WmPK7zqqyH5fTnZBdZcsj
         TXlUEFUX1ugqaq+erW2eqxg3Ha0Pej4tLH1fCg8UNltjRbfUst6Pkxcck1BaVDkZGv
         hyBJK1bztF0QlyYP9WtO2fUWFb1j3qCGitftFt1e7ui6EEURmN0xg/zY0ETlBcWo9R
         fAQQijllHSgrcPwgtHylaHpi67sO67x8kV2jR5JuCNZet5rzG6C57t0/gMFIvoH4iU
         z4LOi5cbSI6K60HJnOqYH9/OMJyNr8G4fEbHANJCWc/wfKh6yiSbjzAntmfuKQ9R0X
         9KRjSFzQJP86w==
Date:   Tue, 9 Feb 2021 10:27:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aya Levin <ayal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] devlink: Fix dmac_filter trap name, align to
 its documentation
Message-ID: <20210209102719.4218ddc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612868395-22884-1-git-send-email-ayal@nvidia.com>
References: <1612868395-22884-1-git-send-email-ayal@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Feb 2021 12:59:55 +0200 Aya Levin wrote:
> %s/dest_mac_filter/dmac_filter/g
> 
> Fixes: e78ab164591f ("devlink: Add DMAC filter generic packet trap")
> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Reported-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

