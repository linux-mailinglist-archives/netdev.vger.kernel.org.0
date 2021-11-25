Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DB845D354
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbhKYC6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:58:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:57786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235580AbhKYC4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 21:56:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A76B160EB5;
        Thu, 25 Nov 2021 02:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637808804;
        bh=Hwqmr/5nncY5o45+f92lX611dQRF4mAgRbLCnwwKbMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i7+JtNjg557ik2oXjaz/6WuFe5NfL2Pqgcq1e2WiCIN3z6r93BimK47+O+vspN/e+
         MgBVSloxTfMeNKl+W8jTYIUOkYkykkqTl1eK7zRrCz5KKCHoaUnc//rKx4sR1aMmdA
         HjmOJ6625iRU/SJY4AXdgcoXzAMbMBoXAw1FMMe6vc2tp5KO3L1ZnttjANRlOES2lF
         K2LFM3eawDKx8aoRLKJQSkJT2E/xG3rgIf1e89JLlrjxS4ZDtSp+KXCXm0aIwC+6pm
         Of/CJ91DUQqC3pu4IF52XS0vwzUykPmLmzpYkXEA9aeqS8L4v/4cyhpJPsUA64VBkz
         OedN7VgF4jC6w==
Date:   Wed, 24 Nov 2021 18:53:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>
Subject: Re: [PATCH net-next 2/2] qed*: esl priv flag support through
 ethtool
Message-ID: <20211124185323.65a2055f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124094303.29390-3-manishc@marvell.com>
References: <20211124094303.29390-1-manishc@marvell.com>
        <20211124094303.29390-3-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 01:43:03 -0800 Manish Chopra wrote:
> This patch adds relevant qed APIs to get ESL (enhance system lockdown)
> capabilities and current status for ESL, which can be queried via qede
> .get_priv_flags() ethtool interface

You need to spell out what this feature is and what it does.
Speaking of spelling s/enhance/enhanced/.
