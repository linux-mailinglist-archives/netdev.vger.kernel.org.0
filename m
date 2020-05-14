Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A041D381A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgENR0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgENR0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 13:26:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E8742065D;
        Thu, 14 May 2020 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589477210;
        bh=FcTeKdD704w/wTWBD3AsVLrDCw5HoMH0wC/oaNszElI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=im6UuOEr7+FT8B2hTvLQk5WzBKhOAKtcyCfopYIDevQh8PbklDxxuXit89FFSVDx/
         2xfYE6CJwovsArSnQOZpqgsg8IMFOC9W4bzk0HI6I316NEW4tBfXn7gWUd6BnuaKWb
         f6fnEjzDRcvEMc5KEmRJqHSr9+sNJKRR5to2Lx8Q=
Date:   Thu, 14 May 2020 10:26:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, dcaratti@redhat.com,
        marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next 0/4] Implement filter terse dump mode support
Message-ID: <20200514102647.5c581b5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200514114026.27047-1-vladbu@mellanox.com>
References: <20200514114026.27047-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 May 2020 14:40:22 +0300 Vlad Buslov wrote:
> Implement support for terse dump mode which provides only essential
> classifier/action info (handle, stats, cookie, etc.). Use new
> TCA_DUMP_FLAGS_TERSE flag to prevent copying of unnecessary data from
> kernel.

Looks reasonable:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Apart from the change in NLA_BITFIELD policy build bot already pointed
out there is also an unnecessary new line after a function in patch 2.
