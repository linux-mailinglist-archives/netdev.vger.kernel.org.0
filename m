Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19A525FE72
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbgIGQQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730344AbgIGQOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:14:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE02A206E6;
        Mon,  7 Sep 2020 16:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599495290;
        bh=6GpQErjhpehSxKS2a6mV9lmGdp/0Loo/7V5dDQhOCVQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aaLWzl3VEKcqHWMl+1wgD17WL4lnmN0i9R6HaWh7dFKZ432F3GL8Y6s813PXqfa3s
         1Ia2Hd/1qXhSpvW2VCK5QVu+6Adawl37I80IIpWioFFPBfQ3bvWXHFyEnlH6cJj81B
         g1t7ZP7H+zqb8lX+wu8FZEyOitkPLjC3VWd6LxEw=
Date:   Mon, 7 Sep 2020 09:14:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>, jtoppins@redhat.com,
        Netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: Failing to attach bond(created with two interfaces from
 different NICs) to a bridge
Message-ID: <20200907091448.35df5bc1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907073635.GA2455115@shredder>
References: <CAACQVJo_n+PsHd2wBVrAAQZm9On89TcEQ5TAn7ZpZ1SNWU0exg@mail.gmail.com>
        <20200903121428.4f86ef1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200906111249.GA2419244@shredder.lan>
        <20200906101335.47b2b60b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0502c0a4-0c2e-65d8-cd1e-860856510391@gmail.com>
        <20200907073635.GA2455115@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 10:36:35 +0300 Ido Schimmel wrote:
> I can test the patch in our regression and submit later this week unless
> you have a better suggestion. Please let me know.

That'd be great!
