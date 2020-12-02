Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D532CB582
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 08:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgLBHDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 02:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbgLBHDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 02:03:54 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F49C0613D4;
        Tue,  1 Dec 2020 23:03:13 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id e25so4170446wme.0;
        Tue, 01 Dec 2020 23:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bDEuBbvyO4m/aOrUkaJX+zPA0wyOJV04lKgxRyULzKk=;
        b=A6BUjlpprQbeCgO38tGePMxU/Z1DUnKDpLCzWSzeQ0RGCJdGE/3r5PvCnFphFaQ2xh
         tDCvBR746a2dKj2EAxnxREr3JcK8TxI5yNCyl3OZCh55A1FIF0uFzelAP12Ac9/kvJlE
         /L6GyTDevzH1wgU556itNQNzn4aVf3MKDRQlXz9B3JO2OETcFPNRd6HtB8R6XJqz77Ju
         fcFRTXHncSbhfYQWAXvw1F0iGHVLc0Ya6SE8zLDusdLVJ1yqL6mUVLQ2W67jD/RNNsX+
         NIddsi04HxMAhXdADHvRU8MaPlTY/u+y3KD6Bkvj1PyP48dKYl2cM1ba2EBVeU0PubKG
         RrVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bDEuBbvyO4m/aOrUkaJX+zPA0wyOJV04lKgxRyULzKk=;
        b=rjBo2L26ZbyKwlNsEFTMnP39H94BQLFovj6bwKLfdA50hBJ6Bix7lx0WdN/6EzvL4U
         XaAYkN5lArXOm73CYEKn4EggDFhT+sZYtO2HDwS3nkHefnj7opSiqwRgKRE3zFbQuZbL
         rWllbMkBKeofC4/dh1yDLvH8K4JSUC32Y/LAguW83FEv3PEMps2GM/S5QmLM3TctrfJO
         cpKzv5rSmXX1X0CMtCXeNAC7iu1Hc3BMDryhWYMwmyzAIdWyzAGz8EWomZKXf5b1dSLh
         X1rZxpTALItyFF7Gdd8gG+Kq/03dJYj27NLkNqkbDNHiaYjE4FWFHd/CUz0xSFdiQWpd
         Z6vg==
X-Gm-Message-State: AOAM530rU+T3TpGr2GkH+9nYeLzibndI2AnwIQSnFnBMDx+nx3KjFLve
        +IIwpK0SrLMjfFselQHkLtpdrnEfYopLSoMnABY=
X-Google-Smtp-Source: ABdhPJzR5Hixme4SzNzsQ2hgFB6L6n6Q9R6GuEyMpXhKkYTMG1qgDfVOBUYf8cxNABWF0W6J/c1yoZEjHvlkG/FP5jU=
X-Received: by 2002:a05:600c:21ce:: with SMTP id x14mr1446848wmj.27.1606892592410;
 Tue, 01 Dec 2020 23:03:12 -0800 (PST)
MIME-Version: 1.0
References: <X8c6vpapJDYI2eWI@mwanda>
In-Reply-To: <X8c6vpapJDYI2eWI@mwanda>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 2 Dec 2020 12:33:00 +0530
Message-ID: <CA+sq2Ceo3z1KAuOfZYsmRMHw4dHcnrRLtkRmALNHvj3=tRJKtA@mail.gmail.com>
Subject: Re: [PATCH net-next] octeontx2-af: debugfs: delete dead code
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 12:28 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> These debugfs never return NULL so all this code will never be run.
>
> In the normal case, (and in this case particularly), the debugfs
> functions are not supposed to be checked for errors so all this error
> checking code can be safely deleted.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Thanks for the changes.
