Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1588D168CE4
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 07:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgBVGid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 01:38:33 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52840 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgBVGid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 01:38:33 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so3947682wmc.2
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 22:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QgCFlHvm4fLTi5GvxA3T6cQ6OUDJLQ9Y8WqEbsncuTo=;
        b=gBNGsbA+2BlA4abpO5FpbnYKYATPgO3WMNzqnCU6UqTF5APTf1zmEhgwbiJ38oMXJk
         XEhIcbMA5bDa6eZJy0UFUG5sgpcjlHhptsp2wVpY59RFRtHaYL6Rc4YhSVugVBEcou/f
         BDgpb19EEpGxTa6wm1e28Nt5co8pD2SNk7OqYG5RF+RtLFI0319welNn5Wb7OvASUVTS
         M/eF7Rirp26Fl2tBf2oOfFT6VepZQTyGgv85ZLvpzujD/WmwOwIc2Cbqs1by8Q/NC7uJ
         ASFedsVH9BwXb1TRwL03arIm3iakCO0nKoeMC4m9LnShinyNwj3DtW9496vSk7JMmB1A
         ZfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QgCFlHvm4fLTi5GvxA3T6cQ6OUDJLQ9Y8WqEbsncuTo=;
        b=rdyFVezqrH4887VnW5dNHxsMhkzdYJyPibh00721RIoN/LbOEIMN4wefgR9pSbU9+d
         WH4NapGXExd5mem1P0PoCJMh1/ZlNutUQJPJW5omKpcHl2C17lpST26ESc5KCeSymvXh
         Rv3976R+6xmTZqOOa3h8JWJl/gwa0Jd2tBjh6v6W5BivZZKzGAuSJ2MVWwWsqncZJT12
         gxroLyUqwGpBoZFjxKRWCdc9y4GJPden0W4aSjo7A4tyuPbGt9nlV+re1uz9ibtPwu0Z
         pq1mKiMpxBDkWEmNmSlgcwbVOwFb6kVnIhPRBwW9sCiF7/h19WXMbeU0xDZQu+fCg4FY
         zNtw==
X-Gm-Message-State: APjAAAWetL3AH37Y/sOXkmTlsYmglnPg4DE4XUwv+0x5nqKsWuRUdzbo
        iyA4W3Hdg2QuqdOjNPzliUDnTg==
X-Google-Smtp-Source: APXvYqxqtfHn65UH+ElfBusEJTgHTfnfEu752clqz7AlK5xw1Whysq7ctGMehyQX7LH8a146nkOnDA==
X-Received: by 2002:a7b:ce18:: with SMTP id m24mr8325869wmc.123.1582353510747;
        Fri, 21 Feb 2020 22:38:30 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id f8sm7228575wrt.28.2020.02.21.22.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 22:38:30 -0800 (PST)
Date:   Sat, 22 Feb 2020 07:38:29 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com,
        Edward Cree <ecree@solarflare.com>
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW
 stats type
Message-ID: <20200222063829.GB2228@nanopsycho>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 21, 2020 at 07:22:00PM CET, kuba@kernel.org wrote:
>On Fri, 21 Feb 2020 10:56:33 +0100 Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Currently, when user adds a TC filter and the filter gets offloaded,
>> the user expects the HW stats to be counted and included in stats dump.
>> However, since drivers may implement different types of counting, there
>> is no way to specify which one the user is interested in.
>> 
>> For example for mlx5, only delayed counters are available as the driver
>> periodically polls for updated stats.
>> 
>> In case of mlxsw, the counters are queried on dump time. However, the
>> HW resources for this type of counters is quite limited (couple of
>> thousands). This limits the amount of supported offloaded filters
>> significantly. Without counter assigned, the HW is capable to carry
>> millions of those.
>> 
>> On top of that, mlxsw HW is able to support delayed counters as well in
>> greater numbers. That is going to be added in a follow-up patch.
>> 
>> This patchset allows user to specify one of the following types of HW
>> stats for added fitler:
>> any - current default, user does not care about the type, just expects
>>       any type of stats.
>> immediate - queried during dump time
>> delayed - polled from HW periodically or sent by HW in async manner
>> disabled - no stats needed
>
>Hmm, but the statistics are on actions, it feels a little bit like we
>are perpetuating the mistake of counting on filters here.

You are right, the stats in tc are per-action. However, in both mlxsw
and mlx5, the stats are per-filter. What hw_stats does is that it
basically allows the user to set the type for all the actions in the
filter at once. 

Could you imagine a usecase that would use different HW stats type for
different actions in one action-chain?

Plus, if the fine grained setup is ever needed, the hw_stats could be in
future easilyt extended to be specified per-action too overriding
the per-filter setup only for specific action. What do you think?


>
>Would it not work to share actions between filters which don't need
>fine grained stats if HW can do more filters than stats?

For mlxsw it would work, if the action chain would be identical. For
that you don't need the per-action granularity of setting type hw_stats.

>
>Let's CC Ed on this.
>
