Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F392622A1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 00:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgIHW2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 18:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbgIHW2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 18:28:33 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7477C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 15:28:32 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v196so496869pfc.1
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 15:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jacmn8rXUeBA5x7SFhfrmb1SRk079tVtlzmXm6DT7h0=;
        b=KpX1VTG48vwShJhm/BecqeC5Y0lynZryIrZvchvMoF6CMP0Q2S+0nPLJAtJusrhHgQ
         304r4jo3YKjAmjY2krJNHcBhRiqh7/yMOE91P0C/G0xTOHZciSH86D6++WJcFPZDuF1y
         yQAKvVUoZxYCpJubwtoDSyfB/RR86pJen2IjVr4Dhyc3DF0sT/Rc+cr/idN5FLx5IRPt
         EGejOGufNR0PZNuSGmc/TPdRnKqIe9lvCANSxHZkDNvE5IpKwwNB7fi35VXV45FCB5fG
         G1WWJMKncL5NUi5FifsFuH95K7Xua/7PgMDodqyLexcVW0ePR+4/WAxNLqIxev/ot4z2
         RwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jacmn8rXUeBA5x7SFhfrmb1SRk079tVtlzmXm6DT7h0=;
        b=YGqne07WXRzUkQJc1sN8QNmmOzC0N9/W3mqskKuOkQfT7U9DlVlejtD+aNdeIOvFDf
         bQ46hz1lmD4ytp3YHGioTGRgHy8JQesygc94UhK7FiA5K8uORzWr0n3oVLwCfd4u5vGT
         t5pvxJJ1bv49anUNvJGewfsbLiBk+xyCl/ictpA3YUrOouTdKa4Yq/rbwk4IBVRTqUVD
         6lUaqj7sCCk/lm7xWm804SsPJ1iUohEZd0oFdHAHE89KY/1BBYP71Hf72n2Bu5u3E1C8
         dgUexpAp6cbvGXFiNjMbaWhOE3q3nvD8t8wX0CIuwIQn0sFsIossr1qrwUq3ETgR7Joc
         XtaA==
X-Gm-Message-State: AOAM530DxHHRf/xtrrnmk6ykx/DWXoUZieEHO0z+q51z/77rnw1c6VzH
        8kNxzMlWfs13lxbv0MgEG2ZikR6Mg3c=
X-Google-Smtp-Source: ABdhPJxeU1UcVJfegPZb07JMnBb+uxGJOGgk1ngbjq1SmGcYeLXwsjPwfl12RAu0kKN2IjPrS1OdeA==
X-Received: by 2002:a63:b48:: with SMTP id a8mr679663pgl.16.1599604111142;
        Tue, 08 Sep 2020 15:28:31 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e2sm255744pgl.38.2020.09.08.15.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 15:28:30 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <a5e6cb01-88d0-a479-3262-b53dec0682cd@gmail.com>
Date:   Tue, 8 Sep 2020 15:28:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <961ac1bd-6744-23ef-046f-4b7d8c4413a4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 9:07 PM, Florian Fainelli wrote:
> 
> 
> On 9/7/2020 11:29 AM, Vladimir Oltean wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
>> drivers to always receive bridge VLANs"), DSA has historically been
>> skipping VLAN switchdev operations when the bridge wasn't in
>> vlan_filtering mode, but the reason why it was doing that has never been
>> clear. So the configure_vlan_while_not_filtering option is there merely
>> to preserve functionality for existing drivers. It isn't some behavior
>> that drivers should opt into. Ideally, when all drivers leave this flag
>> set, we can delete the dsa_port_skip_vlan_configuration() function.
>>
>> New drivers always seem to omit setting this flag, for some reason. So
>> let's reverse the logic: the DSA core sets it by default to true before
>> the .setup() callback, and legacy drivers can turn it off. This way, new
>> drivers get the new behavior by default, unless they explicitly set the
>> flag to false, which is more obvious during review.
>>
>> Remove the assignment from drivers which were setting it to true, and
>> add the assignment to false for the drivers that didn't previously have
>> it. This way, it should be easier to see how many we have left.
>>
>> The following drivers: lan9303, mv88e6060 were skipped from setting this
>> flag to false, because they didn't have any VLAN offload ops in the
>> first place.
>>
>> Also, print a message to the console every time a VLAN has been skipped.
>> This is mildly annoying on purpose, so that (a) it is at least clear
>> that VLANs are being skipped - the legacy behavior in itself is
>> confusing - and (b) people have one more incentive to convert to the new
>> behavior.
>>
>> No behavior change except for the added prints is intended at this time.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> You should be able to make b53 and bcm_sf2 also use 
> configure_vlan_while_not_filtering to true (or rather not specify it), 
> give me until tomorrow to run various tests if you don't mind.

For a reason I do not understand, we should be able to set 
configure_vlan_while_not_filtering to true, and get things to work, 
however this does not work for bridged ports unless the bridge also 
happens to have VLAN filtering enabled. There is a valid VLAN entry 
configured for the desired port, but nothing ingress or egresses, I will 
keep debugging but you can send this patch as-is I believe and I will 
amend b53 later once I understand what is going on.
-- 
Florian
