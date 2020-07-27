Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958B722FE22
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgG0Xo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgG0Xo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 19:44:27 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBC6C061794;
        Mon, 27 Jul 2020 16:44:26 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q7so19163568ljm.1;
        Mon, 27 Jul 2020 16:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=moew+kZmDVAfG4fC4F4BUXU70dVOAPvVXz3aPRqWV+c=;
        b=q1ZgQoFOYhEzcRTpKcFgFCwWWkfWsdZN9V77ruy9ePxp4kkFu4iPnUpH6Txm9eLP3K
         Ducw5HyWELvKNTA+jGcHYqDLUPshvYa6BmrnXsro8UdgdiIcrU/WSHxuxBkofSyDwPCK
         TL8TsWCPnDJ18icY0/LWUZd2Sf104gIsH82LtIgNn5usBJrvJ2wX+OTCcL7H5YyRraDW
         TQ2B8A2apljo5nq5fx3VbvAbnjLgeQO4cJCsZlPAWIMOggk2NxTzZQzt4E2XAwnt/gxw
         MRlKi6jvRdfZ1zwqyWJQ6ShIwLJze7Jc7KuP45j9bUeq+E5Vts/jXc4z8RiPWgeDrc06
         tj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=moew+kZmDVAfG4fC4F4BUXU70dVOAPvVXz3aPRqWV+c=;
        b=KQgx2hHuYCOZ+EC/T7tXekyDCgeZPd5ZZT9i8JHqoQzt8KZgtMkC1Pst1V0OgJcUVs
         pChkVdLN2waoeMwfa09oGBjZIjAgA7z+C0Fe8e11FzNCVvKchkTyyQ5Lzfl1Zutx1YzW
         CSlYBY/eeUXEkZoorBsirx8VgUGUvkb+BGbeAFQ11FKFeH8guTV3s3YOrHIW9fvt0sdd
         HwTGeBSkdpPWfa9FHm+VcwKYtNTJz9X12D9jwqdFxhlchJQX7faQ8fhw8Fo62hLpcPU2
         A1xII6T3vu6N5rOfQ/sbvVXpmgLStTYR3NyCIJcrZ/9mbO16x/ZgvahpPZ6YHZ/RBA0X
         MCQA==
X-Gm-Message-State: AOAM5310mAtFqSbcEhjqLba5PXAYqTw69MXLQf/n5PjI8Y1cwMEU2rR6
        er+9aXk9C2jyANSr2ShPHCKvpDtO5Zpid59Kl86Iyawxrgw=
X-Google-Smtp-Source: ABdhPJxqt7yjHQHbPupJG9vvFvZjRsehmeM8o56Au9FRmksB3Q9itPwQ3rIbmzHlg9L/qPzCtL3kCB6IQ7KGZUHAu6M=
X-Received: by 2002:a2e:8059:: with SMTP id p25mr5366425ljg.219.1595893464673;
 Mon, 27 Jul 2020 16:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200727194415.GA1275@embeddedor> <70ed74d65b5909615c7a9430f3479695465d3b1d.camel@perches.com>
In-Reply-To: <70ed74d65b5909615c7a9430f3479695465d3b1d.camel@perches.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 28 Jul 2020 09:44:13 +1000
Message-ID: <CAGRGNgW4VB1F9TdHf1Kg6WQtgHyH-ZKAnZ0kU5eKQaqUWHwbqg@mail.gmail.com>
Subject: Re: [PATCH][next] ath11k: Use fallthrough pseudo-keyword
To:     Joe Perches <joe@perches.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

On Tue, Jul 28, 2020 at 5:48 AM Joe Perches <joe@perches.com> wrote:
>
> On Mon, 2020-07-27 at 14:44 -0500, Gustavo A. R. Silva wrote:
> > Replace the existing /* fall through */ comments and its variants with
> > the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> > fall-through markings when it is the case.
> []
> > diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
> []
> > @@ -159,7 +159,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
> >                       break;
> >               }
> >               /* follow through when ring_num >= 3 */
> > -             /* fall through */
> > +             fallthrough;
>
> Likely the /* follow through ... */ comment can be deleted too

If the "when ring_num >= 3" comment is needed, how should this get
formatted? Maybe something like:

fallthrough; /* when ring_num >= 3 */

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
