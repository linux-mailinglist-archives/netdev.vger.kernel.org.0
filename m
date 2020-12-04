Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE932CE53D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgLDBnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:43:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgLDBnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 20:43:01 -0500
Date:   Thu, 3 Dec 2020 17:42:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607046140;
        bh=pIlJOFEjUZmY29TtuxCmY4kYTaVQoES438UKqoDKQNk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=oJpdIFCkSwoEfxEDUW139IdJ8ztuN561G8emRa1x8XLbUfvTSls4/w1HZWPWd5B0H
         ioVAe6PFnPjHrZ4UhhXRibWXc1ciA6ctOuc/R1CVKJFsUs+cPAvz3Tsb8/dwjoUEDs
         OBEPtZEqETuLcTSJI4PdQRrPkYNEIeh4cjewf6ubyTpbTtVtThVuKExGuo9ZhafxUL
         EFmInqPBZfHsXlTzPPAudh5i1nHwzqFgPfrPufbB5TGBwMw4Q2slVqOIS0ieHUkQjl
         EMdNpVMNZcolJpNpvbJ4Hn4Ul4Jhd2/UltRzEq1Tv4q9c0Z8eXRp3p1IVPspS6VvlR
         dp0+d/byl1Iwg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf 1/7] xdp: remove the xdp_attachment_flags_ok()
 callback
Message-ID: <20201203174217.7717ea84@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <160703131819.162669.2776807312730670823.stgit@toke.dk>
References: <160703131710.162669.9632344967082582016.stgit@toke.dk>
        <160703131819.162669.2776807312730670823.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Dec 2020 22:35:18 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Since we offloaded and non-offloaded programs can co-exist there doesn't
> really seem to be any reason for the check anyway, and it's only used in
> three drivers so let's just get rid of the callback entirely.

I don't remember exactly now, but I think the concern was that using=20
the unspecified mode is pretty ambiguous when interface has multiple
programs attached.
