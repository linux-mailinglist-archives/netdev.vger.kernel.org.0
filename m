Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E696357FD2
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfF0KBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:01:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34007 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbfF0KBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:01:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so1843293wrl.1
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 03:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QmmG+R0OWAswX3V6/bDa2vpV+fym/Q1cIWWoeyKq9uY=;
        b=uOPJ5scuXRYKqRbZ+1B427Tazo4wRYuBtITQPRUgK1W6QgyPzGYO9rIjAvM+juXRuh
         BxGWsW56lPaXASZm2hL2vC17A4PPWbVztNU5tqqowPERgGx1Xc7lfo2i1v3871kfducg
         bhUjyjJGVtLZ1K3P1NVXE0lA/5O17p7ekKrRsAoYKE/XnvYQie3BpXaN043TxVPDJJ3q
         /+iBT/+Ure45PzbJin55EVDr7hYQvpWDP1EEDZIhjQtOuqA4u7AqgOrJnFKdAj592RjB
         aK+2PKG9K7mt4HrW/hfK+XFm9Y6Km09EG7yvjx7t5oQ5WucsfU4wDRekuxOqcJdF2w5B
         kJXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QmmG+R0OWAswX3V6/bDa2vpV+fym/Q1cIWWoeyKq9uY=;
        b=p5bRePxwSKIZjrkNk4iRrgq7tMgI3A4u/conP0mk0TOEjsSE/aRz4RnkXRB6S8QLNx
         OWpXfnHDZ5J9i2xJRHayOXvb/LWN6vwrzMg1YB9KgfuL7sLWvCyiZ7XAOBsnqGIW5hvI
         yfsSysbBXBBcnXYBEjN3HDAOobT3hG4XcjzFC27L1S0R6bQZIimR0J5L95tTdRLU1+mr
         8UTEbQYJP60yX8szIrkVMSOR95wLs0WXiHOfqLa/hMk7Q+RinoroFoHqH4ZvpGIXyTiW
         czPHJ5TiF7ZPke/8+ay1CKbdqhmWCyC1O0hUUpTCen7sytwvMV36T6U7nMqDO30++AxB
         1oWA==
X-Gm-Message-State: APjAAAVNdiiTvq//0mIvZvXcvb/t5RnQqQGCNGGSEvPrw64wdLbwB176
        bWsKegWPO5vziPPGvvtqjKtLoxbPxsJ+Gw==
X-Google-Smtp-Source: APXvYqx7EuyiUbGEDEHVuwadpjIp2oJQ+qlVy6dyKEtcPrw74nZG7K7BVapPKWOXOsuK9zAFLN7ONA==
X-Received: by 2002:a5d:4e50:: with SMTP id r16mr2581047wrt.227.1561629694405;
        Thu, 27 Jun 2019 03:01:34 -0700 (PDT)
Received: from jimi (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id e4sm2872636wme.16.2019.06.27.03.01.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:01:34 -0700 (PDT)
Date:   Thu, 27 Jun 2019 13:01:29 +0300
From:   Eyal Birger <eyal.birger@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, pablo@netfilter.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, jhs@mojatatu.com
Subject: Re: [PATCH net-next v3 0/4] em_ipt: add support for addrtype
Message-ID: <20190627130129.652f3879@jimi>
In-Reply-To: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
References: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 11:10:43 +0300
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> Hi,
> We would like to be able to use the addrtype from tc for ACL rules and
> em_ipt seems the best place to add support for the already existing xt
> match. The biggest issue is that addrtype revision 1 (with ipv6
> support) is NFPROTO_UNSPEC and currently em_ipt can't differentiate
> between v4/v6 if such xt match is used because it passes the match's
> family instead of the packet one. The first 3 patches make em_ipt
> match only on IP traffic (currently both policy and addrtype
> recognize such traffic only) and make it pass the actual packet's
> protocol instead of the xt match family when it's unspecified. They
> also add support for NFPROTO_UNSPEC xt matches. The last patch allows
> to add addrtype rules via em_ipt. We need to keep the user-specified
> nfproto for dumping in order to be compatible with libxtables, we
> cannot dump NFPROTO_UNSPEC as the nfproto or we'll get an error from
> libxtables, thus the nfproto is limited to ipv4/ipv6 in patch 03 and
> is recorded.
> 
> v3: don't use the user nfproto for matching, only for dumping, more
>     information is available in the commit message in patch 03
> v2: change patch 02 to set the nfproto only when unspecified and drop
>     patch 04 from v1 (Eyal Birger)
> 
> Thank you,
>   Nikolay Aleksandrov
> 
> 
> Nikolay Aleksandrov (4):
>   net: sched: em_ipt: match only on ip/ipv6 traffic
>   net: sched: em_ipt: set the family based on the packet if it's
>     unspecified
>   net: sched: em_ipt: keep the user-specified nfproto and dump it
>   net: sched: em_ipt: add support for addrtype matching
> 
>  net/sched/em_ipt.c | 48
> ++++++++++++++++++++++++++++++++++++++++++++-- 1 file changed, 46
> insertions(+), 2 deletions(-)
> 

Looks great! thanks for adding this!

For the series:

Acked-by: Eyal Birger <eyal.birger@gmail.com>
