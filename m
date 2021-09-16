Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2075840D445
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 10:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhIPIHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 04:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbhIPIHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 04:07:02 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19300C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 01:05:42 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m3so13311114lfu.2
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 01:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tb8uYbZ6pV4P38MG/Rfr4jmF6F5I+31u1ppYx9QDg2s=;
        b=UklJeATfhXfmNgfF3+ZagVkkOtemcM+y37ELzkzgL6XZvc3myyi8NjDQLtSeRA2yxp
         /52XmwC8TC0PeA1lHELwXp5JRfBU3caB9oVooVcryNtoSwmmeIIdFIqBPDxtoEPgFrNv
         23tSZINHTVfmSzQn4F33BVS2aYmQrf7J4+ZycCBsi22ctj8n+r/yk8OQGKjxF1+3PTeX
         sfeFIdBvr9uacEDbxGm7aXf+LtrCNBB/6+DMwuwMkyml8lCu2ORC2Js78Lp4e1wHLGth
         gs5qPwoM3ld/0nw7Qs79DHC1Qj8dkIMNlBTwKGj4gim4p3OYPE3NZCoZO5YOdbtFgBXy
         v85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tb8uYbZ6pV4P38MG/Rfr4jmF6F5I+31u1ppYx9QDg2s=;
        b=ysEDOgkfQp7RTHsdUlJ5YmTNtgso4VVTMfc196A+J/tx3NKovA5C6Jw/OP7J5TPqkX
         1i3nNGE9eMqTxJq4oqDPah12dG3oQDvu2DjjOQV7MWgIXFmZb4Ry6l0p9V4GYc6gOdiF
         +bN7PpbD/Nkxy+Nu0xYRNGG7fM2fyuvWdtHajRrHEDRevj8PDPbsNR7Bv/xVRhDBGZkh
         ApAtT5rDQJ1XEc+1TvRZb0fpzUAh15h4Zwj9i9/V8wCBHD18ndeLqtFDqt7pCw/+vvUA
         ZIullfxK2+CsvCZVqryjbUDV1kYMlg99EDvX/tzSIxPElVarr9suH4EEEwerPhyVD4ie
         5DpQ==
X-Gm-Message-State: AOAM533rpGAdtsENcEPn844xJsnrTVMoR2wYyh5ClSpxWBMiuaqlG/X+
        qMMSr3Ihqvh5hFgH+YnVLoYm5QpLcychNbsoWIesd+BM3J0=
X-Google-Smtp-Source: ABdhPJy5rCJOp2oH3Iqt8Zh6QH7A5BBPHZFbydcvn7yLQAjJq+U1SqOiGDeg1aQetmUqFT3KzL8xl+Vn/RAJjXFhPqM=
X-Received: by 2002:ac2:561c:: with SMTP id v28mr3248108lfd.457.1631779540457;
 Thu, 16 Sep 2021 01:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210916055045.60032-1-wangxiang@cdjrlc.com> <CACwDmQCyswon-WkVKtG7AUg2uwa0DD_xdvd=VrtK3OtJ_6i09w@mail.gmail.com>
In-Reply-To: <CACwDmQCyswon-WkVKtG7AUg2uwa0DD_xdvd=VrtK3OtJ_6i09w@mail.gmail.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Thu, 16 Sep 2021 17:05:28 +0900
Message-ID: <CACwDmQDmK=rKJ56D_ythcb_TDBMeGJZq+iah-5Jqc8S6C45LbA@mail.gmail.com>
Subject: Re: [PATCH] selftests: nci: use int replace unsigned int
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for missing a few comments about this commit message.
Please change the subject to fix grammatical errors.

On Thu, Sep 16, 2021 at 4:17 PM Bongsu Jeon <bongsu.jeon2@gmail.com> wrote:
>
> On Thu, Sep 16, 2021 at 2:55 PM Xiang wangx <wangxiang@cdjrlc.com> wrote:
> >
> > Should not use unsigned expression compared with zero

Please put a period at the end of the sentence.

> >
> > Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
> > ---
> >  tools/testing/selftests/nci/nci_dev.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
> > index e1bf55dabdf6..162c41e9bcae 100644
> > --- a/tools/testing/selftests/nci/nci_dev.c
> > +++ b/tools/testing/selftests/nci/nci_dev.c
> > @@ -746,7 +746,7 @@ int read_write_nci_cmd(int nfc_sock, int virtual_fd, const __u8 *cmd, __u32 cmd_
> >                        const __u8 *rsp, __u32 rsp_len)
> >  {
> >         char buf[256];
> > -       unsigned int len;
> > +       int len;
> >
> >         send(nfc_sock, &cmd[3], cmd_len - 3, 0);
> >         len = read(virtual_fd, buf, cmd_len);
> > --
> > 2.20.1
> >
>
> Thanks for fixing it.
>
> Reviewed-by: Bongsu Jeon
>
> Best regards,
> Bongsu

Sorry for missing the comment for
