Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A4F2C3672
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 03:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgKYB6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 20:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgKYB6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 20:58:05 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A2342151B;
        Wed, 25 Nov 2020 01:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606269485;
        bh=+eY/t4plJPFK4LaRS5VCwtbTGBHfPxZg0tnUHZlt4DE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c9Dqp2i5S3xC43y1/nkS782NObVUvAP8bDkwLcPi22DUFvosVLGz+0eR2WQngOXt2
         s/nfZXZJaklNrU0ahRQIMoFKgWfMOAMNuHf3TKNYUpFRTH5wgYrN+/L3Ev8tPQtg1I
         8A7944Gy1g5W21Fz0HDcBW2XEyoVljTn7AyXCa6c=
Date:   Tue, 24 Nov 2020 17:58:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next v3 0/8] seg6: add support for SRv6 End.DT4/DT6
 behavior
Message-ID: <20201124175803.1e09e19e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3dd23494-d6ae-1c09-acb3-c6c2b2ef93d8@gmail.com>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
        <20201124154904.0699f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3dd23494-d6ae-1c09-acb3-c6c2b2ef93d8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 18:24:37 -0700 David Ahern wrote:
> On 11/24/20 4:49 PM, Jakub Kicinski wrote:
> > 
> > LGTM! Please address the nit and repost without the iproute2 patch.
> > Mixing the iproute2 patch in has confused patchwork:
> > 
> > https://patchwork.kernel.org/project/netdevbpf/list/?series=389667&state=*
> > 
> > Note how it thinks that the iproute2 patch is part of the kernel
> > series. This build bot-y thing is pretty new. I'll add a suggestion 
> > to our process documentation not to mix patches.  
> 
> That was me - I suggested doing that. I have done that in the past as
> has several other people. I don't recall DaveM having a problem, so
> maybe it is the new patchworks that is not liking it?

Right, I'm not sure, it's a coin toss whether pw will get the iproute
patch first or not (or maybe since 'i' < 'n' we're likely to get the
iproute patch first most of the time?)

But it's generally not a huge issue for applying the patch. I just like
to see the build bot result, to make sure we're not adding W=1 C=1
warnings.

> >> I would like to thank David Ahern for his support during the development of
> >> this patchset.  
> > 
> > Should I take this to mean that David has review the code off-list?
> 
> reviews and general guidance.

Great! (I wasn't sure if I should wait for your review tags, hence the
poke.)
