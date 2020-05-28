Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE941E6AC1
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406530AbgE1TZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406521AbgE1TYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 15:24:55 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12AEA207BC;
        Thu, 28 May 2020 19:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590693895;
        bh=/+Va9C9erl6YA+17O7FcEwQMh1ArRwLurycfb/mucuc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rawiSN7m8IHWeIQl8RsOftANuFCGpRZWV3qOfPT5a2qJGnnbUsRIBIF157SPrngpx
         yIydrWm61vLGsUztlE158wndRl/kHUG1rUF2dAfY6nOJm7JfAoTtee/7iK90yrB4Sc
         /Kx/cDlZ4SnawxEhq5Qg8fnNWSAUugICD5+OIsj0=
Date:   Thu, 28 May 2020 12:24:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH net-next] nfp: flower: fix incorrect flag assignment
Message-ID: <20200528122453.22ae2015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200528141846.16468-1-simon.horman@netronome.com>
References: <20200528141846.16468-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 16:18:46 +0200 Simon Horman wrote:
> From: Louis Peens <louis.peens@netronome.com>
> 
> A previous refactoring missed some locations the flags were renamed
> but not moved from the previous flower_ext_feats to the new flower_en_feats
> variable. This lead to the FLOW_MERGE and LAG features not being enabled.
> 
> Fixes: e09303d3c4d9 ("nfp: flower: renaming of feature bits")
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
