Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083282F03D8
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 22:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbhAIVcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 16:32:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbhAIVcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 16:32:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7256223A82;
        Sat,  9 Jan 2021 21:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610227922;
        bh=vpjvYItxsvIXqCPEidl2x1OQy8+i1ksGrksjDTbV23s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LDMrxcfBwJ55mjE6WPcFNNPRkrzv7mnl7zzCxZDqA1LWt8KQOmEX3Mldo2Ta/VH1a
         30c/l+6gubC/t6Pb009dYFOzrww7BFSl67d49MVSTWkku0l4YgK4eEuui1bSRtvqaS
         7+AgbkVNe9LCUf8h79DasRtRHqwg2+YAEb10EnTPx8tWCWhlJHf/Of3CkVrLcwJt86
         7blCd1cF5dxw+KqYhzBGmV7SBQZEKXfy4pqhkEk6ET+9M6QfT2Dn9WQWih51dB8rgF
         NqAaJqlR3sXaMTwRQsbwuQuzVcAGwqYxiL2XRT4ya64HP+lMf3K7lOtL2K4vPnhZkj
         55K3YGBsu8n4A==
Date:   Sat, 9 Jan 2021 22:31:53 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH] changes for Pavana
Message-ID: <20210109223153.63ad91ee@kernel.org>
In-Reply-To: <20210108143658.4176-1-kabel@kernel.org>
References: <0044dda2a5d1d03494ff753ee14ed4268f653e9c.1610071984.git.pavana.sharma@digi.com>
        <20210108143658.4176-1-kabel@kernel.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Still one more change needed for 5gabe-r to work.
I am going to sent fix 5gbase-r and send this patches myself. I will
leave Pavana as the author.

Marek
