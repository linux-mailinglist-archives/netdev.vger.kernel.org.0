Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288F22B826C
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbgKRQ4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:56:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726431AbgKRQ4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 11:56:13 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B85E2485E;
        Wed, 18 Nov 2020 16:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605718572;
        bh=qHBOjS62GZvlfi+y6fxk8MleiEDGan2cfoMzQPJaiE4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yYJeeFC4L/JS0G662FZJ7GuqpyI2eW+l02rGJdGgGYqh8nwgm4CxcJawRK6jdMJjj
         jXTyxXUzRqWe36pRYEkq0am8pWFXKz3FBUl3DO4MGzpXizAeX3el0/iGBUywT0ghFo
         cPcASNaANnlikAZMayHk+QjxtnW5nwgTd3K0gd2U=
Date:   Wed, 18 Nov 2020 08:56:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 5/6] selftests: refactor get_netdev_name
 function
Message-ID: <20201118085610.038b5ae4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118090320.wdth32bkz3ro6mbc@yoda.fritz.box>
References: <20201117152015.142089-1-acardace@redhat.com>
        <20201117152015.142089-6-acardace@redhat.com>
        <20201117173520.bix4wdfy6u3mapjl@lion.mk-sys.cz>
        <20201118090320.wdth32bkz3ro6mbc@yoda.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 10:03:20 +0100 Antonio Cardace wrote:
> Do I have to resend the whole serie as a new version or is there a
> quicker way to just resend a single patch?

Just repost the series as v5, it's the least confusing way.
Changelog from version to version would be good. You can put 
it in the cover letter.
