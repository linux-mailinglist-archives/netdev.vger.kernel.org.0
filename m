Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF89278571
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 12:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgIYK5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 06:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgIYK5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 06:57:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD45E21D91;
        Fri, 25 Sep 2020 10:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601031435;
        bh=7b1lo3BUiiQw0PSLZhJ2CISK6gXAvCQzhFUyeJ0sssQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WD3u8k12q2ovIgPXUruIhJi0xXpoSHh0X4RkXVhFNjmH/h+iVf74uKkJCG3JETCto
         3rImDm6a3qo8KkZMJSqGVbyqghhrfQman+qJd0541C1brPGzgF2kSi8fDf2vdowoYT
         Zz0ap5y6vs6XipCacJBtlI2vM6X5/D/CGjrQi0+4=
Date:   Fri, 25 Sep 2020 12:57:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Priyaranjan Jha <priyarjha.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Priyaranjan Jha <priyarjha@google.com>
Subject: Re: [PATCH linux-4.19.y 0/2] tcp_bbr: Improving TCP BBR performance
 for WiFi and cellular networks
Message-ID: <20200925105729.GA2573626@kroah.com>
References: <20200922192735.3976618-1-priyarjha.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922192735.3976618-1-priyarjha.kernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 12:27:33PM -0700, Priyaranjan Jha wrote:
> From: Priyaranjan Jha <priyarjha@google.com>
> 
> Ack aggregation is quite prevalent with wifi, cellular and cable modem
> link tchnologies, ACK decimation in middleboxes, and common offloading
> techniques such as TSO and GRO, at end hosts. Previously, BBR was often
> cwnd-limited in the presence of severe ACK aggregation, which resulted in
> low throughput due to insufficient data in flight.
> 
> To achieve good throughput for wifi and other paths with aggregation, this
> patch series implements an ACK aggregation estimator for BBR, which
> estimates the maximum recent degree of ACK aggregation and adapts cwnd
> based on it. The algorithm is further described by the following
> presentation:
> https://datatracker.ietf.org/meeting/101/materials/slides-101-iccrg-an-update-on-bbr-work-at-google-00
> 
> (1) A preparatory patch, which refactors bbr_target_cwnd for generic
>     inflight provisioning.
> 
> (2) Implements BBR ack aggregation estimator and adapts cwnd based
>     on measured degree of ACK aggregation.

Both now queued up, thanks.

greg k-h
