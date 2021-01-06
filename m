Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6653E2EC047
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 16:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbhAFPTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 10:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbhAFPTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 10:19:20 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C806C06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 07:18:40 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id l200so3733395oig.9
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 07:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OOhTxKDAtHTOXM88DzJ3lZ/B1wn9AGo6BAGCclaNTUw=;
        b=ghchhPau+vXqGNQhaBBcODtcc0ZTb+ezXB5g4yvczqRXFG9Q4N/OZeyCMvu7qazGLL
         dgk58S/LpQo6dz1rG8CtiQxEUNis+pssow/HFlraOFDOI8m805A9zrJnGxYAc1aLQuUv
         gsex69V8m1Uu5qF/BmSFkXW1y6uOqU9E7NnHOW/NarcAGnm97894lCn2IT/DeK+csQ2T
         Gmbig62Odzuc1SbA24s9la604NgcXJ5bLKkup0ZXnqHT6jairTKLEmVRVuEqIlo6dRIK
         VO3Gazsl7KvHeaGMcHEKmOvswbqtU49ooAnJWrqt0VkfEWSvzdq6anVGo1Cxt/rflW2W
         7hhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OOhTxKDAtHTOXM88DzJ3lZ/B1wn9AGo6BAGCclaNTUw=;
        b=XtoeH6bc99iXg4noL+B9xa09ZGK9peR6ZBaDXU9fmakFKY2l/kirAKwCeDGhd43h2z
         A7//HypcNRzdcuYL0N/MLxCZnQj+d/NuuX9HywBwZ1J6zWDzygK1HZs9ptuuxjsWHXWF
         kD4C+YsMhrO72vprX+uDAbV1yaaJXETxfycC5Szloi+mcKFHtTWjK3YPPQRoQe5fqabS
         AupxNxH35bEbPabV7mMHvyLIWbQpYrUKwh7y42Z88+ag5Vs+/P0CIF0Nfkqltnt87u+E
         Qlu9Iu1lCeVouT00bl/Jvw+c0URLkgZ0kuLxYH6QCAAzVa+zE57GwDnK4BfR0BXj2uEM
         rf0g==
X-Gm-Message-State: AOAM533KvBwkKIFBhb4E/RPx2q+8p/IrDarz0r2g96Covc22STreZ1kN
        FYePc1MpsTNVsFMbGUe9JO2skxMIwKJeV2/n2JKBRZV6
X-Google-Smtp-Source: ABdhPJyhFLJpm0c/uwsaQZ6QpvMxCV7Yx/1nq1nIkMDPxuCPLgTzjJVhUiU1U2wMG8IphFikmzWl5FGZAQ3AADELEoM=
X-Received: by 2002:a05:6808:a0c:: with SMTP id n12mr3437244oij.70.1609946320062;
 Wed, 06 Jan 2021 07:18:40 -0800 (PST)
MIME-Version: 1.0
References: <20210106122403.1321180-1-kristian.evensen@gmail.com> <87ft3e3zo1.fsf@miraculix.mork.no>
In-Reply-To: <87ft3e3zo1.fsf@miraculix.mork.no>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Wed, 6 Jan 2021 16:18:29 +0100
Message-ID: <CAKfDRXh2WmT=aAU9CZg=AniW=qOQ4XLHVcYHnjvX8f+CguZBsw@mail.gmail.com>
Subject: Re: [PATCH net-next] qmi_wwan: Increase headroom for QMAP SKBs
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bj=C3=B8rn,

On Wed, Jan 6, 2021 at 3:31 PM Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
> Nice work!

Thanks a lot!

> Just wondering: Will the same problem affect the usbnet allocated skbs
> as well in case of raw-ip? They will obviously be large enough, but the
> reserved headroom probably isn't when we put an IP packet there without
> any L2 header?

You are right, I completely forgot about those SKBs. I will try to
find some time to investigate the non-QMAP performance, if a similar
fix (I guess an skb_reserve after the case-statement is enough) will
have an effect and submit a follow-up patch in case. Thanks for
reminding me, I have switched to only use QMAP :)

BR,
Kristian
