Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DA51F7CA7
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 19:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgFLRvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 13:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgFLRvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 13:51:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1402207ED;
        Fri, 12 Jun 2020 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591984310;
        bh=jE1Kxz2Q5wrlavTl5ZVstoZ1/4ZvO5O8KR250OyGjB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2GWLVH09vN3J8G3JrxTqgRA1rtLQN8CflYHzrglIClD7/pAlMY2Hpfd9Sgga6+yCZ
         uyWsEtFQcmyxbR0tTa8Y+VMjD2HohYsbM0y5W2ChDP+Hx/hopa2UtzSyMjpLAvZH53
         ygcX6VXAZ0AOab9buV0Xkud/7HIxZCsINc84SIok=
Date:   Fri, 12 Jun 2020 10:51:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>
Subject: Re: [RFC,net-next, 1/5] l3mdev: add infrastructure for table to VRF
 mapping
Message-ID: <20200612105148.1b977dc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200612164937.5468-2-andrea.mayer@uniroma2.it>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
        <20200612164937.5468-2-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Jun 2020 18:49:33 +0200 Andrea Mayer wrote:
> Add infrastructure to l3mdev (the core code for Layer 3 master devices) in
> order to find out the corresponding VRF device for a given table id.
> Therefore, the l3mdev implementations:
>  - can register a callback that returns the device index of the l3mdev
>    associated with a given table id;
>  - can offer the lookup function (table to VRF device).
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>

net/l3mdev/l3mdev.c:12:1: warning: symbol 'l3mdev_lock' was not declared. Should it be static?

Please make sure it doesn't add errors with W=1 C=1 :)
