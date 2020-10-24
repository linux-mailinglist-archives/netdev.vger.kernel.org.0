Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC014297A33
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 03:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758530AbgJXBnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 21:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754518AbgJXBnf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 21:43:35 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A4A924248;
        Sat, 24 Oct 2020 01:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603503830;
        bh=lAFxoe18BqGJNs2hyFP/LVCczdyOJQ4jVafO/Mk3G8s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=veQB1OmkTdKjQiVy/zSAyw+nPtmQUtZu8x4zmEfJjDKwydLd3eXywe5vKS1v1ZOLF
         ghA/SFA5Ax0sRVmnkXWriYYBKW8ehWrN36xUvn99g0o0+orTaSM8342bVc6vn9xQhI
         UKCe+niSav1B77j3AqQF0nML7tEcEzZorDLu6MlI=
Date:   Fri, 23 Oct 2020 18:43:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net 0/3] ionic: memory usage fixes
Message-ID: <20201023184349.536443e1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022235531.65956-1-snelson@pensando.io>
References: <20201022235531.65956-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 16:55:28 -0700 Shannon Nelson wrote:
> This patchset addresses some memory leaks and incorrect
> io reads.

Applied, thanks!

Looks like a fixes tag on patch 3 points to harmless refactoring -
better point to the commit where problem first existed IMO.
