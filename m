Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615562B8556
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgKRUJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgKRUJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:09:47 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3DB62100A;
        Wed, 18 Nov 2020 20:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605730187;
        bh=/3r0ST05xJSzGUnRqs6k7/gzVgXvpCVKmESDDqVZ7oY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CntlHIoipoc39ssSbL8KbTkJjbu43zhTFzl7olRgQz6LFwz9vTfVlTqmRbZ7AZLMJ
         uUNbJz2PXyZoiFp9j72jGWpLzo8nN6Cvub3DawFuYR75tEklQFz3zKCdrQENVdB+NC
         zcXIiI2QjaUfWMwLbQrzzHpwTLRSyNyILGfC3m2c=
Date:   Wed, 18 Nov 2020 12:09:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     siddhant gupta <siddhantgupta416@gmail.com>
Cc:     Tom Parkin <tparkin@katalix.com>, davem@davemloft.net,
        corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mamta Shukla <mamtashukla555@gmail.com>,
        Himadri Pandya <himadrispandya@gmail.com>
Subject: Re: [PATCH] Documentation: networking: Fix Column span alignment
 warnings in l2tp.rst
Message-ID: <20201118120945.468701ab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CA+imup-3pT47CVL7GZn_vJtHGngNexBR060y2gRfw2v5Gr8P0Q@mail.gmail.com>
References: <20201117095207.GA16407@Sleakybeast>
        <20201118102307.GA4903@katalix.com>
        <CA+imup-3pT47CVL7GZn_vJtHGngNexBR060y2gRfw2v5Gr8P0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 16:44:11 +0530 siddhant gupta wrote:
> On Wed, 18 Nov 2020 at 15:53, Tom Parkin <tparkin@katalix.com> wrote:
> >
> > On  Tue, Nov 17, 2020 at 15:22:07 +0530, Siddhant Gupta wrote:  
> > > Fix Column span alignment problem warnings in the file
> > >  
> >
> > Thanks for the patch, Siddhant.
> >
> > Could you provide some information on how these warnings were
> > triggered?  Using Sphinx 2.4.4 I can't reproduce any warnings for
> > l2tp.rst using the "make htmldocs" target.
> >  
> 
> I am currently using Sphinx v1.8.5 and I made use of command "make
> htmldocs >> doc_xxx.log 2>&1" for directing the errors into a file and
> the statements in the file showed me these warning, also to confirm
> those I tried using "rst2html" on l2tp.rst file and got same set of
> warnings.

No errors here either, Sphinx 2.2.2, unless Documentation/ has some
explicit rule about this let's not reshuffle text for an old version 
of the compiler.
