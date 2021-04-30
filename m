Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A49236F58A
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 08:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhD3GDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 02:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhD3GDB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 02:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B379E61456;
        Fri, 30 Apr 2021 06:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619762533;
        bh=QzCS0dCd4RoasI83jSHrwbAlJ/VAD4W5hnns+z19NmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zOKe5OK7HKSBzS7fUC97azmA6cCm3u8yJwqzwvHT6bOr+NW7wdVunaSb9sKGzWkge
         CNkm/d2jq3vxn9ncQCCx8wF81WuXmMY+UBBniNpmuKglw5DPKlZg3llsWmxPMsI79S
         E//XQxUuiKWl/pSFj3RVfQpoJ4XnnJElyLqbe+pY=
Date:   Fri, 30 Apr 2021 08:02:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Matthias Maennich <maennich@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v2] kbuild: replace LANG=C with LC_ALL=C
Message-ID: <YIudYzwMq18AS8nB@kroah.com>
References: <20210430015627.65738-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430015627.65738-1-masahiroy@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 10:56:27AM +0900, Masahiro Yamada wrote:
> LANG gives a weak default to each LC_* in case it is not explicitly
> defined. LC_ALL, if set, overrides all other LC_* variables.
> 
>   LANG  <  LC_CTYPE, LC_COLLATE, LC_MONETARY, LC_NUMERIC, ...  <  LC_ALL
> 
> This is why documentation such as [1] suggests to set LC_ALL in build
> scripts to get the deterministic result.
> 
> LANG=C is not strong enough to override LC_* that may be set by end
> users.
> 
> [1]: https://reproducible-builds.org/docs/locales/
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> Reviewed-by: Matthias Maennich <maennich@google.com>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net> (mptcp)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

