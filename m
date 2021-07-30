Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3BF3DB9DC
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbhG3N6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238992AbhG3N6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 09:58:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 943C560EFF;
        Fri, 30 Jul 2021 13:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627653511;
        bh=o3s3lHJGt0ZOZjGD2QpvAFQRoJWO6M2o+Q+jguEiV1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fav0wiFGmsCo3YTn48hVWFIU0lm31e1Ni2JXr0/zIHy+RFVTvPambXkCvx6IQh2ZL
         MZ+q6uaeIPZ93+eIwolhCaViF1+dydc2j5charaZrKfOMBv+KWQM3qTs0n4IzoEOmR
         dmkuXkE1OoleS2UXhuPIGrGzbKAwGcUU4yOOe+0Gx3PIilG7Qckz8z2X1kq7srQGoR
         Pl9o1MQdo3EdTq76XV4hRIkc/6Q/iLg1LWAWhDHaLpefn1F9jsyOezSWe6bPcQeeHH
         0r7eQEvL2IJIVi0BB5hygoomfCoSICQGPhb/siHNV6xSEBKPqvgxQnPsRn5N7yJ4vb
         Fy+Xp0BGk6wcA==
Date:   Fri, 30 Jul 2021 06:58:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/8] nfc: hci: pass callback data param as pointer in
 nci_request()
Message-ID: <20210730065830.547df546@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <53f89bae-fcb5-8e7c-0b03-effa156584fe@canonical.com>
References: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
        <20210730065625.34010-8-krzysztof.kozlowski@canonical.com>
        <20210730064922.078bd222@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <53f89bae-fcb5-8e7c-0b03-effa156584fe@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 15:56:19 +0200 Krzysztof Kozlowski wrote:
> On 30/07/2021 15:49, Jakub Kicinski wrote:
> > This generates a bunch of warnings:
> > 
> > net/nfc/nci/core.c:381:51: warning: Using plain integer as NULL pointer
> > net/nfc/nci/core.c:388:50: warning: Using plain integer as NULL pointer
> > net/nfc/nci/core.c:494:57: warning: Using plain integer as NULL pointer
> > net/nfc/nci/core.c:520:65: warning: Using plain integer as NULL pointer
> > net/nfc/nci/core.c:570:44: warning: Using plain integer as NULL pointer
> > net/nfc/nci/core.c:815:34: warning: Using plain integer as NULL pointer
> > net/nfc/nci/core.c:856:50: warning: Using plain integer as NULL pointer  
> 
> Indeed. Not that code before was better - the logic was exactly the
> same. I might think more how to avoid these and maybe pass pointer to
> stack value (like in other cases).
> 
> The 7/8 and 8/8 could be skipped in such case.

We don't usually take parts of series, would you mind resending first 6
or respinning with the warnings addressed?

> > BTW applying this set will resolve the warnings introduced by applying
> > "part 2" out of order, right? No further action needed?  
> 
> Yes, it will resolve all warnings. No further action needed, at least I
> am not aware of any new issues.

Great, thanks!
