Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C765F2A0CDD
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgJ3RxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgJ3RxH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 13:53:07 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7B0120724;
        Fri, 30 Oct 2020 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604080387;
        bh=fiX1GZZW0VTWVzXnWU7zdBSZ50Wkkk7mejibE0CkdiY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MVu0kaAvE2wNNEOpn24cdcrKUr7wR9hPCh8U/U1elyPWxSiwguHNQIvA7gsA7MqOP
         3catVGDL6ZN05N6NYGqCe+ts5RURK8jJsDIylSnD36zV3YWReaudQOs22edVXB7a+I
         cXPRXnX16hvd3ESgDN9wYJrL3pZqzKSQPF7f/ktk=
Date:   Fri, 30 Oct 2020 10:53:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net-next 00/16] selftests: net: bridge: add tests for
 IGMPv3
Message-ID: <20201030105305.719eac75@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027185934.227040-1-razor@blackwall.org>
References: <20201027185934.227040-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 20:59:18 +0200 Nikolay Aleksandrov wrote:
> This set adds tests for the bridge's new IGMPv3 support. The tests use
> precooked packets which are sent via mausezahn and the resulting state
> after each test is checked for proper X,Y sets, (*,G) source list, source
> list entry timers, (S,G) existence and flags, packet forwarding and
> blocking, exclude group expiration and (*,G) auto-add. The first 3 patches
> prepare the existing IGMPv2 tests, then patch 4 adds new helpers which are
> used throughout the rest of the v3 tests.
> The following new tests are added:
>  - base case: IGMPv3 report 239.10.10.10 is_include (A)
>  - include -> allow report
>  - include -> is_include report
>  - include -> is_exclude report
>  - include -> to_exclude report
>  - exclude -> allow report
>  - exclude -> is_include report
>  - exclude -> is_exclude report
>  - exclude -> to_exclude report
>  - include -> block report
>  - exclude -> block report
>  - exclude timeout (move to include + entry deletion)
>  - S,G port entry automatic add to a *,G,exclude port
> 
> The variable names and set notation are the same as per RFC 3376,
> for more information check RFC 3376 sections 4.2.15 and 6.4.1.
> MLDv2 tests will be added by a separate patch-set.

Applied, thanks Nik!
