Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78613304A59
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731456AbhAZFFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:05:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728371AbhAYNAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:00:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611579549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vyJ1k8AoxLtkQF8krVeUnvj4TqKQ2T24Y/tcDxbs1Go=;
        b=Wzml19Dkhc5xoh8kP3SpBd3zSasynXb3DRAmQEDFOujg+7u6gkqn4E1s8oXGuaVN/LvidE
        /jJ+mV63ZfD7b2A2n61K57Qf9ymx+MO3b/seLufk3HtFzRQg53VjRltM4BdK8PVgdRAe8U
        JEyhrsljo2DftrQVVbmzkf0qNb/I+QY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-cu0vt5LhNGmh-0aSUYvmQg-1; Mon, 25 Jan 2021 07:59:07 -0500
X-MC-Unique: cu0vt5LhNGmh-0aSUYvmQg-1
Received: by mail-ej1-f72.google.com with SMTP id n25so3442076ejd.5
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 04:59:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vyJ1k8AoxLtkQF8krVeUnvj4TqKQ2T24Y/tcDxbs1Go=;
        b=AlnjH1IP+d1R1ratTe18zttnAWU+oeUqBFUj44AicArpa7IyFiHHStrYv3f69p6i1d
         9xLPA1DmTVKtM+GCpVurGqVgGveubkYnVf7Y18hkSqSJn7RmAyppE7fvmWSY+JYfjBV0
         ujyeuEMn0tvgLteMVehYSq1TNZ/4uoEx+Pll8/xd2qnx/qEuBeIkOXxQ7XG+BMXkf5Lv
         jEvjaBw9HHptQbIyDh7LJBro5paTrV0LgJZ9RWEYZ+S5UB4C0B4ujaegZeCVSNPCyx+u
         N1MBesavchaWvpMUiTlVBEu8YSMsoRNkYdNRgm6kKZv6GZjzSPK9jUcZ9c3ErtjO1oj4
         WNBw==
X-Gm-Message-State: AOAM532E+ySpEyStbnhTf8FHWYzYDeXTBcQ+MxjUhu44JqudcChF/k+e
        daG962TaXvoh4wREnZffTywIvR/UsyQVYh7whSmvuM1jOgyXTGZb9lnLOKLla3wec7uTbinc3VY
        d2nSSAMjxPZfLrpK4
X-Received: by 2002:a17:906:3781:: with SMTP id n1mr288793ejc.296.1611579545762;
        Mon, 25 Jan 2021 04:59:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytbR6L3qYG5Lt1GNxqYBmOuRhfy1Dq13nsxJZfyvECoSC85SlUAbEXG5jCNIuDCw7GJy6v5g==
X-Received: by 2002:a17:906:3781:: with SMTP id n1mr288787ejc.296.1611579545625;
        Mon, 25 Jan 2021 04:59:05 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-37a3-353b-be90-1238.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:37a3:353b:be90:1238])
        by smtp.gmail.com with ESMTPSA id dm1sm10226654edb.72.2021.01.25.04.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 04:59:04 -0800 (PST)
Subject: Re: pull-request: mac80211 2021-01-18.2
To:     Johannes Berg <johannes@sipsolutions.net>,
        "Peer, Ilan" <ilan.peer@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
References: <20210118204750.7243-1-johannes@sipsolutions.net>
 <77c606d4-a78a-1fa3-5937-b270c3d0bbd3@redhat.com>
 <b83f6cf001c4e3df97eeaed710b34fda0a08265f.camel@sipsolutions.net>
 <BN7PR11MB2610052E380E676ED5CCCC67E9BE9@BN7PR11MB2610.namprd11.prod.outlook.com>
 <348210d8-6940-ca8d-e3b1-f049330a2087@redhat.com>
 <666b3449fe33d34123255cc69da3aa46fc276dcb.camel@sipsolutions.net>
 <6c949dbe-5593-2274-7099-c2768b770aad@redhat.com>
 <671b0c37867803d7229ef0c4a33baf2c7778df08.camel@sipsolutions.net>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <92c434bd-bf79-2b49-2a0a-8e538d55551c@redhat.com>
Date:   Mon, 25 Jan 2021 13:59:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <671b0c37867803d7229ef0c4a33baf2c7778df08.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/25/21 1:40 PM, Johannes Berg wrote:
> Hi,
> 
>>> I don't have that much sympathy for a staging driver that's clearly
>>> doing things differently than it was intended (the documentation states
>>> that the function should be called only before wiphy_register(), not
>>> during ndo_open). :-)
>>
>> I completely understand and I already was worried that this might be
>> a staging-driver issue, which is why I mentioned this was with a
>> staging driver in the more detailed bug-report email.
> 
> I guess I missed that, but no worries.
> 
>>> But OTOH, that fix to the driver is simple and looks correct to me since
>>> it only ever has a static regdomain, and the notifier does the work of
>>> applying it to the channels as well.
>>
>> So I've given your fix a quick try and it leads to a NULL pointer deref.
> 
> Ouch. Oh. I see, that driver is *really* stupid, trying to get to the
> wiphy from the adapter, but going through the wdev instead ... ouch.
> 
> Wow are these pointers a mess in that driver ... Something like this,
> perhaps?
> 
> https://p.sipsolutions.net/4400d9a3b7b800bb.txt

Yes this fixes things, thank you that saves me from having to debug
the NULL ptr deref.

Do you want to submit this to Greg, or shall I (I've already
added it to me local tree as a commit with you as the author) ?

If you want me to submit it upstream, may I have / add your S-o-b
for this ?

Regards,

Hans

