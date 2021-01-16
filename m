Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50EB2F8FBA
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 23:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbhAPWf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 17:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbhAPWfy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 17:35:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58AD022CAF;
        Sat, 16 Jan 2021 22:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610836513;
        bh=7Tymz9Daktplx8MJ4D1SHputqOjeunepUWHJELcLUmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a4/uBAAUY4socxK8cEwQoM+dt41J30T7KC70/ghplaJvm58rNE001Q+QjvGWEUvZX
         RxdnuPZzLjtmiuHcZ/4EnQRuFRtTqXCkefxyfjHGN8HUVAbOduKZA8TicoYwuSWejr
         qomg57ZtFuUWzrYEm+VWpucrNVxZc6/zx+zEp+YwX9tUSXmReJncevrgsymz5nubCI
         XnTL79Dy56wJVVMoFMyEEonm17F2iCy/ey4S9WxzF8JWt5kQoqlflt9S8dc4W7zNwJ
         qW8pYEaMow6pDK5DSO88rhB3UsUDLRNy0gXqElC2tzrdy/J4hBHKSS1JpDox7opmqY
         VUXoKqpdYemXA==
Received: by pali.im (Postfix)
        id 0D22F60E; Sat, 16 Jan 2021 23:35:10 +0100 (CET)
Date:   Sat, 16 Jan 2021 23:35:10 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] netdevice.7: Update documentation for SIOCGIFADDR
 SIOCSIFADDR SIOCDIFADDR
Message-ID: <20210116223510.gk56aylkpo35aoev@pali>
References: <20210102140254.16714-1-pali@kernel.org>
 <20210102183952.4155-1-pali@kernel.org>
 <20210110163824.awdrmf3etndlyuls@pali>
 <16eaf3ce-3e76-5e34-5909-be065502abca@gmail.com>
 <20210112192647.ainhrkwhruejke4v@pali>
 <8e09e975-3b79-a47c-527f-84b77563d6bf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e09e975-3b79-a47c-527f-84b77563d6bf@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 16 January 2021 01:41:24 Alejandro Colomar (man-pages) wrote:
> On 1/12/21 8:26 PM, Pali Rohár wrote:
> > On Sunday 10 January 2021 20:57:50 Alejandro Colomar (man-pages) wrote:
> >> [ CC += netdev ]
> >>
> >> On 1/10/21 5:38 PM, Pali Rohár wrote:
> >>> On Saturday 02 January 2021 19:39:52 Pali Rohár wrote:
> >>>> Also add description for struct in6_ifreq which is used for IPv6 addresses.
> >>>>
> >>>> SIOCSIFADDR and SIOCDIFADDR can be used to add or delete IPv6 address and
> >>>> pppd is using these ioctls for a long time. Surprisingly SIOCDIFADDR cannot
> >>>> be used for deleting IPv4 address but only for IPv6 addresses.
> >>>>
> >>>> Signed-off-by: Pali Rohár <pali@kernel.org>
> >>>> ---
> >>>>  man7/netdevice.7 | 50 +++++++++++++++++++++++++++++++++++++++++-------
> >>>>  1 file changed, 43 insertions(+), 7 deletions(-)
> >>>
> >>> Hello! Is something else needed for this patch?
> >>
> >> Hello Pali,
> >>
> >> Sorry, I forgot to comment a few more formatting/wording issues: see
> >> below.  Apart from that, I'd prefer Michael to review this one.
> >>
> >> Thanks,
> >>
> >> Alex
> > 
> > Hello Alex! I will try to explain configuring IPv4 and IPv6 addresses on
> > network interfaces, so you probably could have better way how to improve
> > description in "official" manpage. I'm not native English speaker, so I
> > would follow any suggestions from you.
> [...]
> 
> Hi Pali,
> 
> Thanks for explaining the process to me.
> However, I don't feel that I understand it enough to help you co-writing
> the text.  I lack much background to understand your explanation.  I'd
> help you with the language happily, if it was only that :)

OK! I will send a new patch version ...

> Maybe someone from netdev@ can help?  Or Michael?

... and other improvements can be done later.

> Regards,
> 
> Alex
> 
> 
> -- 
> Alejandro Colomar
> Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
> http://www.alejandro-colomar.es/
