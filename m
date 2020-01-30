Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F5714DA34
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 12:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgA3LxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 06:53:16 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:57224 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbgA3LxO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 06:53:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 56C8120538
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 12:53:13 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id z1glNPLUSDAw for <netdev@vger.kernel.org>;
        Thu, 30 Jan 2020 12:53:12 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A8A932056D
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 12:53:12 +0100 (CET)
Received: from [10.182.7.178] (10.182.7.178) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 30 Jan
 2020 12:53:11 +0100
Subject: Re: [PATCH net] xfrm: Interpret XFRM_INF as 32 bit value for non-ESN
 states
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     <netdev@vger.kernel.org>
References: <8a3e5a49-5906-b6a6-beb7-0479bc64dcd0@secunet.com>
 <20200130103432.GK27973@gauss3.secunet.de>
From:   Thomas Egerer <thomas.egerer@secunet.com>
Openpgp: preference=signencrypt
Message-ID: <6aed470f-d1ff-e939-3b1a-80237e9ab84f@secunet.com>
Date:   Thu, 30 Jan 2020 12:52:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20200130103432.GK27973@gauss3.secunet.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Steffen,

On 1/30/20 11:34 AM, Steffen Klassert wrote:
> On Mon, Jan 27, 2020 at 03:31:14PM +0100, Thomas Egerer wrote:
> 
> You need one more close bracket here:
> 
> /home/klassert/git/ipsec/net/xfrm/xfrm_user.c: In function ‘copy_from_user_state’:
> /home/klassert/git/ipsec/net/xfrm/xfrm_user.c:509:45: error: expected ‘)’ before ‘{’ token
>   if ((x->props.flags & XFRM_STATE_ESN) == 0 {
>                                              ^
> /home/klassert/git/ipsec/net/xfrm/xfrm_user.c:515:1: error: expected expression before ‘}’ token
>  }
>  ^
> 
> Please fix and resend.
You're right. I wonder how that could have happened. I will rebuild
and make sure, I tested the kernel version including the patch and
not the one without.


Thomas
