Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E66E2CF1FC
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgLDQfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgLDQfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:35:53 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF251C061A4F
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 08:35:12 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id d20so8445590lfe.11
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 08:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CAsRWS1aUlzLi/q9+iMyq1zlfiHEboJsJ2mUECDL5Cs=;
        b=CBnRu/J0dCse2eVtVl2oV9dudg8v4BMaFCSxOlbnJlAM8+tVhew1X9HLQJyw4QW+iw
         ZbXetXic8Qyw5D7ZRGBCAzBnq8uczLv5PdlUhDhzGpK0V49a0yRqTgtaIbjv8DXJE8dN
         ZSqddmmVveNjt6OS+f44uFTVa4XcsmsQ9ZBV0mXGlJ6jpo8C1bHDcOJ6f+CyTyL7FhdL
         OFNxXtMaHlkRpqUcc+nRBuwMx2J83wzoZ4JigbXmqrq1OZXCZrsz3T9LFO065hXJay+3
         1+ml8N8NEpVvnBGmZ7ugwlLDJ2d7luPE57y+k4fzcicw18CV4bJTU86B9oAlRF/xCQsY
         YdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CAsRWS1aUlzLi/q9+iMyq1zlfiHEboJsJ2mUECDL5Cs=;
        b=SXbc+wX0tdFlO9HFD8fsQnY4zdM5NGA5is1QxsPbUY5E+pK5AM06BxkY0+l4WRacFs
         wBwSsX7ebAjP3NbnCn/1kdbZ5UE06Ta6IrnqlfEh+uhOmXc1Gzqvj5O5n7MYd2vfM375
         KGZNMKODnvA5vJZszMlNCOdDYckfWDrVBmtT51e4wym6tlhUGevmER0SMBflgL8xtIgk
         Yq1SNtqvlN88vaJEDW+/8VnfGcSoZrE9qytR4WlavZDYbkf+0qZFNIxwTaRuwE5avNhD
         hpba9odJcOCZVvYOJvo04+rkSVUvaVrg6m/4SW/yA35uzNjHVkzaXV6YQpzL/lEhtxt/
         KKLw==
X-Gm-Message-State: AOAM530v33ZWJ0ehAqM0G5Fcm6q2AGwDoW2TORMlk3ti9+vtQ/To9bps
        +7w599Yq00nGx/N6xX0XEUy+s0OQVbk6GTmtb1ozHQ==
X-Google-Smtp-Source: ABdhPJyRqostEN0F9Hqj98zRy8MICqwZh8zh84PLy0Vb+MPHtTCOypeYCneckx16Blb/LuHm/j9/rfZH4omFnl4adek=
X-Received: by 2002:a05:6512:5d6:: with SMTP id o22mr3915606lfo.574.1607099711115;
 Fri, 04 Dec 2020 08:35:11 -0800 (PST)
MIME-Version: 1.0
References: <20201203102936.4049556-1-apusaka@google.com> <20201203182903.v1.1.I92d2e2a87419730d60136680cbe27636baf94b15@changeid>
 <20B6F2AD-1A60-4E3C-84C2-E3CB7294FABC@holtmann.org> <CAJQfnxHDThaJ58iFSpyq4bLopeuATvd+4fOR2AAgbNaabNSMuQ@mail.gmail.com>
 <25116F72-CE7C-46B6-A83A-5D33E9142BF9@holtmann.org>
In-Reply-To: <25116F72-CE7C-46B6-A83A-5D33E9142BF9@holtmann.org>
From:   Archie Pusaka <apusaka@google.com>
Date:   Sat, 5 Dec 2020 00:34:59 +0800
Message-ID: <CAJQfnxG_GDsTTJ1v=Ug0MqEGmTSdeYcOhEf3rQ1hDTmvJS0JrQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] Bluetooth: advmon offload MSFT add rssi support
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Fri, 4 Dec 2020 at 17:51, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Archie,
>
> >>> MSFT needs rssi parameter for monitoring advertisement packet,
> >>> therefore we should supply them from mgmt.
> >>>
> >>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> >>> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> >>> Reviewed-by: Yun-Hao Chung <howardchung@google.com>
> >>
> >> I don=E2=80=99t need any Reviewed-by if they are not catching an obvio=
us user API breakage.
> >>
> >>> ---
> >>>
> >>> include/net/bluetooth/hci_core.h | 9 +++++++++
> >>> include/net/bluetooth/mgmt.h     | 9 +++++++++
> >>> net/bluetooth/mgmt.c             | 8 ++++++++
> >>> 3 files changed, 26 insertions(+)
> >>>
> >>> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth=
/hci_core.h
> >>> index 9873e1c8cd16..42d446417817 100644
> >>> --- a/include/net/bluetooth/hci_core.h
> >>> +++ b/include/net/bluetooth/hci_core.h
> >>> @@ -246,8 +246,17 @@ struct adv_pattern {
> >>>      __u8 value[HCI_MAX_AD_LENGTH];
> >>> };
> >>>
> >>> +struct adv_rssi_thresholds {
> >>> +     __s8 low_threshold;
> >>> +     __s8 high_threshold;
> >>> +     __u16 low_threshold_timeout;
> >>> +     __u16 high_threshold_timeout;
> >>> +     __u8 sampling_period;
> >>> +};
> >>> +
> >>> struct adv_monitor {
> >>>      struct list_head patterns;
> >>> +     struct adv_rssi_thresholds rssi;
> >>>      bool            active;
> >>>      __u16           handle;
> >>> };
> >>> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgm=
t.h
> >>> index d8367850e8cd..dc534837be0e 100644
> >>> --- a/include/net/bluetooth/mgmt.h
> >>> +++ b/include/net/bluetooth/mgmt.h
> >>> @@ -763,9 +763,18 @@ struct mgmt_adv_pattern {
> >>>      __u8 value[31];
> >>> } __packed;
> >>>
> >>> +struct mgmt_adv_rssi_thresholds {
> >>> +     __s8 high_threshold;
> >>> +     __le16 high_threshold_timeout;
> >>> +     __s8 low_threshold;
> >>> +     __le16 low_threshold_timeout;
> >>> +     __u8 sampling_period;
> >>> +} __packed;
> >>> +
> >>> #define MGMT_OP_ADD_ADV_PATTERNS_MONITOR      0x0052
> >>> struct mgmt_cp_add_adv_patterns_monitor {
> >>>      __u8 pattern_count;
> >>> +     struct mgmt_adv_rssi_thresholds rssi;
> >>>      struct mgmt_adv_pattern patterns[];
> >>> } __packed;
> >>
> >> This is something we can not do. It breaks an userspace facing API. Is=
 the mgmt opcode 0x0052 in an already released kernel?
> >
> > Yes, the opcode does exist in an already released kernel.
> >
> > The DBus method which accesses this API is put behind the experimental
> > flag, therefore we expect they are flexible enough to support changes.
> > Previously, we already had a discussion in an email thread with the
> > title "Offload RSSI tracking to controller", and the outcome supports
> > this change.
> >
> > Here is an excerpt of the discussion.
>
> it doesn=E2=80=99t matter. This is fixed API now and so we can not just c=
hange it. The argument above is void. What matters if it is in already rele=
ased kernel.

If that is the case, do you have a suggestion to allow RSSI to be
considered when monitoring advertisement? Would a new MGMT opcode with
these parameters suffice?
#define MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI 0x005?
struct mgmt_cp_add_adv_patterns_monitor {
    __u8 pattern_count;
    struct mgmt_adv_rssi_thresholds rssi;
    struct mgmt_adv_pattern patterns[];
} __packed;

Thanks,
Archie
