Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD94ADFB2
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 21:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405904AbfIITyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 15:54:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33290 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730465AbfIITyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 15:54:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5F4DA6050D; Mon,  9 Sep 2019 19:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568058885;
        bh=0Y5RJGwYszMax0e5oQ2MqEGWVwn6xKyFpRRCX20USas=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ULCoXa8IBEAJ9v6pzbirwB844a4ZsjZP+lMBs2KCbD2y3e341vbtUvmSG50FbrRRp
         lra2UEGyf/Z8sUTjfTFJN7XmgrLzJQVHbIpw22tPnxi0qxgS2sbjpNfd46D7qhzaHV
         SysSDmO8kzw3vBJQcLfXjsTCcBnY/CzhZk+uKELw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id B5A2D6030B;
        Mon,  9 Sep 2019 19:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568058884;
        bh=0Y5RJGwYszMax0e5oQ2MqEGWVwn6xKyFpRRCX20USas=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gu4XOgzPUFUL7y/qpwqRIl3lhvEoYpjSUmgTTlumsoaBh5CLfGz48emDYFctvztiv
         O0/GsA+3kZC9wdUKMgwcXrFIMxgzWf2RI5GWriUNrr+axGEVfnPjvouog9d0+oFp/6
         wNk9jAsuqvjszVLAOrp3VXjHUEWd4GmFiUn8J8KQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 09 Sep 2019 12:54:44 -0700
From:   Jeff Johnson <jjohnson@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Mark Salyzyn <salyzyn@android.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2] net: enable wireless core features with
 LEGACY_WEXT_ALLCONFIG
In-Reply-To: <6f3487136e71afbd4d2b621551ee14e68c4cc1ab.camel@sipsolutions.net>
References: <20190906192403.195620-1-salyzyn@android.com>
 <20190906233045.GB9478@kroah.com>
 <b7027a5d-5d75-677b-0e9b-cd70e5e30092@android.com>
 (sfid-20190909_162434_303033_C0355249)
 <6f3487136e71afbd4d2b621551ee14e68c4cc1ab.camel@sipsolutions.net>
Message-ID: <5d78042c98d35bc9f9822e2de6d16ec8@codeaurora.org>
X-Sender: jjohnson@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-09 08:44, Johannes Berg wrote:
> Also, you probably know this, but in this particular case you really
> should just get rid of your wext dependencies

This.

Particularly for one out-of-tree driver with which I'm intimately 
familiar there has been considerable recent work to make all WEXT code 
correctly conditional, and nothing in the Android support should be 
reliant upon WEXT.
