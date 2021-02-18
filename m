Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3B431E7D1
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 10:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhBRJAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 04:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231287AbhBRIzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 03:55:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C49B060238;
        Thu, 18 Feb 2021 08:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613637860;
        bh=eGvfTLOrgg2KJyQLxhwaK2XJ3im6+ine27HiDNVd8Zg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SzwtObn3A8+/AiNoO/xPHlM0XvOSxmLbWNGUQbmaWWp/brGxw8xw8S+mEkvej98kq
         Gea1BQKA1L+2cudVg4yeITTU8sCVT/36kWLkaA3M/RnXcjkKJnZ8yGziMDDgM4VxCg
         Gj4R7XR/yS+FE9cRgrlq1L+/YwEO/+3RFIIUUB/AjTDIU6SFjCiFchuB++oK8fyT2s
         iHkuJu27MDqcjWl+jztUALUYSReTHoE/VHxMJw/W8uo4+P57LE+4b0AyAAz/AEsHex
         p3F1oglwxk7k3N28SyKrrzkGjT7lA1dRpNLlw5ZhwO68z7x1sPtYUgcK1mXe8x5mp/
         +gxOjnvsBhRHA==
Date:   Thu, 18 Feb 2021 10:44:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc] rdma: Fix statistics bind/unbing argument
 handling
Message-ID: <YC4o4L93lGYFQ1ku@unreal>
References: <20210214083335.19558-1-leon@kernel.org>
 <5e9a8752-24a1-7461-e113-004b014dcde9@gmail.com>
 <YCoJULID1x2kulQe@unreal>
 <04d7cd07-c3eb-c39c-bce1-3e9d4d1e4a27@gmail.com>
 <YCtjO1Q2OnCOlEcu@unreal>
 <9217385b-6002-83c2-b386-85650ce101bc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9217385b-6002-83c2-b386-85650ce101bc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 08:48:24AM -0700, David Ahern wrote:
> On 2/15/21 11:16 PM, Leon Romanovsky wrote:
> > On Mon, Feb 15, 2021 at 06:56:26PM -0700, David Ahern wrote:
> >> On 2/14/21 10:40 PM, Leon Romanovsky wrote:
> >>> On Sun, Feb 14, 2021 at 08:26:16PM -0700, David Ahern wrote:
> >>>> what does iproute2-rc mean?
> >>>
> >>> Patch target is iproute2.git:
> >>> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/
> >>
> >> so you are asking them to be committed for the 5.11 release?
> >
> > This is a Fix to an existing issue (not theoretical one), so I was under
> > impression that it should go to -rc repo and not to -next.
>
> It is assigned to Stephen for iproute2.
>
> >
> > Personally, I don't care to which repo will this fix be applied as long
> > as it is applied to one of the two iproute2 official repos.
> >
> > Do you have clear guidance when should I send patches to iproute2-rc/iproute2-next?
> >
>
> It's the rc label that needs to be dropped: iproute2 or iproute2-next.

Sure, no problem.

Thanks
