Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEEBA104597
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfKTVWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 16:22:18 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36975 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKTVWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 16:22:18 -0500
Received: by mail-qk1-f196.google.com with SMTP id e187so1200858qkf.4
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 13:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=dNN3QSPg5qZsdUba3YVMXeGbFwn5OLVwTziw/+HVaOc=;
        b=kVACOyvWgooWFBICKf+2sgoQ6UxYRcC/x/SmQcmq0XcawVcVh8ASWIlPtWcRjsbAJD
         84qi1/1CsTxJkPXOjAC5x+m+SoZ5VHPsVVCsotvBVmRfPGgM6Jz9cRPj4hlXkhN0Wbjf
         IEEFLZaNED7//bcRqFoUgipCXGIzZYiKneVDrps/9vD//2/WfeTqWreyKMYyS8xa/FkS
         nwWXkEadCpzBmwsxA6au67VC4t/5GDMU2dx2DarTzJNCwz7GThIu7kyefdBnRBcdecHY
         1vtUJXZhtxZSvoTUM+Dph57WmEMvowy2wRfN0PbqdtClzqepV1DGrzZ3QXjRIxJrxEUw
         c+Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=dNN3QSPg5qZsdUba3YVMXeGbFwn5OLVwTziw/+HVaOc=;
        b=rKXUFKXHAd/z9GmWp5SduvYSEEIHAY34uaRGY1nJX84AninSpdW3KlZeYu5bI+QGyL
         Zdg7yPBsRWWMvZjTk5t6M3UU/u6MeqquwN63yH9Bq5x8whSLBhtfp6POUm87uwpFUhPL
         wVD8bkZj8Zvhr4QzdqrzW8wLw/pnpIlsKqJYB+gsAQCMomRilPjzVhqsEh8HrpGOJeNJ
         BbLuLdqmRfXmV06d6PUzhichEWSCcxmjxMaAy5BESKs/9pbKg7aR2VB0e1HDiQb18tar
         XxEH+ulgnsETXn/+F8VwjEsxRSs81dVXXbhFxK5SOjr2fUu+fJl/7PwkGNKp9K0i9AKQ
         1akw==
X-Gm-Message-State: APjAAAUeC/3NqvbTg1GeVr/FLBBKm3Ojas3cCb/BsSnwg+L1ytt04l11
        SyC2I9dTwA4Ig/W9Hr14ZoB6mA==
X-Google-Smtp-Source: APXvYqz3lQPEjo2AUYvAhq5xuyG1oX3hKcfaYkMVrh8HJGeSH2GqFYUnyfOhXVslgVbZT8ZbNjgn1w==
X-Received: by 2002:a37:4906:: with SMTP id w6mr4733269qka.82.1574284937039;
        Wed, 20 Nov 2019 13:22:17 -0800 (PST)
Received: from sevai (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id n185sm289039qkd.32.2019.11.20.13.22.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 13:22:16 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Petr Machata <petrm@mellanox.com>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [RFC PATCH 10/10] selftests: qdiscs: Add test coverage for ETS Qdisc
References: <cover.1574253236.git.petrm@mellanox.com>
        <4c364de6add3e615f1675ddb4d2911491a65bd8a.1574253236.git.petrm@mellanox.com>
        <85h82ybmun.fsf@mojatatu.com> <87o8x6d05t.fsf@mellanox.com>
Date:   Wed, 20 Nov 2019 16:22:15 -0500
In-Reply-To: <87o8x6d05t.fsf@mellanox.com> (Petr Machata's message of "Wed, 20
        Nov 2019 15:42:40 +0000")
Message-ID: <85d0dmb5vc.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr Machata <petrm@mellanox.com> writes:

> Roman Mashak <mrv@mojatatu.com> writes:
>
>> Petr Machata <petrm@mellanox.com> writes:
>>
>>> Add TDC coverage for the new ETS Qdisc.
>>>
>>
>> It would be good to have tests for upper bound limits of qdisc
>> parameters.
>
> All right. I can think of "bands 16", and then "quantum $(((1 << 32) -
> 1))", but I'm not sure the latter is very useful. Did you have anything
> else in mind?

I think, any test that would validate the user's input of parameters
would suffice, e.g. min/max acceptable values, range of values and
such.
