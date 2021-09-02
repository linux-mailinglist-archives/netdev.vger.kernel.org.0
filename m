Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7523FE81B
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 05:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242859AbhIBDjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 23:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242772AbhIBDjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 23:39:20 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B397C061757
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 20:38:22 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id x16so343875pll.2
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 20:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=x3LXMWwOvI3gwvEKRw7rqrw5ERbk2YFQCJ24CK6a6hM=;
        b=YYl1EdrM7/6oNjoxJ92pSV6qOZ9ZCTnurmDa6ZcX1NxxmZKzqDNYEG2gojydJqi8dO
         Qqn5fuzwZWDc2Y+9VoEupVcBv2m4dw6Ql//GDwtLkYgNVUrLKwpXaCnQH94JqWjY7mGn
         b7mag7TcuoKLnLOCqKSQKN6SRqTsLuzxtvbOuY0KDOa1cESjQHZ/Rn9uY5tfAX648hN1
         vgHn8Uoyl5GIn/6N1dFhTp2PEMpuHb2QXKT+Quyo3pPXGXURT8ghzXZfnYUI5r9A2qJb
         7fRZVrQriSqxqSPa/iII21Hggo3V9h5eAFVxLZeiy/ItpkFKwSqOFCZj/Sh5O88CUXLW
         HMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x3LXMWwOvI3gwvEKRw7rqrw5ERbk2YFQCJ24CK6a6hM=;
        b=kw+D4LYDLsFFSL0voWVK447J/8f4pUzY9K1YMirGsQDYkdhT+5voBKTB3ORRrZ8QuO
         s1I8hlfp2Cwi7QxqbvU/znHHOcymXkJy+26VT7c8Qp/hKjDqdVWZSprd5D01zWiRVRdE
         LlU4nwfDv2q4HGRIX6Q9ZpgtyCuga/Vx3xnYh4sFYDj8JiS+VyqcmoRMYbA7xTZc8IzB
         zuAP2+S0jHL7sv1FJUyeJsn56MCxQXuuDbospXMyqxvIB2v5LebNwEfcoJGIB2m8/WTy
         ZRkeOYDhguD81EVrAEdnF9XGLxLRLxvgj1T3xNtxlld/caTeamhiauW9XypfypJQyjsp
         EgLg==
X-Gm-Message-State: AOAM532mFmf1o0d3Yp3H3wU505aZMnVhMU102/Mn+kJmhc82t/qHb5qT
        JtNwxh407pn5D8fme2B+gZCyHCvew0A=
X-Google-Smtp-Source: ABdhPJwiIuSZKvsuTid2w2TlZycevTc/3MAC9A2LzE52MhMW3GA3VXXCnEQSD0XKEgGBiN1DRw13gA==
X-Received: by 2002:a17:902:b190:b029:12d:487:dddc with SMTP id s16-20020a170902b190b029012d0487dddcmr985563plr.24.1630553901738;
        Wed, 01 Sep 2021 20:38:21 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id u21sm431315pgk.57.2021.09.01.20.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 20:38:21 -0700 (PDT)
Subject: Re: IP routing sending local packet to gateway.
To:     David Laight <David.Laight@ACULAB.COM>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
References: <15a53d9cc54d42dca565247363b5c205@AcuMS.aculab.com>
 <adaaf38562be4c0ba3e8fe13b90f2178@AcuMS.aculab.com>
 <532f9e8f-5e48-9e2e-c346-e2522f788a40@gmail.com>
 <b1ca6c99cd684a4a83059a0156761d75@AcuMS.aculab.com>
 <b332ecafbd3b4be5949edae050f98882@AcuMS.aculab.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <36d69eb1-fdb0-772e-4d3c-33ebead92b0a@gmail.com>
Date:   Wed, 1 Sep 2021 20:38:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b332ecafbd3b4be5949edae050f98882@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/21 9:24 AM, David Laight wrote:
> I've found a script that gets run after the IP address and default route
> have been added that does:
> 
> 	SOURCE=192.168.1.88
> 	GATEWAY=192.168.1.1
> 
> 	ip rule add from "$SOURCE" lookup px0
> 	ip rule add to "$SOURCE" lookup px0
> 
> 	ip route add default via ${GATEWAY} dev px0 src ${SOURCE} table px0
> 
> The 'ip rule' are probably not related (or needed).
> I suspect they cause traffic to the local IP be transmitted on px0.
> (They may be from a strange setup we had where that might have been needed,
> but why something from 10 years ago appeared is beyond me - and our source control.)
> 
> Am I right in thinking that the 'table px0' bit is what causes 'Id 200'
> be created and that it would really need the normal 'use arp' route
> added as well?
> 

this is why the fib tracepoint exists. It shows what is happening at the
time of the fib lookup - inputs and lookup results (gw, device) - which
give the clue as to why the packet went the direction it did.

