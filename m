Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10C58B043
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfHMG4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:56:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35991 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfHMG4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:56:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so454209wme.1
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 23:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w1E/iOlisTaCj0R6JUtbioWRiEl7HFXZ/F4BiXW1yeY=;
        b=mnvHbOp0bt2F2kOZq9BCjGzG6JG8aVkNAziT6VVTSomgns71yT2rKDJYQtKTKtgL21
         gIGlHdKcKfWsY/ev+fjthCl4BcpnTa+afYMRNlcEyZJTc4BLx8IyGm9D5EZaHR8Nu1xC
         S414py+l+RVtaTwKdUOuckTBI7aHtorEcNQBKhMpP+xHksVrSzZsJKYdp81FmjqlasNi
         bJIX4llmCXKKs1ws7UZXeuIKnzEEmDyTQ8mwTodfMJPYVfnK1L1Ze0TQFOx4p4CeAqA0
         zDFTK7eCvynRS3g+1HmkaNshXUVcPsjEldT3q/I604Y1J1Je0erXMIzGD5dyCt5/nL4u
         tPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w1E/iOlisTaCj0R6JUtbioWRiEl7HFXZ/F4BiXW1yeY=;
        b=meskXt9Lu/gHhqlCPNF/YgtWAkq4lW1nlZrbRvPX/2p/tR1OvkMn8g/ImkLoJq+NUh
         4MZbreh74M70ljBMGYxC0zgjeuKr2V28ko22MwKpd578rBznceQ5HJ3cqSX8Hp5uO32v
         IByQJl7+sHTXOIky+MSL7rWL2Fa/tuNMlEaIEI63taDaNgrpxPpWhwKc9DV1Qq97pi65
         LpWrCcn6Y28WSdhd+g+BLUcA8+TAegeScPAk1tPZziNK/23gy8f6H4kDZTeDnuVKBbIg
         tdfBSqKsVYLizVw8TTurN3OPlnIcukYBno5VFF8rqwvKviFemOjecxwrVoPsI5mjgwK7
         XLbw==
X-Gm-Message-State: APjAAAXtaqnWVcbO88sgt+yxUha0bI097P7a2WcQ4hGnRCgToe4eBSGN
        rp+gjRfOCVd3vrCeovtWtSznLQ==
X-Google-Smtp-Source: APXvYqxnpChi03vss7cXdUD+QSu0xQzrf7LzEo3xZ/jKH8lEojSNmZ0SoCQulEalaHFGVpyKxlGtEQ==
X-Received: by 2002:a1c:2d87:: with SMTP id t129mr1211904wmt.157.1565679378805;
        Mon, 12 Aug 2019 23:56:18 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id e11sm19457493wrc.4.2019.08.12.23.56.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 23:56:18 -0700 (PDT)
Date:   Tue, 13 Aug 2019 08:56:17 +0200
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
Message-ID: <20190813065617.GK2428@nanopsycho>
References: <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion>
 <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <5e7270a1-8de6-1563-4e42-df37da161b98@gmail.com>
 <20190810063047.GC2344@nanopsycho.orion>
 <b0a9ec0d-c00b-7aaf-46d4-c74d18498698@gmail.com>
 <3b1e8952-e4c2-9be5-0b5c-d3ce4127cbe2@gmail.com>
 <20190812083139.GA2428@nanopsycho>
 <b43ad33c-ea0c-f441-a550-be0b1d8ca4ef@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b43ad33c-ea0c-f441-a550-be0b1d8ca4ef@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 12, 2019 at 06:01:59PM CEST, dsahern@gmail.com wrote:
>On 8/12/19 2:31 AM, Jiri Pirko wrote:
>> Mon, Aug 12, 2019 at 03:37:26AM CEST, dsahern@gmail.com wrote:
>>> On 8/11/19 7:34 PM, David Ahern wrote:
>>>> On 8/10/19 12:30 AM, Jiri Pirko wrote:
>>>>> Could you please write me an example message of add/remove?
>>>>
>>>> altnames are for existing netdevs, yes? existing netdevs have an id and
>>>> a name - 2 existing references for identifying the existing netdev for
>>>> which an altname will be added. Even using the altname as the main
>>>> 'handle' for a setlink change, I see no reason why the GETLINK api can
>>>> not take an the IFLA_ALT_IFNAME and return the full details of the
>>>> device if the altname is unique.
>>>>
>>>> So, what do the new RTM commands give you that you can not do with
>>>> RTM_*LINK?
>>>>
>>>
>>>
>>> To put this another way, the ALT_NAME is an attribute of an object - a
>>> LINK. It is *not* a separate object which requires its own set of
>>> commands for manipulating.
>> 
>> Okay, again, could you provide example of a message to add/remove
>> altname using existing setlink message? Thanks!
>> 
>
>Examples from your cover letter with updates
>
>$ ip link set dummy0 altname someothername
>$ ip link set dummy0 altname someotherveryveryveryverylongname
>
>$ ip link set dummy0 del altname someothername
>$ ip link set dummy0 del altname someotherveryveryveryverylongname
>
>This syntactic sugar to what is really happening:
>
>RTM_NEWLINK, dummy0, IFLA_ALT_IFNAME
>
>if you are allowing many alt names, then yes, you need a flag to say
>delete this specific one which is covered by Roopa's nested suggestion.

Yeah, so you need and op inside the message. We are on the same page,
thanks.
