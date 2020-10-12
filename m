Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A5F28BD4F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 18:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390529AbgJLQLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 12:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389068AbgJLQLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 12:11:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76DEA20797;
        Mon, 12 Oct 2020 16:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602519091;
        bh=6717NMrxGxLa5lMLc4u+7uB/lF1nJHuRiLelAEved5Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uzJ/TQeeEE+iuwEgEBwlxjuaJ76EFlUzjESk3XLaTCxecRBF/5GvOJCwKukrlMJ7A
         OWxlwdftcBTpc835P0s2o81fMxyo1kyIp+NF2Oz8oMYZ/qPU9BQjKRG8tfFVMmVfPC
         xG0I4TdBsfl7t187Jch2wRaXJ7ezldEhP9jB74b4=
Date:   Mon, 12 Oct 2020 09:11:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Reji Thomas <rejithomas@juniper.net>
Cc:     dlebrun@google.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rejithomas.d@gmail.com
Subject: Re: [PATCH SRv6 End.X] Signed-off-by: Reji Thomas
 <rejithomas@juniper.net>
Message-ID: <20201012091129.57b387ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012083749.37076-1-rejithomas@juniper.net>
References: <20201012083749.37076-1-rejithomas@juniper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 14:07:49 +0530 Reji Thomas wrote:
> seg6: Fix End.X nexthop to use oif.
>  Currently End.X action doesn't consider the outgoing interface
>  while looking up the nexthop.This breaks packet path functionality
>  while using link local address as the End.X nexthop.The patch
>  fixes this for link local addresses.
> 
> Signed-off-by: Reji Thomas <rejithomas@juniper.net>

Looks like the subject is broken, please resend.

Also - is this a regression or did it never work? Would be good to see
a Fixes tag.
