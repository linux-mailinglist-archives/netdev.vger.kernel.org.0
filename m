Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E95F48EDF3
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243285AbiANQTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:19:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47128 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243304AbiANQTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:19:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADC7961EEF;
        Fri, 14 Jan 2022 16:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C968BC36AE5;
        Fri, 14 Jan 2022 16:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642177174;
        bh=LKSGYr+I1dSEViTP9kEfMfyA/7v/hAXWp/rJrHzDIwo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=es5ujU8J5XGRYUksP+2BJ0mBT073VQ6pcC1MwUWrP3CmLhliIBBeIzYbeNhGpBRfP
         ohfCVDLNmNtyw2zb9FTvls28Q4MZh726Z6aUnFCkFfRO9mY1CDwfaUEqWDwNrAuzny
         JxyBsvJmAQUzp1xE7kDdjp/lPghqDNOdfSJtGnos+WK55nBY7AmsU/qQ/K3RxIYKdJ
         ZlBOjyJNFYkTqrlAWGSBlMqpE0PhMnblRmpziI5WK0aEgc5lvdJlWpfUrscX96/SX2
         uyFohTcxcKfTrySh9Fin15OCLoj14nGANMsvFv+0hb0wnhMu9cR1HnrR1amkiB2gv9
         W0bEA9aiSYXxw==
Date:   Fri, 14 Jan 2022 08:19:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, lkp@intel.com
Subject: Re: [PATCH wireless] MAINTAINERS: add common wireless and
 wireless-next trees
Message-ID: <20220114081932.475eaf86@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220114133415.8008-1-kvalo@kernel.org>
References: <20220114133415.8008-1-kvalo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 15:34:15 +0200 Kalle Valo wrote:
> +Q:	http://patchwork.kernel.org/project/linux-wireless/list/

nit: https?
