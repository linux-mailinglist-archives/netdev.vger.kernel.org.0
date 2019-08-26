Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81BB09D3B9
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731865AbfHZQJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:09:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34395 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbfHZQJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:09:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id e8so355341wme.1
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 09:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cybcJyYGykj9kEjkqrl/7Cy1tZ0ONGalmpI8qt+6Fc4=;
        b=YWUzWeXQ2CeqOFRh0OcDoRyLEdwoGYkq9BF1m2bwhwuP/ymE1EOSGliL3s3GTUDQ1n
         7MWQZNY9hftEbXgTvAkxWIfiLAGDqcztZk2F/S6jxersmkQDZLHTQmaUozQyEwPyFSUa
         uDTDCxRptsjmrF4hZNzyh1c7u1DPxQr15kl49TbVYSjrns25PJIrW20UiDSPUBDb2mDo
         TgOFn4WPk60+rLCZrWwtoGpYy5cU2C6GtReav6ZYF9RC/nJ5umR0Kyxy6N7AyB+/s/d8
         8r6WITio+dJ6VXBootorpyRpS7V6CoT9kt2Z6tl/b7ALF+LoMvyg333oZx9Vt3hUk18/
         nJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cybcJyYGykj9kEjkqrl/7Cy1tZ0ONGalmpI8qt+6Fc4=;
        b=s43IalyIZW5syZoxwl4PG9fORVmtx/B1JKvrFSa27uvl9sqSUWiUvmgWviv8x0IjHf
         itUaJSBBP2RmPg4fsWBDSAXa+NkJbWripatFxM46J4aLyQiELZcC33SpCs+hf6Lo0OXP
         Zf0B9cjVbzUPV15yVHIzuuhS4BWPlQXeUFR/DYSYpJ/g8biRwr4BBipf2JNijAkOYu3z
         DdF4vhMGXVmsdQoaqiiKImrzYH3IzRQbvp8gQRXMSVWYMRQ63Srhjcr2/+0jDnMoMvqw
         pecSFwMh8BgZvSctUW8WCQR1IjTY9ITZx1FrgxClZBqJWWR2755edAH3l761ekbj1M6f
         Ik4g==
X-Gm-Message-State: APjAAAXmWSulqq5ET0l9fmxUN+mA5cg4EmfJ6uJVvhKndz7hbyiMNtja
        m4C75DUqBfg+XqOXrInKbTdjO9BkZhc=
X-Google-Smtp-Source: APXvYqxu6stSKcJSyE0KCP7ssctmMdGDb+efgXfJWguaamMaxdi9Ypg9paODIEn28OC1GKSiprJWdw==
X-Received: by 2002:a1c:a8c9:: with SMTP id r192mr23200116wme.43.1566835757782;
        Mon, 26 Aug 2019 09:09:17 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w8sm684496wmc.1.2019.08.26.09.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 09:09:17 -0700 (PDT)
Date:   Mon, 26 Aug 2019 18:09:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190826160916.GE2309@nanopsycho.orion>
References: <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
 <b43ad33c-ea0c-f441-a550-be0b1d8ca4ef@gmail.com>
 <20190813065617.GK2428@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813065617.GK2428@nanopsycho>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 08:56:17AM CEST, jiri@resnulli.us wrote:
>Mon, Aug 12, 2019 at 06:01:59PM CEST, dsahern@gmail.com wrote:
>>On 8/12/19 2:31 AM, Jiri Pirko wrote:
>>> Mon, Aug 12, 2019 at 03:37:26AM CEST, dsahern@gmail.com wrote:
>>>> On 8/11/19 7:34 PM, David Ahern wrote:
>>>>> On 8/10/19 12:30 AM, Jiri Pirko wrote:
>>>>>> Could you please write me an example message of add/remove?
>>>>>
>>>>> altnames are for existing netdevs, yes? existing netdevs have an id and
>>>>> a name - 2 existing references for identifying the existing netdev for
>>>>> which an altname will be added. Even using the altname as the main
>>>>> 'handle' for a setlink change, I see no reason why the GETLINK api can
>>>>> not take an the IFLA_ALT_IFNAME and return the full details of the
>>>>> device if the altname is unique.
>>>>>
>>>>> So, what do the new RTM commands give you that you can not do with
>>>>> RTM_*LINK?
>>>>>
>>>>
>>>>
>>>> To put this another way, the ALT_NAME is an attribute of an object - a
>>>> LINK. It is *not* a separate object which requires its own set of
>>>> commands for manipulating.
>>> 
>>> Okay, again, could you provide example of a message to add/remove
>>> altname using existing setlink message? Thanks!
>>> 
>>
>>Examples from your cover letter with updates
>>
>>$ ip link set dummy0 altname someothername
>>$ ip link set dummy0 altname someotherveryveryveryverylongname
>>
>>$ ip link set dummy0 del altname someothername
>>$ ip link set dummy0 del altname someotherveryveryveryverylongname
>>
>>This syntactic sugar to what is really happening:
>>
>>RTM_NEWLINK, dummy0, IFLA_ALT_IFNAME
>>
>>if you are allowing many alt names, then yes, you need a flag to say
>>delete this specific one which is covered by Roopa's nested suggestion.
>
>Yeah, so you need and op inside the message. We are on the same page,
>thanks.

DaveA, Roopa. Do you insist on doing add/remove of altnames in the
existing setlist command using embedded message op attrs? I'm asking
because after some time thinking about it, it still feels wrong to me :/

If this would be a generic netlink api, we would just add another couple
of commands. What is so different we can't add commands here?
It is also much simpler code. Easy error handling, no need for
rollback, no possibly inconsistent state, etc.

