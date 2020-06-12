Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E511F7ED9
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 00:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgFLWTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 18:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgFLWTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 18:19:16 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6202BC03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 15:19:15 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 9so12785477ljv.5
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 15:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S69gyMNLaOGAiFr7qCBHHiwdlIohIgL0MhzrMbPUZUQ=;
        b=CsOw4DppoW/KZukLdxx5XANt+gyx3ZCgkZNHwyXtURrAp1lCqlx15V5lmbjBu0H78U
         mFwCZ6jbT5V1e1DaMb1cgDFnGJnW0gYnTAMGZXkrCOZybuHa10hRdXKqksVsf8hPtzTn
         LEbL3zFL9ORq9OljOdAg2cp0L3kv14fiCKzjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S69gyMNLaOGAiFr7qCBHHiwdlIohIgL0MhzrMbPUZUQ=;
        b=L/5jWF6OH4dLsK6zh4yNPaxVaSA5u/OiP8XYiMu8pcwdG71pkFL0svl8CzflvbiAyJ
         cB+cikQrZ17KiohbYyzrGpjIvCI6OaZPnHFuLr0DAMqPlWg2uvliTCRFQuV7LeWo5lat
         e7rBuEh2UNEIB0oWFLruvihUHR+EMLePq7N0rp9hkD0SRbXD9PSNt2OIhedbFEASa2cT
         jPyvKygvak0RKMIF5IFZQj9FfDkMbRUuHA+YskUsU5Ph3RKB+LbEjgXNjTXgeJiWF+rr
         pitxKIoTekXOyZf++r59YHDe3TaFMnqXf7xFvlG+MwImOSSHDjcj7obxP414Fg85X5Wk
         gr5A==
X-Gm-Message-State: AOAM5335H1z55Wg/kMfUuyewJi5PfqzdobkxGY6CPpGMnZ1b7ovm4zjU
        VVTY0ZuoNmcls7WOpFhDcEb8xzn+CP3hNCKOohNcrg==
X-Google-Smtp-Source: ABdhPJxos6YOXBcGtM2nVczNOEJuzWaHmxynVDeqAdFrSLAp8j+4lf4tWG0biGINRGjJZGeiHM/Yp2M/OmdbiTYDPIc=
X-Received: by 2002:a2e:2202:: with SMTP id i2mr8031631lji.199.1592000352134;
 Fri, 12 Jun 2020 15:19:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200603160058.v2.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
 <2097432F-C4FA-4166-A221-DAE82B4A0C31@holtmann.org> <CABmPvSHKfS3fCfLzKCLAmf2p_JUYSkRrSfdkePVaHXSrLrXpbA@mail.gmail.com>
 <550BD45A-FE50-48C1-91CB-470D157A728B@holtmann.org>
In-Reply-To: <550BD45A-FE50-48C1-91CB-470D157A728B@holtmann.org>
From:   Miao-chen Chou <mcchou@chromium.org>
Date:   Fri, 12 Jun 2020 15:19:01 -0700
Message-ID: <CABmPvSE=eX_MqAWvgvOo9B6D+5Y0SzedAbRxrKmopvV+DTo5MQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] Bluetooth: Add definitions for advertisement
 monitor features
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Manish Mandlik <mmandlik@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Yoni Shavit <yshavit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

The name in the mgmt-api.txt doc is "Add Advertisement Patterns
Monitor Command", and Luiz changed the name from
MGMT_OP_ADD_ADV_PATTERNS_MONITOR to MGMT_OP_ADD_ADV_MONITOR before
applied. So we either change the doc or change the header file to
match. Based on the outcome I may need to change the name in mgmt.h in
the kernel patch.

Regards,
Miao

On Fri, Jun 12, 2020 at 6:21 AM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Miao-chen,
>
> > Thanks for reviewing. Please see v3 for the update.
> > I am trying to settle down the name of Add Advertisement Pattern
> > Monitor command with Luiz on the other thread. I will post the update
> > here once it is sorted out.
>
> I thought the name was just fine. Especially in the discussed context tha=
t we might add another =E2=80=9CAdd=E2=80=9D command for future vendors, bu=
t keep a single =E2=80=9CRemove=E2=80=9D command.
>
> Regards
>
> Marcel
>
