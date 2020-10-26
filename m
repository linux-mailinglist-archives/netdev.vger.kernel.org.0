Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33092988B0
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 09:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769901AbgJZInJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 04:43:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1769633AbgJZInJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 04:43:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603701787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tdIefJ/S5T1RvOULWYU5XkYeJYKRh3p/OM7cFDJ9io4=;
        b=CCPfFslS/NxVOdEwBoGWzsKfl5CFR5ZcJmpOz6fpQduKGK+/nw8ktIyxgt4T1TqizT3fwD
        aM4wGBjeroEq9Vjk0yOZTCXe9U8oPtPtjbl+DQop0FcbKeRG725b9JILFE+mY11DGPcdA1
        CqPe5JuJ27+/H5vB5xtXrMaFy9X8wIU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-5YK_OBEgOPuZIqSKIfYbqA-1; Mon, 26 Oct 2020 04:43:04 -0400
X-MC-Unique: 5YK_OBEgOPuZIqSKIfYbqA-1
Received: by mail-wr1-f70.google.com with SMTP id t3so8077864wrq.2
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 01:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tdIefJ/S5T1RvOULWYU5XkYeJYKRh3p/OM7cFDJ9io4=;
        b=VoY5lTnjZZJSrCDhbiGQQrPU1XrKwqiXENR7+SYOB41nd00C9YIh4TcG4MaMhF1hQP
         TChPrJbVj/OFpIQTfiDMaeyZu3CREsPovvlNEfoxZj0XbOJHCEP4c3U1Wr3F+WwPdbwO
         O8DW533GX5T4I6wfpZDO4sNRRRq8HOLKxmEajYyobo2Y3qz25jUw+O+oQLoJT7dk8tJJ
         mBZxpmUj/8RsaOcWc6PZYJvwSyRkhzViUWTu/wroS2Ath8smcWJMT5sh8rTTSwCUIscm
         hYpd5XE2UGVIFsxdcbbCJ6HHdbZJ12UYF2yxfcqKqJVYueOZwtgOVRPa9HKpWYnaHgjF
         bS0A==
X-Gm-Message-State: AOAM533xCPKp+Xbbs85WzLh5lHES4QeM0Ulej5XOAX33rp9nQZZLjIq4
        tk5DhqrNgpBKM5olTVENs/lZQNAovIfz8TMQhMeJKbjKOF+1PuTWsIhC0GsPF2G5TD3/6Pmi/CN
        bCCF+oVoqDMZWOCV5
X-Received: by 2002:adf:fd49:: with SMTP id h9mr17312835wrs.115.1603701783548;
        Mon, 26 Oct 2020 01:43:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6qoLrHt7rz+8meQEIZn3c7vEx/gDRaWJUKYdtFkGhU3fruxF70yzU08kRzQLI3t1PCPEXxA==
X-Received: by 2002:adf:fd49:: with SMTP id h9mr17312822wrs.115.1603701783324;
        Mon, 26 Oct 2020 01:43:03 -0700 (PDT)
Received: from steredhat (host-79-17-248-215.retail.telecomitalia.it. [79.17.248.215])
        by smtp.gmail.com with ESMTPSA id k18sm20625387wrx.96.2020.10.26.01.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 01:43:02 -0700 (PDT)
Date:   Mon, 26 Oct 2020 09:43:00 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsock: ratelimit unknown ioctl error message
Message-ID: <20201026084300.5ag24vck3zeb4mcz@steredhat>
References: <20201023122113.35517-1-colin.king@canonical.com>
 <20201023140947.kurglnklaqteovkp@steredhat>
 <e535c07df407444880d8b678bc215d9f@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e535c07df407444880d8b678bc215d9f@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 09:30:59PM +0000, David Laight wrote:
>
>From: Stefano Garzarella
>> Sent: 23 October 2020 15:10
>>
>> On Fri, Oct 23, 2020 at 01:21:13PM +0100, Colin King wrote:
>> >From: Colin Ian King <colin.king@canonical.com>
>> >
>> >When exercising the kernel with stress-ng with some ioctl tests the
>> >"Unknown ioctl" error message is spamming the kernel log at a high
>> >rate. Rate limit this message to reduce the noise.
>> >
>> >Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> >---
>> > net/vmw_vsock/af_vsock.c | 2 +-
>> > 1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> >index 9e93bc201cc0..b8feb9223454 100644
>> >--- a/net/vmw_vsock/af_vsock.c
>> >+++ b/net/vmw_vsock/af_vsock.c
>> >@@ -2072,7 +2072,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
>> > 		break;
>> >
>> > 	default:
>> >-		pr_err("Unknown ioctl %d\n", cmd);
>> >+		pr_err_ratelimited("Unknown ioctl %d\n", cmd);
>>
>> Make sense, or maybe can we remove the error message returning only the
>> -EINVAL?
>
>Isn't the canonical error for unknown ioctl codes -ENOTTY?
>

Oh, thanks for pointing that out!

I had not paid attention to the error returned, but looking at it I 
noticed that perhaps the most appropriate would be -ENOIOCTLCMD.
In the ioctl syscall we return -ENOTTY, if the callback returns 
-ENOIOCTLCMD.

What do you think?

Stefano

