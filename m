Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D3611018C
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 16:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfLCPu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 10:50:56 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40839 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfLCPuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 10:50:55 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so4266500wrn.7
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 07:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xKpLkJ4TcM/K4DTyzjgCR04MySzz0rqcTbbc1IOsCEM=;
        b=cK54oECVFbL0pc1TN/Kj7PjGB4LWxCKnhI44h5p4/tSV/Vmdf6yyRftD0uK8jWUQp2
         oU35UOkJI1nMb4NMWTyvkEWcU0cMs5jhkzPBQIccbgHR9gXb0TXoLbdCNIgUkyu2SVae
         X+xb2HzOFoufZFOwD4gG2LyyO4UgMyQ4yGGr4lbaGNzLEVOEUfgz5y0wtmOc1x04XIUp
         QbRy3bFDBw9HBx1hG1EZl46mwYG/ChO1RFglCKe0rOkuwvx8BtVMwueqiu+AOnbp6l5C
         Cw3mmrPhtoIuTDubQx4RkvQLltAc879cGqo1UjumIlf+G0wjacS8COYsQmBBxYJxtXCT
         Debw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xKpLkJ4TcM/K4DTyzjgCR04MySzz0rqcTbbc1IOsCEM=;
        b=is/0OhlogFSLRrWnPirf0iNmXnSkfwCy9VhOhj0a2yMPoTphL/Egn6+F++5Arjx1Vy
         DUM0sQc9WpUB+VSRe3VSzX0Oy2lyb7uoS1tRQlEfDWgdPBpVSOqmDMu2zYqFg8mqXjsL
         E4lFqvsixiTJSq9ZIDls01EU1m3ZCogtsdo/dbwVQUnwj0otSCHM2dRDdA7mdXZ32PJG
         WjJIqM6VpfoaMdIZ7/E6VWNOIhMEuVEw1RMphvG00XTZze/nDDrXxVZPjoh2VZCiCCTv
         2IWl33RcX6c6sDbCSSanYMt65Af82UxT8GW7TR+uEUBITGTwWjt56WxQH9TvCuGq1ILc
         OFMw==
X-Gm-Message-State: APjAAAV9UIgu/djdsYp8R9H7oZw6fdKr+lIya4lxOa3HafM2ymuEjnaq
        pLNYRvU6a4aB9w4veudQgAqP2g==
X-Google-Smtp-Source: APXvYqxntFyiJbOfCDR0kELEkL8MRRYIlKUNkm9YXk+E7STtb5Pyns/VrzmqE3P+gYOCh/2WG9W0Eg==
X-Received: by 2002:adf:ba4b:: with SMTP id t11mr5668806wrg.331.1575388253455;
        Tue, 03 Dec 2019 07:50:53 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:7594:27:53f2:5cc7? ([2a01:e0a:410:bb00:7594:27:53f2:5cc7])
        by smtp.gmail.com with ESMTPSA id x10sm4103190wrv.60.2019.12.03.07.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 07:50:52 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: xfrmi: request for stable trees
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <20190905102201.1636-1-steffen.klassert@secunet.com>
 <3a94c153-c8f1-45d1-9f0d-68ca5b83b44c@6wind.com>
 <65447cc6-0dd4-1dbd-3616-ca6e88ca5fc0@6wind.com>
 <20191203130345.GC8621@gauss3.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <95ca675f-3581-2784-c77d-95f2995ea3d7@6wind.com>
Date:   Tue, 3 Dec 2019 16:50:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191203130345.GC8621@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/12/2019 à 14:03, Steffen Klassert a écrit :
> On Mon, Nov 18, 2019 at 04:31:14PM +0100, Nicolas Dichtel wrote:
>> Le 14/10/2019 à 11:31, Nicolas Dichtel a écrit :
>>> Le 05/09/2019 à 12:21, Steffen Klassert a écrit :
>>>> 1) Several xfrm interface fixes from Nicolas Dichtel:
>>>>    - Avoid an interface ID corruption on changelink.
>>>>    - Fix wrong intterface names in the logs.
>>>>    - Fix a list corruption when changing network namespaces.
>>>>    - Fix unregistation of the underying phydev.
>>> Is it possible to queue those patches for the stable trees?
>>
>> Is there a chance to get them in the 4.19 stable tree?
>>
>> Here are the sha1:
>> e9e7e85d75f3 ("xfrm interface: avoid corruption on changelink")
>> e0aaa332e6a9 ("xfrm interface: ifname may be wrong in logs")
>> c5d1030f2300 ("xfrm interface: fix list corruption for x-netns")
>> 22d6552f827e ("xfrm interface: fix management of phydev")
> 
> Nicolas,
> 
> I'm currently processing the stable queue for v4.19.
> I guess we also need this patch from you:
> 
> 56c5ee1a5823 ("xfrm interface: fix memory leak on creation")
> 
> before we apply the above mentioned patches, right?
> 
Right, I point it in my first email but I get an email from Sasha Levin the 25th
October:
[PATCH AUTOSEL 4.19 16/37] xfrm interface: fix memory leak on creation

so I was thinking that it is already queued. But I can't see it in linux-stable.
