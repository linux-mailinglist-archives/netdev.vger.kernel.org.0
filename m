Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BD63A345C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhFJT5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhFJT5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:57:35 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE108C061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:55:25 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id b9so3002256ilr.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yThRUwhG7TVMYzDnZQ36xlr9oSGBGPDfSkCu6ZGlYLg=;
        b=bPBjb3iQyivF7+ujnusT5zb7CgKPA/MPb60wwSSgl0fWJCJFIRsspxS5FLO3i3Db7o
         QTBIFLfWtoa+OTwkJsl8Od0iL6SjdITaP1KUiA1ZLnO0nbgYzNu8qBP6bqF9wOw6coVS
         0TZuIt7YeN1EtKC3bKArUXZMWQq1C4xTGVKSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yThRUwhG7TVMYzDnZQ36xlr9oSGBGPDfSkCu6ZGlYLg=;
        b=p+Lb0L+eO1wGza4lSXZbnRL079omGAyWZe8MyksyH6fm/U5Wh+DSS5QSzPZXVmwIBJ
         SAPMpgH1NaanRdXj70P7awHBs0Sn7LqlucCBO5Cm4QCd5ku3J1Tgh4I1q7sokLPR6ESw
         1rF7Mx53iwUkCYYwOp4Of0vjR9DD+Xz1cNarNyED23ctWLCAlUk1mNsgvePSJfbtjKZy
         H+7RbEL8oPjmqkk0q/UA5JQx5k5WLPQ9P1Ssjzy/+dvAzPIbPXGXdvjg0sbtLDnOLm5t
         ENDbwAseJSbmwURvG3zYi+yjxFg3+k4NRd5O5RrQZo5PNKC3mpj/3FtaQ9hpDVOo4bCR
         Olkw==
X-Gm-Message-State: AOAM531pkMim/oW1I0bkRRKrcOd0g76QT+7diOZuMfty/7hDK0UTKj6h
        4/xH3slzV3nFwd5IZ0CMY8nvvA==
X-Google-Smtp-Source: ABdhPJxrEvwWy3XAmz/7jj02iTalwtXM7UAmJCMJjFJ1UH5U58C7wt3JsSnlbOrDwD06v36kFE802g==
X-Received: by 2002:a05:6e02:4b0:: with SMTP id e16mr335801ils.71.1623354925138;
        Thu, 10 Jun 2021 12:55:25 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u18sm2447941ilb.51.2021.06.10.12.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 12:55:24 -0700 (PDT)
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
To:     Steven Rostedt <rostedt@goodmis.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <YH2hs6EsPTpDAqXc@mit.edu>
 <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
 <YIx7R6tmcRRCl/az@mit.edu>
 <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com>
 <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
 <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
 <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
 <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
 <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
 <20210610152633.7e4a7304@oasis.local.home>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
Date:   Thu, 10 Jun 2021 13:55:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210610152633.7e4a7304@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/21 1:26 PM, Steven Rostedt wrote:
> On Thu, 10 Jun 2021 21:39:49 +0300
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> 
>> There will always be more informal discussions between on-site
>> participants. After all, this is one of the benefits of conferences, by
>> being all together we can easily organize ad-hoc discussions. This is
>> traditionally done by finding a not too noisy corner in the conference
>> center, would it be useful to have more break-out rooms with A/V
>> equipment than usual ?
> 
> I've been giving this quite some thought too, and I've come to the
> understanding (and sure I can be wrong, but I don't think that I am),
> is that when doing a hybrid event, the remote people will always be
> "second class citizens" with respect to the communication that is going
> on. Saying that we can make it the same is not going to happen unless
> you start restricting what people can do that are present, and that
> will just destroy the conference IMO.
> 
> That said, I think we should add more to make the communication better
> for those that are not present. Maybe an idea is to have break outs
> followed by the presentation and evening events that include remote
> attendees to discuss with those that are there about what they might
> have missed. Have incentives at these break outs (free stacks and
> beer?) to encourage the live attendees to attend and have a discussion
> with the remote attendees.
> 
> The presentations would have remote access, where remote attendees can
> at the very least write in some chat their questions or comments. If
> video and connectivity is good enough, perhaps have a screen where they
> can show up and talk, but that may have logistical limitations.
> 

You are absolutely right that the remote people will have a hard time
participating and keeping up with in-person participants. I have a
couple of ideas on how we might be able to improve remote experience
without restricting in-person experience.

- Have one or two moderators per session to watch chat and Q&A to enable
   remote participants to chime in and participate.
- Moderators can make sure remote participation doesn't go unnoticed and
   enable taking turns for remote vs. people participating in person.

It will be change in the way we interact in all in-person sessions for
sure, however it might enhance the experience for remote attendees.

thanks,
-- Shuah
