Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3855648A779
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 06:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347391AbiAKFw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 00:52:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57316 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347405AbiAKFw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 00:52:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 91B99CE17A6
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 05:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C74BC36AE9;
        Tue, 11 Jan 2022 05:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641880372;
        bh=IymdefE7pGl+qM+0cAfEtgqs9DEI0WucnnTPQ5cMJRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dsA5DP5mQ89kV6HigP9pF9nYPiJsu7VSxZBzFK2gwTendS6F7rI4nT5MaZGdXW6H1
         OTtzfLnASBkMWjDdwicAMOGuYJD7tjWRqMlb5UOJcR1ycVj4XYZ2kfKgfgR9RbWt2U
         ILn0SY78HkOWwTledxcSj/5Vbq4Zl7eHweLihfGgPvW10cX82DWUOhlyEZ6CdZ96ah
         9tBFbQWt9VmUCwGH3wFrxLFXz/uECtfjfEwMk2iYf2/FHThj41CoeiSn/woUnykBWp
         c1JV9GOYQFNm5LC7z4Fyisd2chR0MZu0PzC+aEJN6y40KTu6kx3cZiukL/l7QfXD3l
         BC3ggufqDCDew==
Date:   Mon, 10 Jan 2022 21:52:51 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next] Revert "net: vertexcom: default to disabled on
 kbuild"
Message-ID: <20220111055251.kxjsexvktcwmdg3k@sx1>
References: <20220110205246.66298-1-saeed@kernel.org>
 <20220110185454.5d75aed9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220110185454.5d75aed9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 06:54:54PM -0800, Jakub Kicinski wrote:
>On Mon, 10 Jan 2022 12:52:46 -0800 Saeed Mahameed wrote:
>> From: Saeed Mahameed <saeedm@nvidia.com>
>>
>> This reverts commit 6bf950a8ff72920340dfdec93c18bd3f5f35de6a.
>>
>> To align with other vendors, NET_VENDOR configs are supposed to be ON by
>> default, while their drivers should default to OFF.
>
>Still planning to rework everything to default to 'n' in net-next later
>or did you change your mind? :)

absolutely, I wouldn't miss any chance to write a sed regex to make a
major patch for me ;), I am just waiting for the next release.

