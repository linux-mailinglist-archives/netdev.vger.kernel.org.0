Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E7B30E3F8
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhBCUU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhBCUU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 15:20:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 794DD64F6C;
        Wed,  3 Feb 2021 20:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612383585;
        bh=+k1Gx+xT3UifRN5KNemtToFBdxisLXgyYa4rtLWXSlg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=izvipybIPbvKjjw6vZqwhn/+ebJqBNuqFuPzv1VOzGWF0r7PaztNbBG0RuDaE53oy
         ZK+0gaIwN+qKTzRzWiGQIxPRpQzbA0HCUqiZ4Y5q0dpcb9xrrlBkj20yl6STtE/r6P
         d7b5wkkKsxGGM9OxTVxUecBapnWEAV7oWVbzNiVc9zivolOOIN+h7boijHsE3yWs2R
         ljPR4oxHMWJ7JYkjwSwx25AUWzWU1iBdh4U2mndPJzJISWAVNjlwtJ6Tsf4wrFJ4P1
         Y4plxP2mGtT0gNysJPfQ+Br7VxSM1r0Z7FLfW+NuZgU9OcgUyUwg9eTIGSm+RUyeSz
         l0QWS2944Cr0g==
Date:   Wed, 3 Feb 2021 12:19:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     laforge@gnumonks.org, netdev@vger.kernel.org, pablo@netfilter.org,
        Pravin B Shelar <pshelar@ovn.org>
Subject: Re: [PATCH net-next v2 0/7] GTP
Message-ID: <20210203121944.558760ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203070805.281321-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
        <20210203070805.281321-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 08:07:58 +0100 Jonas Bonn wrote:
> There's ongoing work in this driver to provide support for IPv6, GRO,
> GSO, and "collect metadata" mode operation.  In order to facilitate this
> work going forward, this short series accumulates already ACK:ed patches
> that are ready for the next merge window.
> 
> All of these patches should be uncontroversial at this point, including
> the first one in the series that reverts a recently added change to
> introduce "collect metadata" mode.  As that patch produces 'broken'
> packets when common GTP headers are in place, it seems better to revert
> it and rethink things a bit before inclusion.

Thanks, build cleanly now! Please make sure to CC the author of the
patch you're reverting or fixing.

