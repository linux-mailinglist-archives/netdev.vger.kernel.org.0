Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25BB467F9
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 21:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfFNTAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 15:00:47 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40258 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfFNTAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 15:00:47 -0400
Received: by mail-io1-f66.google.com with SMTP id n5so8003269ioc.7
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 12:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=GviFqp5zxQ3IvPdylfcBBW11sR+2WAKrYJcFtseFB2E=;
        b=sckt7Phim1kuc7cWk2qC0gpocjKB6N9Q8uKsNC9fXBLiRIlEXGau3DTHZPkB/GTr1Z
         yXoWGQPNI6sjF3F1ORnt/uZRODJM9S0ASnM5Iq+dTnSf5sn0V2odO2xxaA2MLaj78Cm+
         sUOkEhQIDG5kbDTHLgdHPL2ySkzZNQweCbKLNHq+saZxpFLcChZ8A+sF27m/5xX6bEt+
         f9uAmPh117M2NOP6sCbZIsAwItiKaa8oJ7UV19FuyZqeqMBQQNmLsIGY3njSwDGAgodr
         AIb1t2+tOD9LKy49ERpXPmpgtzQ214qjhVjXYqx4pszmrbA9oyxx1khFKSEWNlUs2nHR
         cLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=GviFqp5zxQ3IvPdylfcBBW11sR+2WAKrYJcFtseFB2E=;
        b=OvrHulkveAcj0eJZ93MeZfolb7byhdORIOvlY/9uIPIClDABetg/heHm/ar+YgxT+n
         czn3EMNWwEbRxCW/PRJlcD+AIceIqweh+TLtuSy96kCDp9knutONDs/lBiQ6vFAG0YA+
         DqvCkunWPxUnA4X9LFreZu7SJIOXtEFGKcCH1X2SDyJ2MJoN9gS1cPBpy+Cg6U1GFafr
         7jshf9VsOc9kNGkSuKXItcQmNgubTDoBL9OAAMFVuWJ2RWF6VOFuShfdSofofYr0nhQd
         mxHkoUGiP07MfV/VPsgg1r8+ipBaXMQc++sw9+jcJFURasbw1JCXBa/ojoZjcdbhRv2s
         frSQ==
X-Gm-Message-State: APjAAAXc1dO34dN2AEXKZQHdX4tPl9qAbl3sCF9rEt0R/S1/EeR1TPNA
        3/pK6XGp8bhJC+kqmhfGL7rh9Q==
X-Google-Smtp-Source: APXvYqw1GvAKt+4U2uvzpX9UiEbexildgcvLxEuVXwM11IEWwPvXXDisWfmqomNc3ptCYUpm7WDaKA==
X-Received: by 2002:a6b:7606:: with SMTP id g6mr13069308iom.288.1560538846616;
        Fri, 14 Jun 2019 12:00:46 -0700 (PDT)
Received: from sevai ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id w23sm5717747ioa.51.2019.06.14.12.00.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 12:00:46 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
Subject: Re: [iproute2 net-next PATCH] ip: add a new parameter -Numeric
References: <20190612092115.30043-1-liuhangbin@gmail.com>
        <85imtaiyi7.fsf@mojatatu.com>
        <c8bb54a4-604e-3082-c0bb-70c2ac1548b2@gmail.com>
Date:   Fri, 14 Jun 2019 15:00:45 -0400
In-Reply-To: <c8bb54a4-604e-3082-c0bb-70c2ac1548b2@gmail.com> (David Ahern's
        message of "Fri, 14 Jun 2019 08:04:23 -0600")
Message-ID: <85muikuh42.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 6/12/19 10:01 AM, Roman Mashak wrote:
>> Hangbin Liu <liuhangbin@gmail.com> writes:
>> 
>>> Add a new parameter '-Numeric' to show the number of protocol, scope,
>>> dsfield, etc directly instead of converting it to human readable name.
>>> Do the same on tc and ss.
>>>
>>> This patch is based on David Ahern's previous patch.
>>>
>> 
>> [...]
>> 
>> It would be good idea to specify the numerical format, e.g. hex or dec,
>> very often hex is more conveninet representation (for example, when
>> skbmark is encoded of IP address or such).
>> 
>> Could you think of extending it '-Numeric' to have an optional argument
>> hex, and use decimal as default.
>> 
>
> I do not see how such an option could work.

'numeric' is extern object, so can be accessible from other modules. But
yes, it would require to add some wrappers around print_*int() APIs to
take into account this new parameter.

Yes, it is all-or-nothing approach, one can't have filters dumping their
integers values in hex but actions attached to the filters in decimal
(or the other way around).

> It would be best for iproute2 commands to output fields as hex
> or decimal based on what makes sense for each.

For example, m_police.c historically dumps its index value in hex,
although it's not very sensible IMHO :) Now it's risky to change the code,
because many scripts will likely break.

> That said, I do not see how this patch affects fields
> such as skbmark. Can you give an example? The patch looks fine to me.

The patch only exposes 'numeric' to tc, so yes -- it does not affect
anything. I only suggested to think of more generic approach.

On the 2nd thought: there already exists argument "-raw" for tc which
currently instructs printing handles in hex representation. Why not to
adopt this for ip and ss as well rather then adding new key?
