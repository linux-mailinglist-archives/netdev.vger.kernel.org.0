Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA04101105
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKSBxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:53:50 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:45382 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfKSBxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:53:50 -0500
Received: by mail-pj1-f67.google.com with SMTP id m71so2062952pjb.12
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 17:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ls+aABLS0sCk5dUgoz4Wrzqiif8l3ljdf3X473J33rU=;
        b=K5jmA2k+cyHpoSiBFUjf7eRFPcRDq7CPzL+cckTnVgHOV33vMZrhj/T58pfccedI5E
         vXxFp0j2V1LssCBGLTql/AjiknbiLbQUHYfBX1Egsy1rskIg7LeCf8UYzBZjdUAl+Pln
         eOIicbWAffRWOYUws08kcDghWroNDrRIzRTmEk7dvSH0x+BULUezzU3hhe72EDmuSxpX
         BjuITwsjsBKaaPS8NdCoqXf3Q6bJ4BTYivp9JRoeooBJHZjxI3FrHZc5dY+HWiqPfd3p
         16hT56mWMyzn/uyydlr7UWYKfXyVlJofVRlr+ggAjw0bvZOMmZnSs7m6wXDWvFfT9pcq
         XMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ls+aABLS0sCk5dUgoz4Wrzqiif8l3ljdf3X473J33rU=;
        b=gU0RmD6qd/y/v0z2Me2vf8tBDcYwWtYOnhw/zOOpLC8xYWR69sQCyFQgtW7RQc3nCs
         yl2S4w5ZUDgnpJXlyk/jH4ZFL4sxhsga4qrlLnTEs0X8DRE6KnTzuM2vDZAUpLAM9m7s
         dt4ejoZkuhSt6amnQ7JZqWr7VvgaPvnF/o8tdWDVuvkaB3YCFXEI5WNs/eRMjVscW88H
         idPr0q1r0Y5MYPw9w1527BIoMELJ4aCHFAUcXqMoQ8PoG5ryVEUUh6eSQbHi8RTXtzxy
         2gVg/bW/zSRuIWZ5mUGPbCoeP/ZCF55KlmHaMcMMvjfaoPsk/wtlLgrP1QQZalu33+do
         L06Q==
X-Gm-Message-State: APjAAAX0CSg4PFmDWJxCUFwyhyKWIxrESePmc5nQkmfWFnpBhoFP/dWs
        1WjVhB9oS2/5D4GxYJzBQ20=
X-Google-Smtp-Source: APXvYqzVrz7poCtDfnMF+QvSBERwyHvHWF2owORdo+jcubW3zCxq0q4snBElckJLu9M6O4Aa6HiW9Q==
X-Received: by 2002:a17:90a:b308:: with SMTP id d8mr2779028pjr.23.1574128428441;
        Mon, 18 Nov 2019 17:53:48 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w62sm24450377pfb.15.2019.11.18.17.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 17:53:47 -0800 (PST)
Date:   Tue, 19 Nov 2019 09:53:38 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] tcp: switch snprintf to scnprintf
Message-ID: <20191119015338.GD18865@dhcp-12-139.nay.redhat.com>
References: <20191114102831.23753-1-liuhangbin@gmail.com>
 <557b2545-3b3c-63a9-580c-270a0a103b2e@gmail.com>
 <20191115024106.GB18865@dhcp-12-139.nay.redhat.com>
 <20191115105455.24a4dd48@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115105455.24a4dd48@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 10:54:55AM +0100, Jiri Benc wrote:
> On Fri, 15 Nov 2019 10:41:06 +0800, Hangbin Liu wrote:
> > > We need to properly size the output buffers before using them,
> > > we can not afford truncating silently the output.
> > 
> > Yes, I agree. Just as I said, the buffer is still enough, while scnprintf
> > is just a safer usage compired with snprintf.
> 
> So maybe keep snprintf but add WARN_ON and bail out of the loop if the
> buffer size was reached?
> 
> 	if (WARN_ON(offs >= maxlen))
> 		break;
> 

Hi Eric,

What do you think?

Thanks
Hangbin
