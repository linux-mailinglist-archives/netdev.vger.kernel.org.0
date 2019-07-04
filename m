Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEF35FDBC
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfGDUVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:21:38 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34437 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfGDUVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:21:38 -0400
Received: by mail-io1-f67.google.com with SMTP id k8so14953643iot.1
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 13:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OWrqG+ga7Rz5IJsic1OSpdHkZ7hAzYLuz+LfEP5Woak=;
        b=2QoQGYAMkj6h2I/282fmnPFsiWGyDeYM85zm8bEvh5+ivb2LeE+Adz9rMYeTSfofuU
         NYi5fzXQNuzw/QgqYNlLZ10rH8XKFNoOp5MM0sTQHgsqhOBenu/C/xrZk/aHdGRnH6Yk
         T7t63n2+nvs4VeRIXjAS+BesLErOjoYFkLXgvmNd79FHZYpgxUwglljjZV8jHtUtZLQs
         9BIlNQZLjv1I78suYLNtP5D11lApHF5CPHKWnKAONQAGfSHi4ouGsSTIcItqboITxOYZ
         B5b35hOaQAtxxHvwoJrGFoMEAkSSmjRIrNdsgPz7O4ybzgAgTKjUsycHklVPWWmgn7ov
         2Q+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OWrqG+ga7Rz5IJsic1OSpdHkZ7hAzYLuz+LfEP5Woak=;
        b=M9U4DbHvtcZxErk2R1zZnYMOEVlnmxPwKuYDKkP+iUDnldnr8f8g6vha4ppUnyXXHD
         84B6OkfCYl1rYTwPTgANkTIY4fp9L4SN5NlZy8kEVsw/T+t+9jHRpstLeWJo//J9zcLq
         KeDNXrKk6GTZLfYVh7K1aOjh+pc63jYujw1vCtmtLMh0KjC/rssXIG3Zhe+KBbLkUWoi
         l/HK3BI305Hdo5BkWkmk2hjTqeNlpsR8PvLiUp7m9jhp1RpSBka8p8l4HOPmG+gOnN4E
         zF5d06cb9vywI/dBbhqWDf/v0UyBxY6UZ3xmNDdAXb4Mf/jaeVr4Mp2qtCxqsF5ROtT4
         PAkA==
X-Gm-Message-State: APjAAAXR5gIwdsRjmDzd3XlYsSzbVoCDxJgno68ucKWRWf5P+stuRl2I
        ewIM8uhgi4LG3954BSUl2XfRDA==
X-Google-Smtp-Source: APXvYqzzKrgoNeBtJBuMwntK1+8Tv/t1GXsV2Zn0LZj88LmPY0mmghikaUdIbLP4WkzPOCiJWHc2pQ==
X-Received: by 2002:a02:c885:: with SMTP id m5mr24951jao.101.1562271697734;
        Thu, 04 Jul 2019 13:21:37 -0700 (PDT)
Received: from x220t ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id a8sm4956144ioh.29.2019.07.04.13.21.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Jul 2019 13:21:37 -0700 (PDT)
Date:   Thu, 4 Jul 2019 16:21:30 -0400
From:   Alexander Aring <aring@mojatatu.com>
To:     Lucas Bates <lucasb@mojatatu.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, mleitner@redhat.com,
        vladbu@mellanox.com, dcaratti@redhat.com, kernel@mojatatu.com
Subject: Re: [PATCH v2 net-next 1/3] tc-testing: Add JSON verification to tdc
Message-ID: <20190704202130.tv2ivy5tjj7pjasj@x220t>
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
 <1562201102-4332-2-git-send-email-lucasb@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1562201102-4332-2-git-send-email-lucasb@mojatatu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jul 03, 2019 at 08:45:00PM -0400, Lucas Bates wrote:
> This patch allows tdc to process JSON output to perform secondary
> verification of the command under test. If the verifyCmd generates
> JSON, one can provide the 'matchJSON' key to process it
> instead of a regex.
> 
> matchJSON has two elements: 'path' and 'value'. The 'path' key is a
> list of integers and strings that provide the key values for tdc to
> navigate the JSON information. The value is an integer or string
> that tdc will compare against what it finds in the provided path.
> 
> If the numerical position of an element can vary, it's possible to
> substitute an asterisk as a wildcard. tdc will search all possible
> entries in the array.
> 
> Multiple matches are possible, but everything specified must
> match for the test to pass.
> 
> If both matchPattern and matchJSON are present, tdc will only
> operate on matchPattern. If neither are present, verification
> is skipped.
> 
> Example:
> 
>   "cmdUnderTest": "$TC actions add action pass index 8",
>   "verifyCmd": "$TC actions list action gact",
>   "matchJSON": [
>       {
>           "path": [
>               0,
>               "actions",
>               0,
>               "control action",
>               "type"
>           ],
>           "value": "gact"
>       },
>       {
>           "path": [
>               0,
>               "actions",
>               0,
>               "index"
>           ],
>           "value": 8
>       }
>   ]

why you just use eval() as pattern matching operation and let the user
define how to declare a matching mechanism instead you introduce another
static matching scheme based on a json description?

Whereas in eval() you could directly use the python bool expression
parser to make whatever you want.

I don't know, I see at some points you will hit limitations what you can
express with this matchFOO and we need to introduce another matchBAR,
whereas in providing the code it should be no problem expression
anything. If you want smaller shortcuts writing matching patterns you
can implement them and using in your eval() operation.

- Alex
