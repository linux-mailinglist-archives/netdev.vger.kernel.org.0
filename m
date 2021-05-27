Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79203923D5
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 02:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhE0Ahl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 20:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231911AbhE0Ahk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 20:37:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 046DE613AC;
        Thu, 27 May 2021 00:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622075768;
        bh=jIQEk1yaM1391ez56Nbz7s3yl3R4VYtNM2OHZXUfxDQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iCzT6FtsBEaAzRhQ0loO9ragmgtRILbId1c9eJ6CM/pEGN9w8aTlfcc5TPC9yMpk3
         t7D/Ck6uAV6phec3/a62hNvP11qkqjDUbt0Piu6t17DfXvvJ1vb/09hISJuD4LPH3a
         xFYHKU7W2TfVxzV6UB1ZmAeAvdHEJkLZo87imEmWPnIrt+8imzfZXW/wOLjxv8gbo0
         KPuTRIiqatzk+ct35YE7SIex9Y/4WTUJatYsXwJdiyW/Zvpf/1Xb71JqVbiCFFwiRm
         zPpGTB3Bxz995SvAtvIbaLlQndxhidVw+STOfZf0ZFFxbE/k702T2gizt/ZRjwH2/0
         EGI00DAf969Yg==
Date:   Wed, 26 May 2021 17:36:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [RESEND PATCH net-next v3 4/5] ipv6: ioam: Support for IOAM
 injection with lwtunnels
Message-ID: <20210526173607.5c9e6a84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210526173402.28ce9ef0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210526171640.9722-1-justin.iurman@uliege.be>
        <20210526171640.9722-5-justin.iurman@uliege.be>
        <20210526173402.28ce9ef0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 17:34:02 -0700 Jakub Kicinski wrote:
> Please address the warnings from checkpatch --strict on this patches.

I meant to say "this patch", the warnings in patch 1 seem to be related
to unnamed bitfields, those can be ignored.
