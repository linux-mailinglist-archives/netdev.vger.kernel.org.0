Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2C223E142
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgHFSm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbgHFSWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 14:22:52 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75497C061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 11:22:01 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id p25so5354634qkp.2
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 11:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PnlPaEVQabtCYLzfM7Gwzv0+0Io8j+yuMCtVLt0XZHk=;
        b=iUswPhk19VbSa3HIjPOgYoZPLxCujksUjgbdAAxVSks/52X5jAulynowxzQbwH/njP
         PYWWosZOLrAu3ZL6WLhi4IkmkR+JfFiYz3apRYqtUySxZ7u9qw4t/+AFQAatMSqc34/7
         5BZockQ92O7eo7C7xGFcjJ4BQvVJY8ooAwwKiR3sF6PtStYuk1ydPNerzz6qC/zqGeZV
         d7eMqWqD+4wzuA112oKwcZnkd+GSdjQkWuHkBpNd6pX508w1NzSNvYNQefMrD2nbO7jN
         Uv5Ky5/FhJbadubHmvzxQJztZCVKMZ3tmzCuIvYJ1hf0m13un6ywDUSvLq75Mw8E83Py
         Gc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PnlPaEVQabtCYLzfM7Gwzv0+0Io8j+yuMCtVLt0XZHk=;
        b=phPLMfc5i6T6mW5mH8TcS1a2UXfUtydKTqMCLrtZtYTEL1aXqFpJFL92zb2jOiKOkS
         DJTsX09LadqNPtHsUDoRBWiAba1QnZpfs3UuzPvcUaMGyHaFKYMv0J3iQLD7M+WFGuM6
         78Iqrysv4VV0xa+5vQV5i7dGd4ZdWNfnM0/dPF7DUTj9ZWp1km/B0bVxEMkPCjCp/Ows
         ZkQnCNtPorlc3y3PClgOdY5+cSlNatNpILpBkLS7NgmXtou7jQB0y0zEx6khcepqv+el
         Z8G3UceGC/xcoSSndDY5WJjncU3EZMYDyrMFHMvnyEb6jS78INslO+YbVGt/3Qv8OBgl
         EvRQ==
X-Gm-Message-State: AOAM532xkwXEpNkqlX9m4+UQSlrq9cqLE8yxzcYvTfI+U+/AgU5wL632
        2WY5dJi5mfx7lGVjkojdWUh5XibaGqXwxtO8BmU=
X-Google-Smtp-Source: ABdhPJzi3pHmZ420cYp9rnZoka4Yn9meqR7FmXT0naHhx3XBqBAOsXxU8wK/OVWm43Ev83eyh9tPvauWxf7u1YgjEig=
X-Received: by 2002:a37:b145:: with SMTP id a66mr9786679qkf.338.1596738119902;
 Thu, 06 Aug 2020 11:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200806145936.29169-1-popadrian1996@gmail.com> <20200806180759.GD2005851@lunn.ch>
In-Reply-To: <20200806180759.GD2005851@lunn.ch>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Thu, 6 Aug 2020 19:21:21 +0300
Message-ID: <CAL_jBfSZDGbKiKCjcdQ8uaHvtxxb0P4Rktw9TutWEGCfscJ=EQ@mail.gmail.com>
Subject: Re: [PATCH ethtool v2] Add QSFP-DD support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Paul Schmidt <paschmidt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew!

Should I resubmit v3 after I delete the code that has to do with page
0x10 and 0x11?

Adrian

On Thu, 6 Aug 2020 at 21:08, Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Adrian
>
> > +static void
> > +qsfp_dd_parse_diagnostics(const __u8 *id, struct qsfp_dd_diags *const sd)
> > +{
> > +     __u16 rx_power_offset;
> > +     __u16 tx_power_offset;
> > +     __u16 tx_bias_offset;
> > +     __u16 temp_offset;
> > +     __u16 volt_offset;
> > +     int i;
> > +
> > +     for (i = 0; i < QSFP_DD_MAX_CHANNELS; ++i) {
> > +             /*
> > +              * Add Tx/Rx output/input optical power relevant information.
> > +              * To access the info for the ith lane, we have to skip i * 2
> > +              * bytes starting from the offset of the first lane for that
> > +              * specific channel property.
> > +              */
> > +             tx_bias_offset = QSFP_DD_TX_BIAS_START_OFFSET + (i << 1);
> > +             rx_power_offset = QSFP_DD_RX_PWR_START_OFFSET + (i << 1);
> > +             tx_power_offset = QSFP_DD_TX_PWR_START_OFFSET + (i << 1);
>
> > +/*-----------------------------------------------------------------------
> > + * Upper Memory Page 0x10: contains dynamic control bytes.
> > + * RealOffset = 3 * 0x80 + LocalOffset
> > + */
> > +#define PAG10H_OFFSET                                (0x03 * 0x80)
> > +
> > +/*-----------------------------------------------------------------------
> > + * Upper Memory Page 0x11: contains lane dynamic status bytes.
> > + * RealOffset = 4 * 0x80 + LocalOffset
> > + */
> > +#define PAG11H_OFFSET                                (0x04 * 0x80)
> > +#define QSFP_DD_TX_PWR_START_OFFSET          (PAG11H_OFFSET + 0x9A)
> > +#define QSFP_DD_TX_BIAS_START_OFFSET         (PAG11H_OFFSET + 0xAA)
> > +#define QSFP_DD_RX_PWR_START_OFFSET          (PAG11H_OFFSET + 0xBA)
> > +
> > +/* HA = High Alarm; LA = Low Alarm
> > + * HW = High Warning; LW = Low Warning
> > + */
> > +#define QSFP_DD_TX_HA_OFFSET                 (PAG11H_OFFSET + 0x8B)
> > +#define QSFP_DD_TX_LA_OFFSET                 (PAG11H_OFFSET + 0x8C)
> > +#define QSFP_DD_TX_HW_OFFSET                 (PAG11H_OFFSET + 0x8D)
> > +#define QSFP_DD_TX_LW_OFFSET                 (PAG11H_OFFSET + 0x8E)
> > +
> > +#define QSFP_DD_RX_HA_OFFSET                 (PAG11H_OFFSET + 0x95)
> > +#define QSFP_DD_RX_LA_OFFSET                 (PAG11H_OFFSET + 0x96)
> > +#define QSFP_DD_RX_HW_OFFSET                 (PAG11H_OFFSET + 0x97)
> > +#define QSFP_DD_RX_LW_OFFSET                 (PAG11H_OFFSET + 0x98)
>
> You still have code which implies page 0x10 and 0x11 follow directly
> after page 2. This is something i would like to avoid until we have a
> driver which really does export these pages. Please could you remove
> all this code.
>
> Thanks
>         Andrew
