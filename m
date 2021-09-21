Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C4841382F
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 19:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhIURRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 13:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhIURRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 13:17:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B33461002;
        Tue, 21 Sep 2021 17:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632244539;
        bh=GP3b6BkSoLfuF+6Bfd/YpWXuq2PsJoj8ZfdCBCEDsYA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hYssyifClj+WbhpZvvw9bVVqcfIloM16Oyi4MF/OVn4uTqc/L70VvlpxmlUbFYZ6k
         OeejStrkYr3TjqbB1Yz5nDFm+5VwyJQ2tsS2DdLsnTD30KRAHAV0X8HVCOzbFHiUEK
         Qxq2dtf7cuH5EVxWFVr9mve5SNdL7DDRm4YvDKcbv9XJLPN1fDnnxadLrRiE0vwxnI
         ktcrReIwETBgEQ8mHlGkke6rnGZJBNIyZCIqE2VeptjMeBx4zM4saCYHNyK7hDRYne
         s0duyagy57V/NfTtKGELXXvgKBOvqiqHpFklMKUPQ9ALBsuZpk3/uXYTaanQzzMBGf
         tFLW3RS6cIN9A==
Date:   Tue, 21 Sep 2021 10:15:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toms Atteka <cpp.code.lv@gmail.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5] net: openvswitch: IPv6: Add IPv6 extension
 header support
Message-ID: <20210921101538.61f55424@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210920182038.1510501-1-cpp.code.lv@gmail.com>
References: <20210920182038.1510501-1-cpp.code.lv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 11:20:38 -0700 Toms Atteka wrote:
> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> packets can be filtered using ipv6_ext flag.
> 
> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>

Please make sure to check the files you touch with

./scripts/kernel-doc -none

You're adding kdoc warnings by using the /** comments
which are in fact not kdoc-formatted. Please fix and 
repost.

