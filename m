Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED151245E40
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 09:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgHQHoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 03:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgHQHoO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 03:44:14 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E36420738;
        Mon, 17 Aug 2020 07:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597650254;
        bh=LryFHNFDSd2PtN6jRcpaptofL3Qn0MUdGJKE9K2UQcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PmfQ3F2/3020USngL6qE4F9RMcBQIL0a9fYvDSuNr8UZjmxsHb1fGY3i2rAVurnLQ
         yPWB4Sm+NLKdJwjIzlNn9HpF4XaIJ38bhVaSm8mtWIFHqc3b4f7zmsR2pPAL+K6Fec
         Q5Pt1tPiQE065Irh25DCvmXhLLdVOt2laJ2NDQmU=
Date:   Mon, 17 Aug 2020 10:44:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc v1 2/2] rdma: Properly print device and link
 names in CLI output
Message-ID: <20200817074410.GI7555@unreal>
References: <20200811073201.663398-1-leon@kernel.org>
 <20200811073201.663398-3-leon@kernel.org>
 <20200816154846.63ebf57c@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816154846.63ebf57c@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 03:48:46PM -0700, Stephen Hemminger wrote:
> On Tue, 11 Aug 2020 10:32:01 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
>
> > +	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "dev %s ", name);
>
> Since this is an interface name, you might want to consider using COLOR_IFNAME?
>
> I will go ahead and apply it as is but more work is needed here.

Thanks for taking care.
