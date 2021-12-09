Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607C246E038
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhLIB0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhLIB0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:26:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720D7C061746;
        Wed,  8 Dec 2021 17:23:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BCB4ACE2331;
        Thu,  9 Dec 2021 01:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E04AC00446;
        Thu,  9 Dec 2021 01:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639012985;
        bh=EGS1FaDteRYlhuhWyVYrG25WcZzElFOzCSjsr/Y8ipE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qFW65xA2LuO0ZVGFZstwcZRcKox4eimF8P7HV2lstZUnhhrAuV/ln4zVBCadRemKY
         ojtY3yBMct6lTugdFczFvaKTLim4eNQbOcRmy48MAks4ZRN69UqpGTkJkTsX1nN04z
         j8HtYZ/RsPK7xrCVr4nqfTy1mWto+/TzYjQEOJIVMkwU2Q0uYnyqu41d0Pfgccno0W
         2djurTPGytNfutBbKFcWVAkuR1s0gfz0vaVqBvT4MoLpL+OTkGxwuaHdnZJc2N6TeK
         DJyk+obaAfwEkRuRYPSrRnI/H40gyNodXqSVP1UB8l3zOhw24onFRR7L/ASoH88P+S
         eTHYoJN484Vng==
Date:   Wed, 8 Dec 2021 17:23:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jie2x Zhou <jie2x.zhou@intel.com>
Cc:     davem@davemloft.net, shuah@kernel.org, dsahern@gmail.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, xinjianx.ma@intel.com,
        zhijianx.li@intel.com, Philip Li <philip.li@intel.com>,
        zhoujie <zhoujie2011@fujitsu.com>
Subject: Re: [PATCH] selftests: net: Correct ping6 expected rc from 2 to 1
Message-ID: <20211208172303.58ca2706@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208061518.61668-1-jie2x.zhou@intel.com>
References: <20211208061518.61668-1-jie2x.zhou@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Dec 2021 14:15:18 +0800 Jie2x Zhou wrote:
> From: zhoujie <zhoujie2011@fujitsu.com>

> Signed-off-by: Jie2x Zhou <jie2x.zhou@intel.com>

Ah, so you are the same person, I was wondering :)

You need to either drop the From: with the fujitsu address (git commit
--amend --reset-autor) or sign off the patch with the Intel address.
Right now both your name is spelled differently and the address is
different so the patch will trigger warnings.
