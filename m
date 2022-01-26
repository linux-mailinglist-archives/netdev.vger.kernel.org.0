Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701C549C287
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 05:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiAZEKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 23:10:41 -0500
Received: from matrix.voodoobox.net ([172.105.149.185]:55044 "EHLO
        voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbiAZEKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 23:10:40 -0500
X-Greylist: delayed 3802 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jan 2022 23:10:40 EST
Received: from [192.168.0.126] (c-67-180-109-87.hsd1.ca.comcast.net [67.180.109.87])
        (authenticated bits=0)
        by voodoobox.net (8.14.4/8.14.4) with ESMTP id 20Q375fK024619
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 25 Jan 2022 22:07:06 -0500
DKIM-Filter: OpenDKIM Filter v2.11.0 voodoobox.net 20Q375fK024619
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thedillows.org;
        s=default; t=1643166426;
        bh=YeFEtV02xDOJWEucfGEL5vE90Vu2gs4iZ1P549zKWb4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Vkae+H4k5oHLX648/2C1Gv92TCpSC8WBKdIctZKtt5RkeCLuvkqDzntMvfN3WC49v
         eBx9EWCz5g/yUgWhvthF//fMGdXYfFaeJ8r8rN5JNKwGkXgFSnd51uPANCh/hkcGD2
         O3W5TFzCa4/ChK2B3X8g7aHW91QyQPOd2K0T5o+4rAfd/AQF65N1htjnCv9MmO8id4
         0v4iomoJR/AnToZnAqvqwBXYuiXcTEHUskyi1S7RWwgpNOtLS60fHPThOlv7oH4f6F
         oaWu/nK0HTR+3qeYbWbV0QBtBuPBW1lE7cp9P9VxCN39P875ROqMalHLInbKk3a21Y
         g6qdMpzyxPVAA==
Message-ID: <f37db63e287cf0f061c6a7ff1b53e4168d050c2c.camel@thedillows.org>
Subject: Re: [PATCH net 1/3] ethernet: 3com/typhoon: don't write directly to
 netdev->dev_addr
From:   David Dillow <dave@thedillows.org>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Date:   Tue, 25 Jan 2022 19:07:05 -0800
In-Reply-To: <20220125222317.1307561-2-kuba@kernel.org>
References: <20220125222317.1307561-1-kuba@kernel.org>
         <20220125222317.1307561-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-01-25 at 14:23 -0800, Jakub Kicinski wrote:
> This driver casts off the const and writes directly to netdev-
> >dev_addr.
> This will result in a MAC address tree corruption and a warning.
> 
> Compile tested ppc6xx_defconfig.
> 
> Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks!

Acked-by: David Dillow <dave@thedillows.org>
