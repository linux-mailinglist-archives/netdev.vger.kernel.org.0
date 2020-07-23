Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A7822B3D5
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgGWQoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbgGWQoD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 12:44:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1552920714;
        Thu, 23 Jul 2020 16:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595522643;
        bh=GBe7kp+jLs4gUwYyGb/MUASq8qDgT4aYjsbIP7CB1y0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sd/ZauW2T5Oz62+W0TZNr88tonlLVDyGXg8d2MSP6UVCj4assdoyvHhnElE60jL0o
         eKhcoJYAbzD2Cul9kz1h3oGxAdS2Cgsd5pdqL/W//XTc73J0V2PS0fXLFl+awlUi4c
         tHzRazc913qoznu9YgasKBiBXZUn5gIOyTZkthQU=
Date:   Thu, 23 Jul 2020 09:44:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next 3/3] icmp6: support rfc 4884
Message-ID: <20200723094401.58e8fe0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200723143357.451069-4-willemdebruijn.kernel@gmail.com>
References: <20200723143357.451069-1-willemdebruijn.kernel@gmail.com>
        <20200723143357.451069-4-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jul 2020 10:33:57 -0400 Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Extend the rfc 4884 read interface introduced for ipv4 in
> commit eba75c587e81 ("icmp: support rfc 4884") to ipv6.
> 
> Add socket option SOL_IPV6/IPV6_RECVERR_RFC4884.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>

net/ipv6/datagram.c:288:6: warning: symbol 'ipv6_icmp_error_rfc4884' was not declared. Should it be static?
