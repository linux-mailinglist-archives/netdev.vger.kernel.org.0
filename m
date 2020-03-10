Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED90F180B30
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgCJWHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:07:39 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:44692 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgCJWHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:07:38 -0400
Received: by mail-qv1-f67.google.com with SMTP id w5so1314833qvp.11;
        Tue, 10 Mar 2020 15:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DVX/NygDH+L6gcoYYDbAxrFSNvPL5oh81CBY3wqWTvU=;
        b=NYz2UQu7XSvjxa52nRTYafXoRz+xN747R7QOyzmZwXbPnLCzq6MKvdkiu6hqi1fzDi
         tvyYqrYM/4riC0jDsKR1YCRifnxGVwMYD00AgfpLe0iY507NJVM5FsRpB1BkLz/NPP+h
         KeT5fEcdsjb840KJS24l5/FG2zsTZXcB+6FnptljfW/2+tDhUPRbqMUHDPsCWDBEN/b/
         GgwyEWAHjgMdNKPUsj6ZdF94F1AL84aXxYvHmpaSzm3RJn00h/Fw5uL21oH1SOnG9hsP
         3uu1xTzUBDsD5ZHn5ebpqqc6CsHprNRXBYcopPkkn4Q0OdsV60fsvqAsaoVSSdCdws6/
         7ihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DVX/NygDH+L6gcoYYDbAxrFSNvPL5oh81CBY3wqWTvU=;
        b=XHSGfo78RMVuBCe/WwPeXzT6Vv6g6KA0bxbtXsjFW1uLsBOvH3FIP00XaaXpEbFWY0
         CGOlifdVMx4iHFOJp5hBBpZn6m8UFx4Qy5MvrJ6iYr1y4S1NBlBmkNO9NnZWdtrKFykO
         zvhBJtxsM1LIyQqYv4cMtOJz9+rgBehkLjVcGJQPRls7du65QoOS+AS56SmKFmMfTCJ1
         BYt9LkIrGD3VTpYX4K1t1CqciOef25h8uxDQMaO5tTMy4E33aaR2FMbWHlmQbiucpFUy
         JKc29bvNlXJJsMC+2RtdGoz0SIqZmDv14Mw2i5OwPgudrp1efSxp+4aUHy6Q4e47niCl
         Jh4Q==
X-Gm-Message-State: ANhLgQ0EDDGrPZX1BI5lOnNpBgEJk6ClFiMRDMDR0MqfcVDoajwUmma2
        nPH2gJqVgGiVgjFitUblLYLa4uflKfU=
X-Google-Smtp-Source: ADFU+vt7apntLrzSGvfPOuxqlPE1O4KvoiwDtAPiJmId4Yt+EuTbP0KVifGWS+Wp9+OaUrvib1f8YA==
X-Received: by 2002:ad4:4f01:: with SMTP id fb1mr283987qvb.225.1583878057153;
        Tue, 10 Mar 2020 15:07:37 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d1::111b? ([2620:10d:c091:480::fee])
        by smtp.gmail.com with ESMTPSA id x127sm3021341qke.135.2020.03.10.15.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 15:07:36 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Joe Perches <joe@perches.com>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200305111216.GA24982@embeddedor>
 <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
 <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
 <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
 <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
 <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
 <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
Message-ID: <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
Date:   Tue, 10 Mar 2020 18:07:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 5:52 PM, Gustavo A. R. Silva wrote:
> 
> 
> On 3/10/20 8:56 AM, Kalle Valo wrote:
>> + jes
>>
>> "Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:
>>>> I wrote in a confusing way, my question above was about the actual patch
>>>> and not the the title. For example, Jes didn't like this style change:
>>>>
>>>> https://patchwork.kernel.org/patch/11402315/
>>>>
>>>
>>> It doesn't seem that that comment adds a lot to the conversation. The only
>>> thing that it says is literally "fix the compiler". By the way, more than
>>> a hundred patches have already been applied to linux-next[1] and he seems
>>> to be the only person that has commented such a thing.
>>
>> But I also asked who prefers this format in that thread, you should not
>> ignore questions from two maintainers (me and Jes).
>>
> 
> I'm sorry. I thought the changelog text had already the proper information.
> In the changelog text I'm quoting the GCC documentation below:
> 
> "The preferred mechanism to declare variable-length types like struct line
> above is the ISO C99 flexible array member..." [1]
> 
> I'm also including a link to the following KSPP open issue:
> 
> https://github.com/KSPP/linux/issues/21
> 
> The issue above mentions the following:
> 
> "Both cases (0-byte and 1-byte arrays) pose confusion for things like sizeof(),
> CONFIG_FORTIFY_SOURCE."
> 
> sizeof(flexible-array-member) triggers a warning because flexible array members have
> incomplete type[1]. There are some instances of code in which the sizeof operator
> is being incorrectly/erroneously applied to zero-length arrays and the result is zero.
> Such instances may be hiding some bugs. So, the idea is also to get completely rid
> of those sorts of issues.

As I stated in my previous answer, this seems more code churn than an
actual fix. If this is a real problem, shouldn't the work be put into
fixing the compiler to handle foo[0] instead? It seems that is where the
real value would be.

Thanks,
Jes

