Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9CC36D5D3
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 12:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbhD1Kan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 06:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhD1Kam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 06:30:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9162613FF;
        Wed, 28 Apr 2021 10:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619605797;
        bh=8C+OErcF42crulhtmpO3zOoSt0k/g7nGDTskXCzZBv0=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Da432CDk5RTSR+1+b85H4jxdY4rw0w2r+IVM2U59jpCTLGTuuTqyHcKD+gHDkWs5s
         tlCQdDuWIM5amEuBPZEbZLEp/8zF4A8Wa6bog/pzz6xY8HWmkIQY3eda4xcWV72zQH
         0EyDKY6foSXFcEVQPphyRgCCTiBLRlbfyUDJ5rDF5W3Hyh027BmMdsfRge//6oblO9
         DPxgUcmWFPah1k4/aNdkLDh46k+nRSKasC4vhxisUbFof6Cu4iKEpPNHwUn32INzIy
         sFCrJiflrUZfOAkZmrYkK8IwQm5hO2H2YfopdfozwyNX3WYNLIhxL2gxM99LWQx49C
         8CG1MeO321bMQ==
Date:   Wed, 28 Apr 2021 12:29:52 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
cc:     ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
In-Reply-To: <YH2hs6EsPTpDAqXc@mit.edu>
Message-ID: <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
References: <YH2hs6EsPTpDAqXc@mit.edu>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Apr 2021, Theodore Ts'o wrote:

> This year, the Maintainers and Kernel Summit is currently planned to
> be held in Dublin, Ireland, September 27 -- 29th.  

Hi Ted,

given the fact that OSS is being relocated from Dublin to Washington [1], 
is Kernel Summit following that direction?

[1] https://www.linuxfoundation.org/en/press-release/the-linux-foundation-announces-open-source-summit-embedded-linux-conference-2021-will-move-from-dublin-ireland-to-seattle-washington/

-- 
Jiri Kosina
SUSE Labs

