Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FE42B9F9A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgKTBRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgKTBRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 20:17:07 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846B622254;
        Fri, 20 Nov 2020 01:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605835027;
        bh=L+eijTQenX55nG8tcos9FVKuiqU3ACZAfe09Hkle9IA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hxW8EjAX14csEtrpHor0iC4TpsUDinoN9DR5kvzPy9CsEOrcAtf7se9WyI77VgYhF
         FmNwZKFnChGPoclTZyhWjFSiQd4k4X/6TJ+SOpB5fVloa+Ydb7KcK4i1tvbTzkUk5H
         6nDELatDBy9IMfIqVAZMZwbVIZNJLEmmezsBJ0ms=
Date:   Thu, 19 Nov 2020 17:17:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201119171705.02bd6142@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118202453.GB27575@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
        <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201110092834.GA30007@linux.home>
        <20201110084740.3e3418c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201118202453.GB27575@linux.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 21:24:53 +0100 Guillaume Nault wrote:
> Here's a high level view of:
>   * the protocol,
>   * the kernel implementation,
>   * the context of this RFC,
>   * and a few pointers at the end :)
> 
> Hope this helps. I've tried to keep it short. Feel free to ask for
> clarifications and details.

Thanks of the write up, much appreciated!
