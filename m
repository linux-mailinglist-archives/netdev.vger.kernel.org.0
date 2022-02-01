Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA424A590E
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 10:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbiBAJS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 04:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbiBAJS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 04:18:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DEFC061714;
        Tue,  1 Feb 2022 01:18:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FCE3614C6;
        Tue,  1 Feb 2022 09:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA35C340EB;
        Tue,  1 Feb 2022 09:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643707135;
        bh=R7Ti4uI3G/j3QMxStgzavS8hxG9gK9/HB64jBoOyH+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JY8uiUMJ50ExSA+zhYSdE5dUQIQcWq+phdwVS+CGN4E3CVU6Ocvb32R1+vBZWoDhL
         hPzU3zjqhiG/S7n41F/buQJcp4vwJfR6ujdkmGeKCZ9d/Lx7UfJhqTWmr9yCQzGz+t
         YK2BtrIy7dqxkPVPAr4qr20cZU6VstbxRtaFJfEg=
Date:   Tue, 1 Feb 2022 10:18:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Antony Antony <antony.antony@secunet.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eyal Birger <eyal.birger@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] xfrm: fix the if_id check in changelink
Message-ID: <Yfj6/PtvOlqwkM4r@kroah.com>
References: <20220126215937.GA31158@duo.ucw.cz>
 <ca25f9904d2a4acebdc02b1c054aaeab25d99cc5.1643698195.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca25f9904d2a4acebdc02b1c054aaeab25d99cc5.1643698195.git.antony.antony@secunet.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 07:51:57AM +0100, Antony Antony wrote:
> if_id will be always 0, because it was not yet initialized.
> 
> Fixes: 8dce43919566 ("xfrm: interface with if_id 0 should return error")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> ---
>  net/xfrm/xfrm_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
