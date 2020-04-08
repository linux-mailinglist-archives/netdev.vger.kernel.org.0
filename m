Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7FE1A2BDD
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDHWZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:25:34 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42505 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgDHWZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 18:25:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id h15so9339026wrx.9
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 15:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oXuZiun+Lyk8DgbCRtgxQakH73AnYKjxv8SI/qsirr4=;
        b=R8vej2X7DeiM5BMBuo92XXuwGu6kaQsSDNo3FxmYg0KIahkxr8/jFuk+KBC/tvRp2P
         8jAdZEwO4A0XRQh2SWk9qU9x/wo8SNQa3r3f48vofxVOhQWlcJAp35GUKIBOy04NLuKo
         qZoFJGl5N4WDj4of3ZHc49HLAinz0z2LhWkS3HrOz60UR9MXlxMYxUvsbvEZeyBcqvNI
         UVAY93zRHP7kTqX65b0oqv+HXGDGfqDOva/6ddLXda3oZaK+GO4eVkARlD07aTFgdqvd
         foR8aqB2bgTs8fkvdtbV5d/vLzBKbpZ4mRGoxowM3fyAD/uer+aOqVjUihqYEspa6aCO
         xaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oXuZiun+Lyk8DgbCRtgxQakH73AnYKjxv8SI/qsirr4=;
        b=sxqApSmRQPPN8/Vm/TC2vpUUL3AdoTxVy+pSOTNsJOA5QYfcBRivqvaLG6M8TH3AMH
         WxsiUyfYM6EyTfY8ttPMmWN7Mt6kK9wFqr0nYU+xwlbXACFzCmCTZc5Qx3fsvGkp2PNN
         ygBUDaouKBI7CTpALuWjTn9FBjhUP4NS9bmPmO40lgDNdPgQCjA9q0d2nnWhZvmT1mub
         ork+lYTY7deoAbhZvHQHLUjZD2ec1uqMqvNFSU4M3uJBgDOezMIAj0Z/gjIsa+NqO+oS
         TGm07JEm/BukFMheQql9cip8d6RQzBCxN64iuam++/JtLXS6xa+dk8Dh7KFl8DLGhcsc
         Hc2Q==
X-Gm-Message-State: AGi0PuY29l0HRqptZTYfkAmstHOiW1aYug4rvt/qiTQZqnahQpBz//g+
        62/S0HLAE7AUGXyZNXNaZGukKYhrJiE=
X-Google-Smtp-Source: APiQypI4a5kFabwUxK8TS7wXBJ7R6jWkvtmkDCHkzb5iGWobDgVJVQ6RS3iw1hmIn9HZZT1/p0lFpQ==
X-Received: by 2002:adf:f881:: with SMTP id u1mr6319099wrp.186.1586384731874;
        Wed, 08 Apr 2020 15:25:31 -0700 (PDT)
Received: from white ([188.27.148.74])
        by smtp.gmail.com with ESMTPSA id c190sm1180744wme.10.2020.04.08.15.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 15:25:31 -0700 (PDT)
Date:   Thu, 9 Apr 2020 01:25:27 +0300
From:   =?utf-8?B?TGXFn2UgRG9ydSBDxINsaW4=?= <lesedorucalin01@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: UDP repair mode for retrieving the send queue of
 corked UDP socket
Message-ID: <20200408222527.GA23620@white>
References: <20200408205954.GA15086@white>
 <20200408.142749.1712309028781080294.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408.142749.1712309028781080294.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 02:27:49PM -0700, David Miller wrote:
> From: Lese Doru Calin <lesedorucalin01@gmail.com>
> Date: Wed, 8 Apr 2020 23:59:54 +0300
> 
> > Hello everyone!
> > 
> > In this year's edition of GSoC, there is a project idea for CRIU to add support
> > for checkpoint/restore of cork-ed UDP sockets. But to add it, the kernel API needs
> > to be extended.
> > This is what this patch does. It adds UDP "repair mode" for UDP sockets in a similar
> > approach to the TCP "repair mode", but only the send queue is necessary to be retrieved.
> > So the patch extends the recv and setsockopt syscalls. Using UDP_REPAIR option in
> > setsockopt, caller can set the socket in repair mode. If it is setted, the
> > recv/recvfrom/recvmsg will receive the write queue and the destination of the data.
> > As in the TCP mode, to change the repair mode requires the CAP_NET_ADMIN capability
> > and to receive data the caller is obliged to use the MSG_PEEK flag.
> > 
> > Best regards,
> > Lese Doru
> > 
> > Signed-off-by: Lese Doru Calin <lesedorucalin01@gmail.com>
> 
> Why do I feel like I've seen this patch several times before?

Maybe others contestants in GSoC already sended a patch for this.
This is the my first time when try.
