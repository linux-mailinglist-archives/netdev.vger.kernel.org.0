Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7099136E10F
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 23:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhD1Vjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 17:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhD1Vjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 17:39:48 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8076C06138B;
        Wed, 28 Apr 2021 14:39:02 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8518F22249;
        Wed, 28 Apr 2021 23:39:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1619645940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oc8VT423SVnxG0+7D21xk+84j2RF89khCSkfQNJZ3p0=;
        b=deoI286cXPqlfnGs1RcLyiff5lIFmfDXYraaEAn4E5f3txw0fllNToPlyY+8oDeJLEsRII
        Pon4HgeN3npecyBDG/EuZd+rlYG/pCKrDJ/jeS3zJ/MddngsQOKOqcU9T3iKiObwdui1fe
        7YrL1tMnUkq/IevXdg7kXMcfPH58ipc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 28 Apr 2021 23:39:00 +0200
From:   Michael Walle <michael@walle.cc>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: remove Wingman Kwok
In-Reply-To: <20210428135443.7c1ef0f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210428085607.32075-1-michael@walle.cc>
 <20210428135443.7c1ef0f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <163af71165cb8a2025026fea8236e4f2@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-04-28 22:54, schrieb Jakub Kicinski:
> On Wed, 28 Apr 2021 10:56:06 +0200 Michael Walle wrote:
>> His email bounces with permanent error "550 Invalid recipient". His 
>> last
>> email on the LKML was from 2015-10-22 on the LKML.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> FWIW does not apply to any networking tree, whose tree
> are you targeting?

This was on linux-next. I'm not sure through what tree
these changes will go. I included all the original "L:"
here.

I can rebase it onto net-next (or wait until after
the merge window closes).

-michael
