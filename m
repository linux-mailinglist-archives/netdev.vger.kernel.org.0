Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4EE2F6EE7
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbhANXVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:21:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730611AbhANXVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 18:21:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D44223A59;
        Thu, 14 Jan 2021 23:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610666459;
        bh=4AvcktsqhF9eIbCN8RiHlOi8KkSMVaQLSIIGFCdVXnA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=drOi6LvdpVF1tMkWLk7C5LkaYn5tHzMn3UAolCm0sfwEwY7OhuM4nOkUfOmmCB6Uh
         idtJ5KJ9ScCQHvHhrTZRJSYPcLYXZj0+0E8i+YGYjzJv5DtzPH5Jz8cOnH2A0c2GdJ
         CWuuCYRGuLjJOuIwm+cBTIq8WYbTXngcLz4mOopBvKmmZTCoyKA4N8ywPMsFuFDgFM
         C09WlKtvwoiUd6vjdmdcnBQSa/FcSq6yoCE9GUUUbp84wqRgLutZE6CksWsBWGbRJu
         KMYotpWI0oetqF7Zf0dcQiWUCAJ52Th88lESCvakR/Ffk0u2ZZrZipnB1J49YIYxeq
         jXrIXAq2sFFvw==
Date:   Thu, 14 Jan 2021 15:20:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210114152058.704c9f6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <13348f01-2c68-c0a6-3bd8-a111fb0e565b@intel.com>
References: <20210113121222.733517-1-jiri@resnulli.us>
        <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <13348f01-2c68-c0a6-3bd8-a111fb0e565b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 14:58:33 -0800 Jacob Keller wrote:
> > There is no way to tell a breakout cable from normal one, so the
> > system has no chance to magically configure itself. Besides SFP
> > is just plugging a cable, not a module of the system.. 
> >   
> If you're able to tell what is plugged in, why would we want to force
> user to provision ahead of time? Wouldn't it make more sense to just
> instantiate them as the card is plugged in? I guess it might be useful
> to allow programming the netdevices before the cable is actually
> inserted... I guess I don't see why that is valuable.
> 
> It would be sort of like if you provision a PCI slot before a device is
> plugged into it..

Yup, that's pretty much my thinking as well.
