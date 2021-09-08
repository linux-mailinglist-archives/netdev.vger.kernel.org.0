Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4BD40321C
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 03:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346592AbhIHBTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 21:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346614AbhIHBTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 21:19:34 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F51C061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 18:18:27 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id o16-20020a9d2210000000b0051b1e56c98fso789909ota.8
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 18:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kpnQKmbY+JepyxJ2aGC5AtSqs/jlrRhXaZomZ7suhYo=;
        b=k2PhHD2vGC+rGG0msS9tA2LJoOgfuyQlceFF6cVfxSzcc75C4mPpGAtsXmKpRODCJa
         w2ICy7P9ySoNW9XB1DwynkIFhsWtw2kuPTDE23rwbtplV80f6YuZWln6Gek8naiACyff
         u3/T1sszbZLUjv9PoT6znkf22VirS9x8vAII53vqjwDLWMdmA3WdOVub1TBgREwG/hb2
         EtISy03+UgMY1BCsB3S5Skb8luCC+a2h4lZ6hUPV6/9bDQZZxctKyklV8G/KRuH7jdtQ
         a2AiQtSgBUCKMwKldl/zrDD/+xsZjK4X0GEwvyQlAseBD+PfNCrAg8hj0/SaxS9hHmJ2
         vVLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kpnQKmbY+JepyxJ2aGC5AtSqs/jlrRhXaZomZ7suhYo=;
        b=QCrRnj/CfsnZTUbuh8yG66Dtp/vOybqSOsjscVy6hyDnBWxeWwbiO5tXuGJJsBQnxq
         gu2sdujeyJ72OYoNpDP6igaUYUWpvrssDCw6FkOXB+cBBeFGMsWn81vrgrO+bqcSEUmc
         c/ZcAvUOc/OM5D4TqwQb3cEdvjxnYd4N5446LwkiCAOrdl31YnLSzHVxxWIR2coMaN19
         /CDKugD2y9mwpEWNocccMviKXsdAyytm/gMpV5c7mGcLVKruBdGB4ER9uu2qWcDq4CKT
         Hvz34i3fc5vJqEb+JCRb/jbnf79eX27dXbMNLsVlEa3mUYaOXXE8DShAXesczOxuzEpq
         lNIA==
X-Gm-Message-State: AOAM530/vZsPBGK+0PjRHPoAe9Id3wnEyfjShe+fjxDjUBaKJSG0SwKS
        5radyXbimOpwlQ5yOxEYGNU=
X-Google-Smtp-Source: ABdhPJytU38Ew9QGUlQ41pErS2T4gL8HuwSUOzpUEv1r8VcRgJdxcIuURUl0rxZMS7qFBTIuTfO8Vw==
X-Received: by 2002:a05:6830:4c1:: with SMTP id s1mr1011783otd.221.1631063907128;
        Tue, 07 Sep 2021 18:18:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id l3sm130062otd.79.2021.09.07.18.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 18:18:26 -0700 (PDT)
Subject: Re: [PATCH iproute2 1/2] tc: u32: add support for json output
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Thorsten Glaser <t.glaser@tarent.de>,
        Davide Caratti <dcaratti@redhat.com>
Cc:     Wen Liang <liangwen12year@gmail.com>, netdev@vger.kernel.org,
        aclaudi@redhat.com
References: <cover.1630978600.git.liangwen12year@gmail.com>
 <5c4108ba5d3c30a0366ad79b49e1097bd9cc96e1.1630978600.git.liangwen12year@gmail.com>
 <20210907122914.34b5b1a1@hermes.local>
 <f9752b7-476-5ae6-6ab4-717e1c8553bb@tarent.de>
 <20210907135548.01bab77e@hermes.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a2446fef-129f-51d2-040e-a0a42d24819c@gmail.com>
Date:   Tue, 7 Sep 2021 19:18:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210907135548.01bab77e@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/21 2:55 PM, Stephen Hemminger wrote:
> On Tue, 7 Sep 2021 21:32:41 +0200 (CEST)
> Thorsten Glaser <t.glaser@tarent.de> wrote:
> 
>> On Tue, 7 Sep 2021, Stephen Hemminger wrote:
>>
>>> Space is not valid in JSON tag.  
>>
>> They are valid. Any strings are valid.
> 
> Your right the library is quoting them, but various style guidelines
> do not recommend doing this.
> 

And Davide pointed out a good example of why.
