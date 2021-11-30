Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECFB4630FA
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhK3Kbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:31:42 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39537 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231216AbhK3Kbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 05:31:41 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5934058031E;
        Tue, 30 Nov 2021 05:28:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 30 Nov 2021 05:28:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uIwkoD
        8Pi03mbKbjXRQW0yvHkpeb/tjA53Ma7wUz9Vs=; b=i0rE/UjtG5lzFWaD/SU+a7
        KvcRMmY+y7sdGIlHQtz6jmxODjnUch+j2hojzjF1wJeK7+fG+TRQPkzq/roL5WI4
        l9pwjFFA++WcWyaNaWeJN1jJeREfIj7JNNGeqO1Zr+uYoYygANROjjlfY29gxYhb
        3KSeuSug1Y1OexxVfIIOYZbagZYPYY0Dwp3bkCahMrGyHH17GYLR5ADUHz0XAXKW
        UuSxI06Y4mv0ndu3HGrESRz5giGbzNvU+YBY3nmzsoArteFe6VBDcjRs7uvKhplA
        nYew3CpM3GSbTsiVGuArJX8gJ6MJR8ay9xordzmL8Oeh186TNC2Wu7k/Ptes+qOw
        ==
X-ME-Sender: <xms:xPylYdGZxH4Fekz54PWaE8mvsXczETaBPfgPEVbjhTU6EGR6UAsETg>
    <xme:xPylYSVgie7Zrhy6-zcILEkI27jlzpJ93l5cXUwLXwTbd8j20eeJ-9MeZwWeypKT4
    BSIb2KjmJJCEfA>
X-ME-Received: <xmr:xPylYfKFW6xb7SrNQujxhm4XWU9H3pIFH2Xxc07SP2YNDGS9TcrCvtwLzAjnEpF83jNYmJY0lJqJrX1SLlKb1Ky7psvrmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedugdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfgkeev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xPylYTHgSjk8z0fNE26L0bHYYisNZXRnklO8CXZh4k6owTuDcGNmng>
    <xmx:xPylYTU_vRG5LZY-Uo0AASFcRQEOgdvVHVGw7bIO_gI0hdCVRXRYWA>
    <xmx:xPylYeMjIFDFnTYxpTqOON3lNUFRP-0MjE4tajIsv5851irGdWVCJg>
    <xmx:xfylYfrOnyM7-rL6BOSn_VuQf-av21gw-vOhOSn4GerxuuQwdPOopA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 Nov 2021 05:28:20 -0500 (EST)
Date:   Tue, 30 Nov 2021 12:28:17 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        roopa@nvidia.com
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCH net-next] rtnetlink: add RTNH_REJECT_MASK
Message-ID: <YaX8wa5R/r5sbca5@shredder>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
 <YaOLt2M1hBnoVFKd@shredder>
 <e3d13710-2780-5dff-3cbf-fa0fd7cb5d32@gmail.com>
 <YaXZ3WdgwdeocakQ@shredder>
 <20211130113517.35324af97e168a9b0676b751@virtuozzo.com>
 <YaXuwEg/hdkwNYEN@shredder>
 <20211130125352.4bbcc68c01fe763c1f43bfdc@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130125352.4bbcc68c01fe763c1f43bfdc@virtuozzo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 12:53:52PM +0300, Alexander Mikhalitsyn wrote:
> On Tue, 30 Nov 2021 11:28:32 +0200
> Ido Schimmel <idosch@idosch.org> wrote:
> 
> > On Tue, Nov 30, 2021 at 11:35:17AM +0300, Alexander Mikhalitsyn wrote:
> > > On Tue, 30 Nov 2021 09:59:25 +0200
> > > Ido Schimmel <idosch@idosch.org> wrote:
> > > > Looking at the patch again, what is the motivation to expose
> > > > RTNH_REJECT_MASK to user space? iproute2 already knows that it only
> > > > makes sense to set RTNH_F_ONLINK. Can't we just do:
> > > 
> > > Sorry, but that's not fully clear for me, why we should exclude RTNH_F_ONLINK?
> > > I thought that we should exclude RTNH_F_DEAD and RTNH_F_LINKDOWN just because
> > > kernel doesn't allow to set these flags.
> > 
> > I don't think we should exclude RTNH_F_ONLINK. I'm saying that it is the
> > only flag that it makes sense to send to the kernel in the ancillary
> > header of RTM_NEWROUTE messages. The rest of the RNTH_F_* flags are
> > either not used by the kernel or are only meant to be sent from the
> > kernel to user space. Due to omission, they are mistakenly allowed.
> 
> Ah, okay, so, the patch should be like
> 
> diff --git a/ip/iproute.c b/ip/iproute.c
> index 1447a5f78f49..0e6dad2b67e5 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -1632,6 +1632,8 @@ static int save_route(struct nlmsghdr *n, void *arg)
>         if (!filter_nlmsg(n, tb, host_len))
>                 return 0;
>  
> +       r->rtm_flags &= RTNH_F_ONLINK;
> +
>         ret = write(STDOUT_FILENO, n, n->nlmsg_len);
>         if ((ret > 0) && (ret != n->nlmsg_len)) {
>                 fprintf(stderr, "Short write while saving nlmsg\n");
> 
> to filter out all flags *except* RTNH_F_ONLINK.

Yes

> 
> But what about discussion from
> https://lore.kernel.org/netdev/ff405eae-21d9-35f4-1397-b6f9a29a57ff@nvidia.com/
> 
> As far as I understand Roopa, we have to save at least RTNH_F_OFFLOAD flag too,
> for instance, if user uses Cumulus and want to dump/restore routes.
> 
> I'm sorry if I misunderstood something.

Roopa, do you see a problem with the above patch?
