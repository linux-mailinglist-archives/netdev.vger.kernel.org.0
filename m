Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217F310259E
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfKSNlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:41:04 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39691 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSNlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:41:04 -0500
Received: by mail-pf1-f193.google.com with SMTP id x28so12202334pfo.6
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 05:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4OoxzfinYAPlGdTVivW4kv+plojwt++H5CBPTA6EerQ=;
        b=BHEP+XeqNUcztgaikMDVp7r+L7HYPdLNOgXSOMzLbxv56UJC0BH0Y4i45+qBY0X9W4
         m+YWbVczWYlsfNoQKVeLl1ssSauxifKehxk+/KzMT+37J6sOEc/oc87Jv69Jdi4jOSXu
         TbisArqFgWpaYmZdjbhHGvoVfV6HONHdWdXZNfnqy7B+Ybon1I9Y9IB1+1lMtQOxMfm1
         0jPf1GBePnudkwL2hYjIT8EHPX9XVSHGehXOqIaLanzVj3uxPwuVllzhXL15poTlT6MK
         lOG63paXAb0Y9WD82qQ7fay/aKouBxShxcX91ua8E14C+R1cWE8xwm74AfIjht2k6YB+
         IPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4OoxzfinYAPlGdTVivW4kv+plojwt++H5CBPTA6EerQ=;
        b=Q3FCpII/gQ5WsFB8atZmfyyBopJmbzZKXJa2u5Cv13aVUP015SlmwcUuNCrgb2Yw/3
         2IfwzOJ0z1qIYOsGQwkzVAnIq70WZXJH45cm+815SqTRTXtysW+uTWHTxGaiiTTm9jxR
         H/g4a1xJTgq766QvVH/wrf4gw4rAl66xSEhej0i1nEfRwXUUER1CiW2xm6Tt7HFuPD21
         VNuy5TyNgrFW9ipDlS5P0/lWWTh0w3/3jmzIxVVYtl12oOKhsqyLea3rUQNWsLIj3xJF
         CdRcx8iynE2Yb1r6cV5lu6W5tcFGx2XU92h8kcq06BDULwvt3hB5IsmVB2Jn7vLq9uJy
         eDhQ==
X-Gm-Message-State: APjAAAVgmIeyfxt/c6poVJ7LwkrQdDqT5PAytMsy+o8KhkcnP/R1u3/T
        X1iv9hl934T/+YfHZHBVuvb3aIiVWfAxng==
X-Google-Smtp-Source: APXvYqxfsiIf5Z2aTI1KPrF8C+ixgsLbLi2LnHUGyYi8JTpRaxJb8RJPigQvwbUr8K1AMrTYFUulFg==
X-Received: by 2002:a63:381b:: with SMTP id f27mr5485597pga.291.1574170862031;
        Tue, 19 Nov 2019 05:41:02 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a16sm24592697pgb.7.2019.11.19.05.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 05:41:01 -0800 (PST)
Date:   Tue, 19 Nov 2019 21:40:51 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] tcp: switch snprintf to scnprintf
Message-ID: <20191119134051.GE18865@dhcp-12-139.nay.redhat.com>
References: <20191114102831.23753-1-liuhangbin@gmail.com>
 <557b2545-3b3c-63a9-580c-270a0a103b2e@gmail.com>
 <20191115024106.GB18865@dhcp-12-139.nay.redhat.com>
 <20191115105455.24a4dd48@redhat.com>
 <20191119015338.GD18865@dhcp-12-139.nay.redhat.com>
 <22361732-351e-4768-0974-bd4050eb9f2e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22361732-351e-4768-0974-bd4050eb9f2e@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 07:48:32PM -0800, Eric Dumazet wrote:
> 
> 
> On 11/18/19 5:53 PM, Hangbin Liu wrote:
> > On Fri, Nov 15, 2019 at 10:54:55AM +0100, Jiri Benc wrote:
> >> On Fri, 15 Nov 2019 10:41:06 +0800, Hangbin Liu wrote:
> >>>> We need to properly size the output buffers before using them,
> >>>> we can not afford truncating silently the output.
> >>>
> >>> Yes, I agree. Just as I said, the buffer is still enough, while scnprintf
> >>> is just a safer usage compired with snprintf.
> >>
> >> So maybe keep snprintf but add WARN_ON and bail out of the loop if the
> >> buffer size was reached?
> >>
> >> 	if (WARN_ON(offs >= maxlen))
> >> 		break;
> >>
> > 
> > Hi Eric,
> > 
> > What do you think?
> > 
> 
> WARN_ON_ONCE() please...
> 
OK, I will post a v2 update. Should it target to net or net-next?

Thanks
Hangbin
