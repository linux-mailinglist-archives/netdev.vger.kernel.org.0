Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C247CCB9
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbfGaT0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:26:34 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:55902 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbfGaT0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:26:33 -0400
Received: by mail-wm1-f52.google.com with SMTP id a15so61997343wmj.5
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 12:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mubkzwfTtIiiIvlU6xgnNrUYBmisWAZ++4DseuzppGE=;
        b=dOfud6nRSx72ZYESOVj8WE0iK2YRMYoHZ88M6NgrQK9qNfIKX3n07xDRmQrWXJT+CK
         J2W+RlSBNohVYrIWOrYsMu6+Zw5ax+YSZ4kaiRpPxsCtpMBhwnT5W8hD18dAlfOBJjdC
         41+kzCEm07rCsM00RUybkTWW4O5opuR4gBdYarYg73SmSJRxI5BKn1SVUiQ7tl3CRE3p
         zcav7LpDjRqIBEADaNLrC97i/sXRaNtLj7cZTeLccGL9SYUURgyw1BRUb5DTpnhqXFk7
         PhAcdmxbU7K3zAnShVrENJxT4JGd+k2R6ZMFtk5g8gD0Cjxo0j5iJ6IwPmmGwGykF+/f
         kdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mubkzwfTtIiiIvlU6xgnNrUYBmisWAZ++4DseuzppGE=;
        b=iJft/yuQsbXAaoLwTdhafQP3TTvwnQEeIhU0bMN/RhH1xhgGRwb+Gtsl9gGBKuTt8V
         pRkbuO2ujNW0SVIsjPrNbaAzjwiHPQCTPdkNwHw5A3C0zpI2PazjmvB+17PGbI2dLf9X
         WEVcFGHPKYNOO6u/GtHqHtTThfvRyyPtz48M/figyjRiZDQ7Tioy91FeebaXaNFiSKt9
         T3p5scDyk7A6tBCd17eqMulaZedfQC8D2Z8hatPfGrEsWo1uXXQrdW1V/8H3shjwUkBr
         OdcfD9cujnvEo9zry5sgR56SwweXMV5nzM4KC99Os7ZLEJXhYUU4uKTvFRXSEqmFvcO2
         t0zA==
X-Gm-Message-State: APjAAAWUzPbuumjfpbDnAhyXa4rPn7R4s5my4dit1L7IhBk0eTN8W6GN
        nQ7dD1sVKyvrj0zTZDxJPR0=
X-Google-Smtp-Source: APXvYqzpRC6bzwD2B87UM3EWUF3Mm5aQVzJpLO62wEcGcxczsv0cqccgaIm0P/xXjDKRJ32ZiEj5Xw==
X-Received: by 2002:a7b:c195:: with SMTP id y21mr109054105wmi.16.1564601191875;
        Wed, 31 Jul 2019 12:26:31 -0700 (PDT)
Received: from localhost ([80.82.155.62])
        by smtp.gmail.com with ESMTPSA id o20sm174908835wrh.8.2019.07.31.12.26.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 12:26:31 -0700 (PDT)
Date:   Wed, 31 Jul 2019 21:26:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
Message-ID: <20190731192627.GB2324@nanopsycho>
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730153952.73de7f00@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 31, 2019 at 12:39:52AM CEST, jakub.kicinski@netronome.com wrote:
>On Tue, 30 Jul 2019 10:57:32 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> All devlink instances are created in init_net and stay there for a
>> lifetime. Allow user to be able to move devlink instances into
>> namespaces.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>I'm no namespace expert, but seems reasonable, so FWIW:
>
>Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>
>If I read things right we will only send the devlink instance
>notification to other namespaces when it moves, but not
>notifications for sub-objects like ports. Is the expectation 
>that the user space dumps the objects it cares about or will
>the other notifications be added as needed (or option 3 - I 
>misread the code).

You are correct. I plan to take care of the notifications of all objects
in the follow-up patchset. But I can do it in this one if needed. Up to
you.


>
>I was also wondering it moving the devlink instance during a 
>multi-part transaction could be an issue. But AFAIU it should 
>be fine - the flashing doesn't release the instance lock, and 
>health stuff should complete correctly even if devlink is moved
>half way through?

Yes, I don't see any issue there as well.

