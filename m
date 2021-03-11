Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7C2337875
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhCKPuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbhCKPtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:49:45 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F23C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:49:44 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id n23so1904078otq.1
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=upIYIElt+q7/KFnYoUiZX693jxj/qKog8Zt2lmhytnc=;
        b=m6OyuF6r4oWApkrNyjTeDrVVduBvTx09uvxRmpJuium20MYA1ndP5GqlEnbDDoDvSU
         T3uROmsVRVJxK7JzbOttO50Cr5fXQ/2Cre/IOKWfUk9fXlCXkDgatmoWKYGq84/rj0QN
         GalhuJNaD5u3ROQlCaV+q/QNeWeT+NZOOlfcBjyj+gOKN42O3ai8mgGXpfXyluUziB+x
         Ab9Jprge945yn8W8fhhRpurJBXf9wQNy+1k7rLRMYcnWQnfE6v19TymqgiFguO+0wU6e
         FUxqpNE0Ks+h9BB9u5cxW/bqVSqFTyf7CkqHLlw+Iwfv5cZPJxjYQnjoS6hdt5hRmuzv
         mv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=upIYIElt+q7/KFnYoUiZX693jxj/qKog8Zt2lmhytnc=;
        b=Ovkea9DWnUV1S2sV/p1r+W87Gha7vBQj/4geNXsFzRr2wDvmy8/Q/MD3CS88tP2jaF
         Elr63AsB6HAxLwH7PUxnZUQFrE0foEnIJUzNCj93BNGzasAxLBlLMocTcZXTQ7O1CSLJ
         mxvTBu1ad+69K3QNeN2kIf5nIZ2ycuIoqRJN89TgUV+vbaFMboofLtXAZxpWXwLqz/Zo
         M+7f3LiIJR3eYcAmQABjq5xXFQ6vHVzqmqmyWVrZ9Mdyz67cO3WofoGpRqor13eDeS8r
         JQU7oMe2jeOthI7ObgFgtq0pwd8zD41U1h0YTMRgBblsyL2Shu4yKvfvpWpN7NCLb/Bi
         H4Tw==
X-Gm-Message-State: AOAM531xbQnaV1P0BuK20CT0OD0W8MG4EoYciiVyqG1LvZcJZmsEQWKn
        1xFmJWv1vYHEGzDmaNHKXBU=
X-Google-Smtp-Source: ABdhPJwA+qnG8LNHpkEx9SnXmnCBH5oQARUbr4amtS25FhCNVm3pupU+nrT9QWgGeOgTQX7bJXWa4Q==
X-Received: by 2002:a9d:628d:: with SMTP id x13mr5387415otk.19.1615477784259;
        Thu, 11 Mar 2021 07:49:44 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id b133sm617512oia.17.2021.03.11.07.49.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:49:44 -0800 (PST)
Subject: Re: [PATCH net-next 04/14] nexthop: Add netlink defines and
 enumerators for resilient NH groups
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <674ece8e7d2fcdad3538d34e1db641e0b616cfae.1615387786.git.petrm@nvidia.com>
 <b42999d9-1be3-203b-e143-e4ac5e7d268b@gmail.com> <87ft11itj5.fsf@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33a20197-78b7-847d-7657-7a33ba9fef3b@gmail.com>
Date:   Thu, 11 Mar 2021 08:49:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <87ft11itj5.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/21 8:45 AM, Petr Machata wrote:
> 
> David Ahern <dsahern@gmail.com> writes:
> 
>> On 3/10/21 8:02 AM, Petr Machata wrote:
>>> diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
>>> index 2d4a1e784cf0..8efebf3cb9c7 100644
>>> --- a/include/uapi/linux/nexthop.h
>>> +++ b/include/uapi/linux/nexthop.h
>>> @@ -22,6 +22,7 @@ struct nexthop_grp {
>>>  
>>>  enum {
>>>  	NEXTHOP_GRP_TYPE_MPATH,  /* default type if not specified */
>>
>> Update the above comment that it is for legacy, hash based multipath.
> 
> Maybe this would make sense?
> 
> 	NEXTHOP_GRP_TYPE_MPATH,  /* hash-threshold nexthop group */
> 

yes, the description is fine. keep the comment about 'default type'.
