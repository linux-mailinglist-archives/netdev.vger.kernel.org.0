Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282322718A3
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 01:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgITXo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 19:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITXo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 19:44:28 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D414C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 16:44:28 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d13so7324388pgl.6
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 16:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Df9RYfrE87k9v8VtrQTzx+ZdRyc+yjqscgIAo+P8ZWU=;
        b=XNsbPcM66KcMXSIQP4X2qr3hNYpp1iXGBvawknY1MKHsehwut8sWs3o6U/FWog9L9Z
         qc/h26Za80hErTolcsipizo0dNSDqbk+jt5ajI5A9dcSVX5jTO74hMKJ0TUSjvcYLNp4
         4bXKb/ZqhhwdokoUQQ3nuSc0cap/O944dosIYgH8iGNLXfTzbMwPDQqNRf595QhPyAYR
         o6wvJ1Hp/1fmvX8OUQZV+BflfLDOwKeD/7J9jtZLZoj3NK/Or0ZGblxdJ5sMWLEeIeh6
         pT49/8gSRK0A2geAHLTeCf/XEZp4HryaPRzJIAers2RSulW82GWR+dOokag9kHHQFp5E
         HyWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Df9RYfrE87k9v8VtrQTzx+ZdRyc+yjqscgIAo+P8ZWU=;
        b=hDtlOqdIaaPhwbCcsOOzRZcl3rP0Hs6X6lRAoByQGmtd2UEAyBGiRpJ1A5khuVpg/1
         M2Jp/0jDhFXzCgOFa/ePjrLMNCSwe0i7gMHjUDd7baqzuJkEq8v0VSDdOBCRt7Sj3UOe
         Ig3pN1BMScBt8aJVudnUPdoFTKMvxAFKqUe+tdx4B0Ax9SwURhc0rsMUIaaWLClob+Fh
         kRcSQAu9Rp7+OmdAL+SXSrG9emtQ/iAx1OZliFCVqZB7T1UC6nIHFqK0sgqgDNPRIlGI
         7fHdg5AWBNvvIRcf2aNyYQwgxMfriyAed/tg++as+QBv2yKbeCx2Ggxdwo9UQzkZnupF
         2rGw==
X-Gm-Message-State: AOAM530iH7JSCJYOt98Q7PQ8qw4oSNgOyZK8naevSXvToBbMjVfcA6TW
        BwWrv9DeolYfvux7aTowLTI=
X-Google-Smtp-Source: ABdhPJxDt2NUT/eMQiX2ng2iRlNrHCNnHFMjBagmWI6JSb61scYgTtb2hYPsx2ylG4Fl42P+Dye3ZA==
X-Received: by 2002:a17:902:c40e:b029:d1:bb21:4c97 with SMTP id k14-20020a170902c40eb02900d1bb214c97mr37880659plk.31.1600645467313;
        Sun, 20 Sep 2020 16:44:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id l78sm10107301pfd.26.2020.09.20.16.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 16:44:26 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 0/4] Add per port devlink regions
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Chris Healy <cphealy@gmail.com>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200920233340.ddps7yxoqlbvmv7m@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6ae49d7b-f33c-155b-d69b-c9c75a387edd@gmail.com>
Date:   Sun, 20 Sep 2020 16:44:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920233340.ddps7yxoqlbvmv7m@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/2020 4:33 PM, Vladimir Oltean wrote:
> On Sat, Sep 19, 2020 at 04:43:28PM +0200, Andrew Lunn wrote:
>>
>> DSA only instantiates devlink ports for switch ports which are used.
>> For this hardware, only 4 user ports and the CPU port have devlink
>> ports, which explains the discontinuous port regions.
> 
> This is not so much a choice, as it is a workaround of the fact that
> dsa_port_setup(), which registers devlink ports with devlink, is called
> after ds->ops->setup(), so you can't register your port regions from
> the same place as the global regions now.
> 
> So you're doing it from ds->ops->port_enable(), which is the DSA wrapper
> for .ndo_open(). So, consequently, your port regions will only be
> registered when the port is up, and will be unregistered when it goes
> down. Is that what you want? I understand that users probably think they
> want to debug only the ports that they actively use, but I've heard of
> at least one problem in the past which was caused by invalid settings
> (flooding in that case) on a port that was down. Sure, this is probably
> a rare situation, but as I said, somebody trying to use port regions to
> debug something like that is probably going to have a hard time, because
> it isn't an easy surgery to figure the probe ordering out.

Being able to debug the switch configuration as soon as it gets 
registered with DSA all the way through enabling an user port has 
definitively a lot of value so we should aim to support that use case.
-- 
Florian
