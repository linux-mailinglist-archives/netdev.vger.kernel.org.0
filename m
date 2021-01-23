Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8792E30188D
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 22:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbhAWVdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 16:33:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbhAWVdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 16:33:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611437507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WvOaj8hv0KE32bVTxypzvxrVf11BMqlkb446o+mx/s0=;
        b=JUePJ5lNasIt0WxvXQsLGdnKSkV6x0scjg5ix9wMGEjf3G7r8uZAJXaTTF/hreBW7ZaECa
        54VrwDQAXiy0FUmJSWqifjW/2/FfKQDxdOztHR+XE+a9UPN1E3IUOXyo7PY+YF+3VuhTMi
        vt+cNQStLW3+/TofQQz4Fz1jlTBpG5c=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-qzAnk_Y9NVe6yzH3-VzVcw-1; Sat, 23 Jan 2021 16:31:44 -0500
X-MC-Unique: qzAnk_Y9NVe6yzH3-VzVcw-1
Received: by mail-ed1-f72.google.com with SMTP id a24so5000374eda.14
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 13:31:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WvOaj8hv0KE32bVTxypzvxrVf11BMqlkb446o+mx/s0=;
        b=hxGNYTMGBSe1UAcOEnyFXV5Zxn+miA9gODFDi1EV71/f6XQZ1KN8cvHEAZV1itRxlM
         3Fps/yMbToV+AanU3uhdI4QMiN1pgac/E/Lbmyq4w8T8cbqGD6lWNQYXxygxbJpdb6jt
         zzlAB8j7rYlcJk+SoufEzy6Q1yEZCxveb9rKbqNDIAKUaLbVcRygWneNBPY2K6p/zYGd
         N/4dWeQipj2ghtisSk7tJKLTtET4VzjWkGqb+3HHp5OzlXrq2uOVCXF1VT9M0Bjf8AML
         eJXWA0oE+gbVEN2sCmWjpHxW/vPMjaB9YVzokWJ/UEmxfcEKaXkMOjpodLjYBOEkUbq+
         uWtA==
X-Gm-Message-State: AOAM532W39oFrtuurK+S0stuL+XuUU4gA7NrM8oTqpKqDrlsR07vRndg
        0TzU+B7oRqLXcg9OiNM8GUoF53M4L6Ym4m5a/1eszEwsJvCnnegWjgHYouHcz51aWYK15QEk8bv
        Zmacp5wqhqh4ar+fr
X-Received: by 2002:a05:6402:1655:: with SMTP id s21mr7871477edx.360.1611437502769;
        Sat, 23 Jan 2021 13:31:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxTtcO7wYhsvRpjs3RnOtimCoehr2ES4ctqHG7peNecCWcQvyrp4NROH9HDnT0itXz4n4tyHg==
X-Received: by 2002:a05:6402:1655:: with SMTP id s21mr7871470edx.360.1611437502624;
        Sat, 23 Jan 2021 13:31:42 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-37a3-353b-be90-1238.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:37a3:353b:be90:1238])
        by smtp.gmail.com with ESMTPSA id q2sm7588078edv.93.2021.01.23.13.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Jan 2021 13:31:42 -0800 (PST)
Subject: Re: pull-request: mac80211 2021-01-18.2
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
References: <20210118204750.7243-1-johannes@sipsolutions.net>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <77c606d4-a78a-1fa3-5937-b270c3d0bbd3@redhat.com>
Date:   Sat, 23 Jan 2021 22:31:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118204750.7243-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/21 9:47 PM, Johannes Berg wrote:
> Hi,
> 
> New try, dropped the 160 MHz CSA patch for now that has the sparse
> issue since people are waiting for the kernel-doc fixes.
> 
> Please pull and let me know if there's any problem.
> 
> Thanks,
> johannes
> 
> 
> 
> The following changes since commit 220efcf9caf755bdf92892afd37484cb6859e0d2:
> 
>   Merge tag 'mlx5-fixes-2021-01-07' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2021-01-07 19:13:30 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-01-18.2
> 
> for you to fetch changes up to c13cf5c159660451c8fbdc37efb998b198e1d305:
> 
>   mac80211: check if atf has been disabled in __ieee80211_schedule_txq (2021-01-14 22:27:38 +0100)
> 
> ----------------------------------------------------------------
> Various fixes:
>  * kernel-doc parsing fixes
>  * incorrect debugfs string checks
>  * locking fix in regulatory
>  * some encryption-related fixes
> 
> ----------------------------------------------------------------
> Felix Fietkau (3):
>       mac80211: fix fast-rx encryption check
>       mac80211: fix encryption key selection for 802.3 xmit
>       mac80211: do not drop tx nulldata packets on encrypted links
> 
> Ilan Peer (1):
>       cfg80211: Save the regulatory domain with a lock

So I'm afraid that I have some bad news about this patch, it fixes
the RCU warning which I reported:

https://lore.kernel.org/linux-wireless/20210104170713.66956-1-hdegoede@redhat.com/

But it introduces a deadlock. See:

https://lore.kernel.org/linux-wireless/d839ab62-e4bc-56f0-d861-f172bf19c4b3@redhat.com/

for details. Note we really should fix this new deadlock before 5.11
is released. This is worse then the RCU warning which this patch fixes.

Regards,

Hans



> 
> Johannes Berg (1):
>       cfg80211/mac80211: fix kernel-doc for SAR APIs
> 
> Lorenzo Bianconi (1):
>       mac80211: check if atf has been disabled in __ieee80211_schedule_txq
> 
> Mauro Carvalho Chehab (1):
>       cfg80211: fix a kerneldoc markup
> 
> Shayne Chen (1):
>       mac80211: fix incorrect strlen of .write in debugfs
> 
>  include/net/cfg80211.h |  5 ++++-
>  include/net/mac80211.h |  1 +
>  net/mac80211/debugfs.c | 44 ++++++++++++++++++++------------------------
>  net/mac80211/rx.c      |  2 ++
>  net/mac80211/tx.c      | 31 +++++++++++++++++--------------
>  net/wireless/reg.c     | 11 ++++++++++-
>  6 files changed, 54 insertions(+), 40 deletions(-)
> 
> 

