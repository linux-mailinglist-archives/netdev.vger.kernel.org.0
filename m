Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4211C3055F7
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316868AbhAZXLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:11:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:34440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404973AbhAZUBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 15:01:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EA8422A83;
        Tue, 26 Jan 2021 20:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611691256;
        bh=NZrdI3qvwW4PuR6HD536+3cUT4dXOETclLICtwlAUDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e/1t+Fh1EFODYm/5rTTvwwmhkMbuRmbbVBVY3WAVzF0Rd7DZ2Z4FMfUcqEzYYysLS
         RA2TFLz7rA5VaGIAMFMWhf75HpVnn8K8nhm0UXtLk31DAhzvO8qCZxH3lbbqaVr0QI
         9iAy7W14T6EoZdmA2nMvWD+mviPQrwLyOLYUIWNLu8Np8DmPEV2qJ8lbSVC32FFvcX
         Pu74kClppF+7Q9JRlKgIh2FoWk/R8/uzfc+vBIgjLoB27j04TXEoRwLxQkhOIBVLC0
         lBzGgjj738+w+1gewrzB5xJUP03UoJD1HgnUyICyPnhPmrNYBv4hgp6ULCHxuP2xFQ
         5iUFd2er9XEIA==
Date:   Tue, 26 Jan 2021 12:00:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corinna Vinschen <vinschen@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com
Subject: Re: [Intel-wired-lan] igc: fix link speed advertising
Message-ID: <20210126120055.001934db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126103037.GH4393@calimero.vinschen.de>
References: <20201117195040.178651-1-vinschen@redhat.com>
        <20210126103037.GH4393@calimero.vinschen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 11:30:37 +0100 Corinna Vinschen wrote:
> Ping?
> 
> It looks like this patch got lost somehow.  Without this patch,
> setting link speed advertising is broken.

Adding Intel maintainers.
