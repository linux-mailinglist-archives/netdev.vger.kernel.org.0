Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555CC289C5A
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 01:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJIXym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 19:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbgJIXwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 19:52:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A02F5215A4;
        Fri,  9 Oct 2020 23:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602287490;
        bh=EBgVIh6xSwQMCk9kDXmy77vA/h64UHxNkA1V2ObVNHo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fjMbTGUIg98K8MQkO8wcxlSjT8q7p2urwToGNPkaphgMljjLuxk3yTePFgkUxicEH
         +OOlKmUVwuF8269Yxnm0nIBsdzohqG55JbX9hQV7isCSLC6jjmjs+UT8uMU0BHVy5u
         2bu3SpQbNmHPkiBo8Twpr1hyrDGhVastibCFDNOE=
Date:   Fri, 9 Oct 2020 16:51:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net] net/tls: remove a duplicate function prototype
Message-ID: <20201009165129.763f7bf0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201009054900.20145-1-rdunlap@infradead.org>
References: <20201009054900.20145-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 22:49:00 -0700 Randy Dunlap wrote:
> Remove one of the two instances of the function prototype for
> tls_validate_xmit_skb().
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks.
