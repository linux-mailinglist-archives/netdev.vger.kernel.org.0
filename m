Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EA4268A19
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 13:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgINLbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 07:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgINL2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 07:28:33 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79471C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 04:28:32 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id t16so17205230edw.7
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 04:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ueJpq893gUO+axrd/5TX/kkh5xlTqV0vp+NxtBKI8r8=;
        b=vEOkSlbiTR0FB7u5nOEqCxgF9Y0JIfTIUnHf+eYnro+P2y7hFd86mdqfPNxSkRIl93
         K7lKy2LzTfI9cEUQrobvXAyvWk1R9xdNZOuZ5kwq39uZXSjs+S1xxvAl0LXSMxtcn3YO
         c6fBfNNbeOxb2SPvsud0lI+3s6LIkSbqnMdmHnIpt4C75aINOJPrtpFF9D9lhQ+KNPpI
         8VJEdmYEYvfwYV0zC/CPSHVThI0LHAD1kkBPmuygCWyjc6seLYPGu80m9CWiys3g6eN5
         yVMCSIW8L5KlaQPWzMt5kNMJvpxQqi8ogOTQmzl0gS80zHJqH79PeJgzyDjqH90N/OTr
         de1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ueJpq893gUO+axrd/5TX/kkh5xlTqV0vp+NxtBKI8r8=;
        b=LDM8NrZn/6cA0DBbIZU3adaAehtNXojh0osdwkLqEjDyHEjhsoBs6MNA2nfhRaPgCr
         9Pk7dhPaK9kYSWQrnfdM33D25kvlqsgl6xj7+WMLzaT19VHcQ74I4Xps5HVZp+u09I22
         K7zYfFqDQWRv2A3C+7jJ6UxV2LPz0js+6O5W638SulaSNlRbFeW+dYh91Obt8RzScS1K
         0E5nP5vgwFoNSlR0dDDQ7Oj6zs2l58VYAHbaC70Oz/WA15Kw81I/9DUebWpbCCmyoJiF
         UfATaQ37Z8/MvJ7N+b7HuTS2JFOaYiCvSiRXwRsnoI7eACR/NM5mvArkTbVoOft9Di7q
         bRUA==
X-Gm-Message-State: AOAM531IOTTGkUHPNHvdr3Aqu6rNXy4uQi75r4cTQUIT9vQuv0w6Tahl
        0Gaq6FAu6AHHqtj5QmAaP+YT0w==
X-Google-Smtp-Source: ABdhPJxxa22k0tyYYsZqkw575AdHLtFmcfXeXtQgasSchDYyiAjATwRvMqf2bds7G+REYxRqdiOb1A==
X-Received: by 2002:a05:6402:1151:: with SMTP id g17mr17054933edw.227.1600082911058;
        Mon, 14 Sep 2020 04:28:31 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c8sm7500970ejp.30.2020.09.14.04.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 04:28:30 -0700 (PDT)
Date:   Mon, 14 Sep 2020 13:28:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200914112829.GC2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-2-git-send-email-moshe@mellanox.com>
 <CAACQVJochmfmUgKSvSTe4McFvG6=ffBbkfXsrOJjiCDwQVvaRw@mail.gmail.com>
 <20200914093234.GB2236@nanopsycho.orion>
 <CAACQVJqVV_YLfV002wxU2s1WJUa3_AvqwMMVr8KLAtTa0d9iOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJqVV_YLfV002wxU2s1WJUa3_AvqwMMVr8KLAtTa0d9iOw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 14, 2020 at 11:54:55AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Mon, Sep 14, 2020 at 3:02 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Mon, Sep 14, 2020 at 09:08:58AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >On Mon, Sep 14, 2020 at 11:39 AM Moshe Shemesh <moshe@mellanox.com> wrote:
>>
>> [...]
>>
>>
>> >> @@ -1126,15 +1126,24 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>> >>  }
>> >>
>> >>  static int
>> >> -mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
>> >> -                                       struct netlink_ext_ack *extack)
>> >> +mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
>> >> +                                       struct netlink_ext_ack *extack,
>> >> +                                       unsigned long *actions_performed)
>> >Sorry for repeating again, for fw_activate action on our device, all
>> >the driver entities undergo reset asynchronously once user initiates
>> >"devlink dev reload action fw_activate" and reload_up does not have
>> >much to do except reporting actions that will be/being performed.
>> >
>> >Once reset is complete, the health reporter will be notified using
>>
>> Hmm, how is the fw reset related to health reporter recovery? Recovery
>> happens after some error event. I don't believe it is wise to mix it.
>Our device has a fw_reset health reporter, which is updated on reset
>events and firmware activation is one among them. All non-fatal
>firmware reset events are reported on fw_reset health reporter.

Hmm, interesting. In that case, assuming this is fine, should we have
some standard in this. I mean, if the driver supports reset, should it
also define the "fw_reset" reporter to report such events?

Jakub, what is your take here?


>
>>
>> Instead, why don't you block in reload_up() until the reset is complete?
>
>Though user initiate "devlink dev reload" event on a single interface,
>all driver entities undergo reset and all entities recover
>independently. I don't think we can block the reload_up() on the
>interface(that user initiated the command), until whole reset is
>complete.

Why not? mlxsw reset takes up to like 10 seconds for example.


>>
>>
>> >devlink_health_reporter_recovery_done(). Returning from reload_up does
>> >not guarantee successful activation of firmware. Status of reset will
>> >be notified to the health reporter via
>> >devlink_health_reporter_state_update().
>> >
>> >I am just repeating this, so I want to know if I am on the same page.
>> >
>> >Thanks.
>>
>> [...]
