Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8A547B1AA
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 17:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238621AbhLTQyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 11:54:05 -0500
Received: from mx1.riseup.net ([198.252.153.129]:49744 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239756AbhLTQyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 11:54:04 -0500
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4JHlzb6GChzF2s9;
        Mon, 20 Dec 2021 08:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1640019243; bh=nD8vTA/hBHkxChswGuqYg0d76cid5GoEYlvWYTjinUk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VI6scRk2pt1SixRPHDxCHxL06d/wPyN7gDZf7Z+m6XQDoi2eMosBrqMAMComQlS2b
         vY50a2d5DPvRLagfYjIlw0zRhFNSC0h9KcRcQJwiPEMSce8sbFIMeMD6HQxU4SV/yK
         ny3Hq6YT3BozSRcq0aeK2j5qbSR8ADsN84Pgm47U=
X-Riseup-User-ID: F883E4E81407126B8E89357CC38C77CE2CEDD37E5BA3B94B11559BC62EE30EF6
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4JHlzZ6ysVz5vkm;
        Mon, 20 Dec 2021 08:54:02 -0800 (PST)
Message-ID: <0cd070fe-9879-e033-91bb-4edab71b7f0a@riseup.net>
Date:   Mon, 20 Dec 2021 17:54:01 +0100
MIME-Version: 1.0
Subject: Re: [PATCH net v3] bonding: fix ad_actor_system option setting to
 default
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org
References: <20211218015001.1740-1-ffmancera@riseup.net>
 <1323.1639794889@famine> <43648ff4-90f0-37d8-24c9-50f9b198a3bd@riseup.net>
 <20211220082700.4fd5b84f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Fernando F. Mancera" <ffmancera@riseup.net>
In-Reply-To: <20211220082700.4fd5b84f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/21 17:27, Jakub Kicinski wrote:
> On Mon, 20 Dec 2021 15:53:27 +0100 Fernando F. Mancera wrote:
>> I noticed this patch state in patchwork is "changes requested"[1]. But I
>> didn't get any reply or request. Is the state wrong? Should I ignore it?
> 
> Hm, unclear why. Could you send a v4 with a Fixes tag included and CCing
> all the maintainers suggested by get_maintainer.pl?
> 

Thanks Jakub, will do.
