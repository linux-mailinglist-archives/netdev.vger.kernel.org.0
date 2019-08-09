Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB32787F23
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407411AbfHIQOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:14:07 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37662 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfHIQOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:14:07 -0400
Received: by mail-pl1-f195.google.com with SMTP id b3so45195797plr.4
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 09:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yp+OTuVHD91Iz0Va3hpP2su4CFNuKJyUCZSBKEYZYnk=;
        b=qX4WWP9uEGY6dhGTn+u5DpAuEa3J/9nRiT1yHliJ1TU3/baqqD7f1KD0q/pMnCBW9v
         3tcOdPmghOCh2iZaq8BXf1qlG1NOrZZseV/kBqnyC5EiMRkBPTPcHq9f0A/g8n4LWQoN
         x9DET8FJRRBpg0lX5p6VC6e3qPY5KmnZDCwIutOYsrGa7ZS+kn09nlHrhz9boU/7W1pa
         shLr99mUi2q7exQlcXOuNla0kttrbcIwYdsVLmbAWRaT3somu3cZaGLQIYPqHrYDbF8C
         h6Ez4n+llN/Y77N3oKqKNRccuAl6kksW/tRDqfZULyCW4vp3TvWWb8RcdtkG/9vHVXp8
         ckTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yp+OTuVHD91Iz0Va3hpP2su4CFNuKJyUCZSBKEYZYnk=;
        b=KIDwKpsmMOOt68Ncz4mSty/CAi290q8PUfj+3nbuRyzzPeVsdf6/0yx5JRgvUsvsP+
         YW1U/5mXs9IW8w8E6uWJ46KYIv7hesjNPpMK4qqUiT1plvzCvD46mrmaR0D6S//HkJuK
         WDbjjtrv3iIFrdzCIq96UF+fCefLTv98T1zNwi0vgmL6TK6XlCJpC8+ELwM0l6In9fOZ
         pm3N/9YQPCkqcthho2met+oTRvRiUjRbpHB2B0YIlA+Orw26hLXtAcM3ugeSvrxk8yL4
         85Tgea/EcAOEms8asbgaVIIN2GfHMF6eOkgXAkigN3NLX2OlUc7u+mKle914mUG3mXRc
         Ngkg==
X-Gm-Message-State: APjAAAVsQUa+ggmQBlZwuxsSztUFLXvPfIvTFVHTtUlX4ARWsU3rSm+C
        JBu/4AHJnhp+6NAnW6gRMhM=
X-Google-Smtp-Source: APXvYqz94TZ9wzEtp1RdnxxTBLerWSJE/PHUK9fYdtOSXJrocnO0+wUspb9IcLXkjdhoXqdcDdoVlQ==
X-Received: by 2002:a17:902:c505:: with SMTP id o5mr1324170plx.305.1565367246632;
        Fri, 09 Aug 2019 09:14:06 -0700 (PDT)
Received: from [172.27.227.188] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id b3sm115899408pfp.65.2019.08.09.09.14.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 09:14:05 -0700 (PDT)
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
References: <20190719110029.29466-1-jiri@resnulli.us>
 <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
Date:   Fri, 9 Aug 2019 10:14:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/19 9:40 AM, Roopa Prabhu wrote:
>>>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>>>> index ce2a623abb75..b36cfd83eb76 100644
>>>> --- a/include/uapi/linux/rtnetlink.h
>>>> +++ b/include/uapi/linux/rtnetlink.h
>>>> @@ -164,6 +164,13 @@ enum {
>>>>         RTM_GETNEXTHOP,
>>>>  #define RTM_GETNEXTHOP RTM_GETNEXTHOP
>>>>
>>>> +       RTM_NEWALTIFNAME = 108,
>>>> +#define RTM_NEWALTIFNAME       RTM_NEWALTIFNAME
>>>> +       RTM_DELALTIFNAME,
>>>> +#define RTM_DELALTIFNAME       RTM_DELALTIFNAME
>>>> +       RTM_GETALTIFNAME,
>>>> +#define RTM_GETALTIFNAME       RTM_GETALTIFNAME
>>>> +
>>>
>>> I might have missed the prior discussion, why do we need new commands
>>> ?. can't this simply be part of RTM_*LINK and we use RTM_SETLINK to
>>> set alternate names ?
>>
>> How? This is to add/remove. How do you suggest to to add/remove by
>> setlink?
> 
> to that point, I am also not sure why we have a new API For multiple
> names. I mean why support more than two names  (existing old name and
> a new name to remove the length limitation) ?
> 
> Your patch series addresses a very important problem (we run into this
> limitation all  the time and its hard to explain it to network
> operators) and
>  its already unfortunate that we have to have more than one name
> because we cannot resize the existing one.
> 
> The best we can do for simpler transition/management from user-space
> is to keep the api simple..
> ie keep it close to the management of existing link attributes. Hence
> the question.
> 
> I assumed this would be like alias. A single new field that can be
> referenced in lieu of the old one.
> 
> Your series is very useful to many of us...but when i think about
> changing our network manager to accommodate this, I am worried about
> how many apps will have to change.
> I agree they have to change regardless but now they will have to
> listen to yet another notification and msg format for names ?
> 
> (apologies for joining the thread late and if i missed prior discussion on this)

I agree with Roopa. I do not understand why new RTM commands are needed.
The existing IFLA + ifinfomsg struct give more than enough ways to id
the device for adding / deleting an alternate name.

