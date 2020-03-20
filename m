Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC0F18D8DC
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgCTUMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:12:12 -0400
Received: from mail-qt1-f176.google.com ([209.85.160.176]:36429 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTUMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 16:12:12 -0400
Received: by mail-qt1-f176.google.com with SMTP id m33so6137568qtb.3
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 13:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B02iV0Df83eXziFl+Rl+K/BGmgSNdHYKRfrKYXgyA/8=;
        b=HgMbuHaL4QVOt7Lr2mGoKfn2E6BSVcBtKY11Ez4QFw0NwGx8rTuwp1OG/pCjA5wEP1
         Hj3ettlREpSrpVdyFEACrasJDvoiJWZSFYb5zORboAsn78g/5BhFDuOjd0uZQOFqFjgr
         fX2epu0/Dop2y8A9CLWvX8Z8Chbs85OYO4ewGzfHwdf0wAD93EWI5ca5XJ5T4yWWSeQo
         KIBjuJ+7EwhuIBKounrG1usb7oxXSSdGN5KYidoQ0xQ7+nAS7pQfunvU9PaKR95TnKxZ
         dTEY15BMiucfHfi8XpEOhK1kC2J0jX5cmUKMw6qyvqVF9h/+wUnokcJ3I/N51qr3cU5r
         2WuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B02iV0Df83eXziFl+Rl+K/BGmgSNdHYKRfrKYXgyA/8=;
        b=eqvVzKpPswvnJhA7ALSy8yQHdmhlmkugyxBfyKkzmhKvD3IxJxXzKCf06JrrbUrDfw
         9ZBeZcQu7aYyKH0nvn2OxJhVuZ1B2ToeIeJw4xkaJsA+aLnHKCCUHV2noTMPm5WbzV4Q
         z/h5+TTILLQJp9CGRLUKgXwcGASFiNjYlqTqhVI8MVlUI9e98XBfi6Yu8jQSOlu4B8pt
         q0tedUsA1CWPNS3Txq0njLVV+vpdLbiUuhHiU5Rs3LJipp3V41VBbaLGNPQmulM4OU+c
         xavDOxJwEGvawxN74n7IWmLn3YTwcZ7u6c8xOQkdY5xAi/YW5GLF5VR8FWoWzoqcl83Y
         pDjA==
X-Gm-Message-State: ANhLgQ3DQ7Mac+u44A7HpVdXFrv07ilewEPjT6ikfkY7ax70Ot6yOKGN
        +p6brqgCyJUNWO6U2cXDoJNXxwX8
X-Google-Smtp-Source: ADFU+vtxVUYmYG3xx8KcBXu4QCB2qSUF0kwCau0Vc9Q/z3R7B2ms271mt9SpNWcO6nVs+2cWECRN9Q==
X-Received: by 2002:ac8:4084:: with SMTP id p4mr10140310qtl.30.1584735129604;
        Fri, 20 Mar 2020 13:12:09 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:38:ff03:7d92:2ec4? ([2601:282:803:7700:38:ff03:7d92:2ec4])
        by smtp.googlemail.com with ESMTPSA id h138sm5061838qke.86.2020.03.20.13.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 13:12:09 -0700 (PDT)
Subject: Re: [patch iproute2/net-next v5] tc: m_action: introduce support for
 hw stats type
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        stephen@networkplumber.org, mlxsw@mellanox.com
References: <20200314092548.27793-1-jiri@resnulli.us>
 <ef67d2db-47a0-a725-5a9a-33986bcc07b4@gmail.com>
 <20200320130829.54233457@kicinski-fedora-PC1C0HJN>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4e960372-2a5e-5a38-b2ae-843957f0cd67@gmail.com>
Date:   Fri, 20 Mar 2020 14:12:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200320130829.54233457@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 2:08 PM, Jakub Kicinski wrote:
> On Fri, 20 Mar 2020 10:34:04 -0600 David Ahern wrote:
>> On 3/14/20 3:25 AM, Jiri Pirko wrote:
>>> @@ -200,6 +208,29 @@ which indicates that action is expected to have minimal software data-path
>>>  traffic and doesn't need to allocate stat counters with percpu allocator.
>>>  This option is intended to be used by hardware-offloaded actions.
>>>  
>>> +.TP
>>> +.BI hw_stats " HW_STATS"
>>> +Speficies the type of HW stats of new action. If omitted, any stats counter type  
>>
>> Fixed the spelling and applied to iproute2-next.
> 
> Just a heads up that the kernel uAPI is getting slightly renamed, you'll
> need to do a s/HW_STATS_TYPE/HW_STATS/ the rename lands. Do you want me
> to send a patch for that?
> 

sure
