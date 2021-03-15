Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC1C33C645
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhCOTBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229810AbhCOTAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 15:00:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 556B764E27;
        Mon, 15 Mar 2021 19:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615834841;
        bh=7r+vqiruIi5Kcu+b02MvGQyXIGhcf3dhpbwoGVTiBjQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NEZQQZHZl9cow/I4M+EoEchV11Go3aPWN/S2PfCSLBkAJ3utbrrehLxwD9RyAvuF5
         p+AYq6mCH5ysBn0Xo0tJu/35qyji2VEiZNzyVozU8uJj0qNgArCoqSvWSlArll3QRW
         Q4Xk/YcUJV646qwVsEzSoTe4U+K5bCGBaaftRBy5oO9APMxEkDMj83jJI5xi9UmOmU
         9wqgL28sbSMTr8N7SWtf8RmLiHDCOFAFXnK4e2jcp67sLemezPbqajUrBH9V4t0gnm
         OH2RY4Abe7PlBL0l49lYn/rks/bH2yX/tyGTcD42N27ZJY5/JP6CdQtVSc7JVOyNG+
         Ra/Pu6I5fMBnA==
Date:   Mon, 15 Mar 2021 12:00:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Wang Qing <wangqing@vivo.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3 net-next 4/6] linux/etherdevice.h: misc trailing
 whitespace cleanup
Message-ID: <20210315120039.36152d58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210315093839.6510-1-alobakin@pm.me>
References: <20210314111027.7657-1-alobakin@pm.me>
        <20210314111027.7657-5-alobakin@pm.me>
        <20210314210453.o2dmnud45w7rabcw@skbuf>
        <20210315093839.6510-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 09:38:57 +0000 Alexander Lobakin wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Sun, 14 Mar 2021 23:04:53 +0200
> 
> > On Sun, Mar 14, 2021 at 11:11:32AM +0000, Alexander Lobakin wrote:  
> > > Caught by the text editor. Fix it separately from the actual changes.
> > >
> > > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > > ---
> > >  include/linux/etherdevice.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> > > index 2e5debc0373c..bcb2f81baafb 100644
> > > --- a/include/linux/etherdevice.h
> > > +++ b/include/linux/etherdevice.h
> > > @@ -11,7 +11,7 @@
> > >   * Authors:	Ross Biro
> > >   *		Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
> > >   *
> > > - *		Relocated to include/linux where it belongs by Alan Cox
> > > + *		Relocated to include/linux where it belongs by Alan Cox
> > >   *							<gw4pts@gw4pts.ampr.org>
> > >   */
> > >  #ifndef _LINUX_ETHERDEVICE_H
> > > --
> > > 2.30.2
> > >
> > >  
> >
> > Your mailer did something weird here, it trimmed the trailing whitespace
> > from the "-" line. The patch doesn't apply.  
> 
> It's git-send-email + ProtonMail Bridge... Seems like that's the
> reason why only this series of mine was failing Patchwork
> everytime.

Yup. Sorry for the lack of logs in NIPA, you can run

  git pw series apply $id

and look at the output there. That's what I do, anyway, to double check
that the patch doesn't apply so the logs are of limited use.
