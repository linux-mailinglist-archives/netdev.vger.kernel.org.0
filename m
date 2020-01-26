Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B473B149D4D
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgAZWRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:17:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgAZWRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 17:17:03 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0538C206F0;
        Sun, 26 Jan 2020 22:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580077022;
        bh=G0YQljacqyGi60baxOGuuxA3tsDozb7ynGvgJM9FoSw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uJpHRyui7Xc+240diNmKRK4PzUNzS3zCygiKGGPiB4JoX/1p+idVechGYSwRlSzif
         F/vjvKWeFz2mfqNIfIBo5dgUHWyPFO+IIGO1axdcJxXURaaW+e9szskwnRX9wUbM3N
         fWFJgcvw4jFRqkk4xxE0XZQ586S0+YcLmlrT3abU=
Date:   Sun, 26 Jan 2020 14:17:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200126141701.3f27b03c@cakuba>
In-Reply-To: <20200126134933.2514b2ab@carbon>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
        <20200126134933.2514b2ab@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jan 2020 13:49:33 +0100, Jesper Dangaard Brouer wrote:
> Yes, please. I want this NIC TX hook to see both SKBs and xdp_frames.

Any pointers on what for? Unless we see actual use cases there's
a justifiable concern of the entire thing just being an application of
"We can solve any problem by introducing an extra level of indirection."
