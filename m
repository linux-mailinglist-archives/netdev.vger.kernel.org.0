Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11553EDF6F
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhHPVl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233490AbhHPVlx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:41:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C60F160E09;
        Mon, 16 Aug 2021 21:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629150081;
        bh=E1z2lX/2TkVTMAvAW68HUSkN7CsSC6SZE1nbGCGI5is=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o+P74zfMdDfCE1AUgze44n8mYSkcYyWJwTq1luRUtF4ADAQqGsce9dpDdUzBvNlyS
         zyzJsm4i2oMudgyX+8NJwPsDB6J1wuzGjUQHnaB0C+db21xUMs7b81plyfMnB3t1bc
         Gj1vPJZjQZ+RRYPoS3IfJG0WeOL6CBGgF/aWoyeZ6FIhLI3gU83PUf16x+WtEb3NMm
         czf0osq8pHLlKQaed0Z1H0Kn67+V2sYl1OU0wBCXKG5EXEglJzdLCKiLPybohkM6D7
         55q12kdoFRxKSWum1hpQiNGkn+PWvwJqVmkVK7qgoIgolWETeKDs/D0/E8mOeUl7dh
         ql90vWuefm4uA==
Date:   Mon, 16 Aug 2021 14:41:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net
Subject: Re: [PATCH] vrf: Reset skb conntrack connection on VRF rcv
Message-ID: <20210816144119.6f4ae667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d38916e3-c6d7-d5f4-4815-8877efc50a2a@gmail.com>
References: <20210815120002.2787653-1-lschlesinger@drivenets.com>
        <d38916e3-c6d7-d5f4-4815-8877efc50a2a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 12:08:00 -0600 David Ahern wrote:
> On 8/15/21 6:00 AM, Lahav Schlesinger wrote:
> > To fix the "reverse-NAT" for replies.
> 
> Thanks for the detailed explanation and use case.
> 
> Looks correct to me.
> Reviewed-by: David Ahern <dsahern@kernel.org>

I get a sense this is a fix.

Fixes: 73e20b761acf ("net: vrf: Add support for PREROUTING rules on vrf device")
?

Or maybe it fixes commit a0f37efa8225 ("net: vrf: Fix NAT within a
VRF")?
