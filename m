Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDE839E15C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhFGQCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:02:39 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:42932 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhFGQCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 12:02:38 -0400
Received: by mail-ed1-f53.google.com with SMTP id i13so21016909edb.9;
        Mon, 07 Jun 2021 09:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=f1Picyv92DBNFnyWc2siMe7sp2wXeSWEx4iNIZ5Pf5w=;
        b=dL07qiP7TOSZbZOSw8ZTFQlXosJ0Gy144toG1HMQyHTlWp4YQUPmaSUFHO0lwsieuh
         d8JLY1Lg25QAIh12ny6aD6fwUZJJxLDUzQ9br3xZwkWaOwSbt+A7uX1Kq/dm8CHps7l6
         ortqszK9HV3wVO+D0dUuMDY91hHI1RyM8nS6iLgoB+Myc/iNOITMFjemMokj+cci4806
         TYjNUXZ3/Z7Cmn6czunKKBUVqrR96xi1hd1La62JcZ9wzoCshtcmiyTOm0TZ3ec3fYzS
         06nCd6AbMQTC4zUANpewzOXlT3SGiAkr909gTmzaaXn/lpTlgNR7fhquopggpWpCfDjP
         LB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=f1Picyv92DBNFnyWc2siMe7sp2wXeSWEx4iNIZ5Pf5w=;
        b=LESD79Ta1CPgAtMFJq7FwvTyldQ6Nff62D+lVjV03AH8sJDo6OfonYWzzZhfwXGmBc
         6653wtJbL89GFlez0LuuC8VtMMco6WVEz4u5xQf24m/PRCbbl39OxetWXOwpO0IcTFJr
         +lhbBOb+n91PIiZZSuLEXgWPqy1B+HgsEF4rTwOIcPG5cjkISEOzsLORRiIkZUIb1KY2
         CpGSF1yx5Wn14+lTsr+rdOOKTHNRQMBYMKgftmO4a/SUMPZJXO4iDwBbNLpvEZTAnye9
         K8xkjQvJG1nJr+DI2YnluicsnceQEiFm5TfjKFdHxMLA6MUxwh7HFQRYdry6ptgIb486
         oUcw==
X-Gm-Message-State: AOAM530ILEg4ySdqo5fXUtyJPEDQw3o/i0JQTg6lGWXCBZhBI/boyGuZ
        Cu+cfE+R+gbzfSwV6tNFt8HWR2gGm5+oedfel2Uj41+9W4Ah4A==
X-Google-Smtp-Source: ABdhPJw2VAWCKse4tSPNvYI+lLRKFUw2bKeeeE6O+RzAW4YHEVLLICwCcpxLxxVbWJGDW1CeChfB831LSe0kn7R6QsA=
X-Received: by 2002:aa7:c40f:: with SMTP id j15mr19816194edq.169.1623081585663;
 Mon, 07 Jun 2021 08:59:45 -0700 (PDT)
MIME-Version: 1.0
From:   Ujjal Roy <royujjal@gmail.com>
Date:   Mon, 7 Jun 2021 21:29:34 +0530
Message-ID: <CAE2MWkkL9x+FRzggdOSPcyFpguwP9VuQPD9AJWLTsfLzaLodfQ@mail.gmail.com>
Subject: net: bridge: multicast: Renaming of flag BRIDGE_IGMP_SNOOPING
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, Kernel <netdev@vger.kernel.org>,
        Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

Can we rename this flag BRIDGE_IGMP_SNOOPING into something like
BRIDGE_MULTICAST_SNOOPING/BRIDGE_MCAST_SNOOPING? I am starting this
thread because this BRIDGE_IGMP_SNOOPING flag holds information about
IGMP only but not about MLD. Or this is not a common name to describe
both IGMP and MLD. Please let me know about my concern, so that I can
change the code and submit a patch.

Thanks,
UjjaL Roy
