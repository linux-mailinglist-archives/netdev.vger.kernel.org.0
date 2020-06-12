Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550C21F73D6
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 08:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgFLGTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 02:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgFLGTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 02:19:20 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90335C08C5C2
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 23:19:19 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id dp10so3883676qvb.10
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 23:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NNGXv0lMsturnLAkB0xgOjhgswIgwH4CKsAWmGD9RnQ=;
        b=J1NO+FDS+jq8lTC9vJgDCCacRjwtmC1y1HcvYjSjs+teQ4GlLEmQcCRQUWKyqhqSrj
         BzDOXDCIji1ffezf77yz1B7/zFdMaENGO+eTMz4m/h7YG5qxYBsvyfDdU8rlGPBiHiSl
         QdY09wyaQLXNPh8u5W0CzK85KsSQ3+XkP0Xt0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NNGXv0lMsturnLAkB0xgOjhgswIgwH4CKsAWmGD9RnQ=;
        b=TENYZ2vZnxIIRUfUdX11Tiryl/nHbFac1PU4f//gI09BZAV0xFeIzuaQ/6VHT4+HYg
         8/q5AubEyXyjcQh5eaHdu5cxKXRMnzskZ38y0XD1rhmXYwIKuODEvaybfXhx2qkSH/gk
         btN/S0Cw9dUTTL3tRA/Q71+7OTd1SN9Q9xJBAFYF4pCaA+0hQ6f7l2gnGbmeH6b2DKk9
         7rVWPOSgnMt7ZfweONQQ3mEgtNsxi7+XViokHzZQqorNclIN7q4supviaXChWRMLFh/I
         05yU5G0Y7gzFzhCAFSXvS3REk413GbjHYrSTM1sGw4ynDCtvtRIgNG4AppeW7XR2AkPX
         RCiw==
X-Gm-Message-State: AOAM531SGyYtNspNhtPvSHxi4O+w+kD0RXEZntJrxXB/ECjQhp3XpMjp
        yleiAWFiZjm1SHjPQWAmOiy9nzZkuC3akk3aJor/FQ==
X-Google-Smtp-Source: ABdhPJxxLaXgILeWrAaRqOZ14vcxJ+konJwA4Urf9BTKUSLx6/pZ8w/DgK38RYaXnOjoSRt7jil1f7cCylhP6bPIZRA=
X-Received: by 2002:a0c:d442:: with SMTP id r2mr10699310qvh.59.1591942758671;
 Thu, 11 Jun 2020 23:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200603160058.v2.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
 <2097432F-C4FA-4166-A221-DAE82B4A0C31@holtmann.org>
In-Reply-To: <2097432F-C4FA-4166-A221-DAE82B4A0C31@holtmann.org>
From:   Miao-chen Chou <mcchou@chromium.org>
Date:   Thu, 11 Jun 2020 23:19:07 -0700
Message-ID: <CABmPvSHKfS3fCfLzKCLAmf2p_JUYSkRrSfdkePVaHXSrLrXpbA@mail.gmail.com>
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

Thanks for reviewing. Please see v3 for the update.
I am trying to settle down the name of Add Advertisement Pattern
Monitor command with Luiz on the other thread. I will post the update
here once it is sorted out.

Regards,
Miao

On Wed, Jun 10, 2020 at 10:57 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Miao-chen,
>
> > This adds support for Advertisement Monitor API. Here are the commands
> > and events added.
> > - Read Advertisement Monitor Feature command
> > - Add Advertisement Pattern Monitor command
> > - Remove Advertisement Monitor command
> > - Advertisement Monitor Added event
> > - Advertisement Monitor Removed event
> >
> > Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> > ---
> >
> > Changes in v2: None
> >
> > include/net/bluetooth/mgmt.h | 49 ++++++++++++++++++++++++++++++++++++
> > 1 file changed, 49 insertions(+)
>
> all 7 patches look good to me. I just need them be adjusted for the actual assigned command and event opcodes.
>
> Regards
>
> Marcel
>
