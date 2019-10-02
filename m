Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664ADC8D1E
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfJBPnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:43:18 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41753 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfJBPnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:43:17 -0400
Received: by mail-ot1-f66.google.com with SMTP id g13so15057928otp.8;
        Wed, 02 Oct 2019 08:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OGFNe2HzuYdA+Ntxb0smhm55h1bjmES+Gg6K1WA4cN4=;
        b=raXbWyquX8Hu3af70VX0sRqu+Rp/zT806IMzbVnHps5oub1ys+I89CrLXcTKod3XNB
         FJSlAEXz2GGc7E63ha/lzstR51SSpvovNrpSNgWuMAXaWlYRk32NfVv1EegLlwvG11ss
         kXM0WMzi+chVMZUXMyhLIe7cTT/y3LAugOTfvseAoXuye5/UiqsmRDt9Imn1NMwvHb8W
         fFd3/tvKIoKXKrnNW8F8fO9GTyIHcW4DVUDnnyEgaKXUuNVGbi8ks5MruCWPd1QJxdAy
         4B8HEi6bSJe1JRIrbabZnCmApJy7+6tTk7N0js+Wgjiyw/GjkIbUHpnUd9t3s+OwtE7f
         9png==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OGFNe2HzuYdA+Ntxb0smhm55h1bjmES+Gg6K1WA4cN4=;
        b=NgQqWCvhQwWwdmmmlIoLrUP0xc6TSeCF67izueNk0IiMWFEQQMXiltWhkWrFFDP3UL
         IqIya/cZOa2IfvRydU9ypMgwJP/QQofuSV+vV+4SONSNgAaEkCGOtF4TrZ/vVxwVUWmu
         BuSUVbxkZtCHgf6tJohbWix8zVUVBoxwrNI9B2zwNH1Lfa7h1H4pmNiZNn3s1u/OR766
         RIp3sTVWQvUeMSI5nKy7huCb9RYNzR59ryg4QhBH6JOaeFyrG1NJHVO4O07QjpHd2rf9
         lZ3hMHHBdM1nbuudNQV6yFE/TL7voP7xpDsoDAThkE2NJVrOsZ90dHAUCXOs64YRGlnV
         trAg==
X-Gm-Message-State: APjAAAWicqrE/x5kAT5rv+p6JUml/9HN4cY7fq1soeHG3OpmOboUFpfM
        AS6zIVUgdihmpRVZcA9BDN7w56VHLKpAzm0LTnk=
X-Google-Smtp-Source: APXvYqz2bTRZ1lk+yBO4Isg8mfboIRlGpW594gsCbbQJOH3h7RjW0aMGSK3cRnkBb23XrjtG+F8g1zY4fQZepUSwy9Y=
X-Received: by 2002:a05:6830:1645:: with SMTP id h5mr3137591otr.116.1570030996925;
 Wed, 02 Oct 2019 08:43:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190918183552.28959-1-TheSven73@gmail.com> <20190918183552.28959-4-TheSven73@gmail.com>
 <20190930140621.GB2280096@kroah.com> <CAGngYiXWF-qwTiC95oUQobYRwuruZ6Uu7USwPRqhhyw-mogv7w@mail.gmail.com>
 <20191002152358.GA1748000@kroah.com>
In-Reply-To: <20191002152358.GA1748000@kroah.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 2 Oct 2019 11:43:05 -0400
Message-ID: <CAGngYiXR733NhnCE87mvxNo2xXzLLEJtvbn98DUTrKMJexvyKg@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] staging: fieldbus core: add support for device configuration
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Enrico Weigelt <lkml@metux.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        Frank Iwanitz <friw@hms-networks.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 11:24 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> If the code works with some subset now, then why not work to get this
> cleaned up properly and out of staging and then add new features like
> this type of configuration system afterward?
>
> Why is this a requirement to add while the code is in staging?

I believe we put this code in staging/ not because there were issues
with the codebase itself. But rather because the subsystem needs
more industry interest and developer sign-offs. The TODO reflects that.

And that will be very hard to do without some form of a config interface,
which this patchset adds.

Perhaps the time isn't ripe for this subsystem yet, although I cannot
believe that we are the only ones running Linux on fieldbus 'gadgets'.
