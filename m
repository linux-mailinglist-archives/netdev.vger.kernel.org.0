Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED9D27352B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 23:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgIUVt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 17:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgIUVt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 17:49:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B782E23A60;
        Mon, 21 Sep 2020 21:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600724998;
        bh=aEx0yYBwwD6KUORF+G9c2l5dYex/Qd/vsdWVcAUAsSQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2rpG9OZwOkTionkigEn90+l9C7hL+do14T8rpvNKWQzCjuWjfDmsao65awLYXX6GG
         yAwfIwE4eNQkEVVLUgCc454FmWXGk3+YnNMgyMmPIb2G536SC/X5vdnLGLfpkRBiS6
         DvGi0j4MO5bomgkjGKo2ZfNRnLSY0GslWaaqz/Pk=
Date:   Mon, 21 Sep 2020 14:49:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ip: promote missed packets to the -s row
Message-ID: <20200921144957.495c6f96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200919090658.02c9f5f0@hermes.lan>
References: <20200916194249.505389-1-kuba@kernel.org>
        <0371023e-f46f-5dfd-6268-e11a18deeb06@gmail.com>
        <20200918084826.14d2cea3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f936dedf-ee3a-976c-c535-55a2b075b37b@gmail.com>
        <20200919090658.02c9f5f0@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Sep 2020 09:06:58 -0700 Stephen Hemminger wrote:
> > > Does that mean "no" or "you need to be more convincing"? :)
> > > 
> > > JSON output is not changed. I don't think we care about screen
> > > scrapers. If we cared about people how interpret values based 
> > > on their position in the output we would break that with every
> > > release, no?
> > 
> > In this case you are not adding or inserting a new column, you are
> > changing the meaning of an existing column.
> > 
> > It's an 'error' stat so probably not as sensitive. I do not have a
> > strong religion on it since it seems to be making the error stat more up
> > to date.  

I hope this change would encourage vendors to use the standard stats.
Because..

> Is there any way to see the old error column at all?

I had no idea how to even show error stats. I read the code multiple
times, only when I sat down to actually implement displaying did I
realize that -s -s (repeat the option) shows all the stats.
