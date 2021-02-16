Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71A431C67A
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 07:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhBPGRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 01:17:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhBPGRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 01:17:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A070D64DFF;
        Tue, 16 Feb 2021 06:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613456191;
        bh=BERrAqabJM+lJ+M+VL/OJNCdzgHsU/bRTHZGTZhQBmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hvKnQ17vIozscBiQU2HEZ4SHkynCrlgYYT5peDrkslKD6WBhKeCdumIkIsfUi+4GF
         vgF1EYv4UWaBh711AtX5wbFaNhr0PfHLnoi9qMW/Mp94pCmWSYXqvdoxxDA2NbxJpR
         JCoYms9cgZkWspwv0XJRsb06/OC9o6yxea3fQ9jRGlp3bijYbU64ELRW1QzNsIcEcg
         rO5Dc1yoXv+g1qqyvtDzrC4+yKrs4jxTfeTHwfh6vJsZf4PB2q5FCH0gquJYLJLltX
         lDQ0zlWBRb5FSz89h6y0tWFb9fNcHdriWTGGeUAMkdqeq5XDIkh98e81NJowfpf1Os
         RWRZfm8OVB3WA==
Date:   Tue, 16 Feb 2021 08:16:27 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc] rdma: Fix statistics bind/unbing argument
 handling
Message-ID: <YCtjO1Q2OnCOlEcu@unreal>
References: <20210214083335.19558-1-leon@kernel.org>
 <5e9a8752-24a1-7461-e113-004b014dcde9@gmail.com>
 <YCoJULID1x2kulQe@unreal>
 <04d7cd07-c3eb-c39c-bce1-3e9d4d1e4a27@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04d7cd07-c3eb-c39c-bce1-3e9d4d1e4a27@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 06:56:26PM -0700, David Ahern wrote:
> On 2/14/21 10:40 PM, Leon Romanovsky wrote:
> > On Sun, Feb 14, 2021 at 08:26:16PM -0700, David Ahern wrote:
> >> what does iproute2-rc mean?
> >
> > Patch target is iproute2.git:
> > https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/
>
> so you are asking them to be committed for the 5.11 release?

This is a Fix to an existing issue (not theoretical one), so I was under
impression that it should go to -rc repo and not to -next.

Personally, I don't care to which repo will this fix be applied as long
as it is applied to one of the two iproute2 official repos.

Do you have clear guidance when should I send patches to iproute2-rc/iproute2-next?

Thanks
