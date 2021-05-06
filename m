Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1644737515E
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 11:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhEFJSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 05:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbhEFJSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 05:18:10 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19C0C06174A
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 02:17:12 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id p12so4265824pgj.10
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 02:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fQw5jthS2ZQ6I6BWVowsPzS49MCUe1xz1/T90GLuSTo=;
        b=dRqWEAePiQJZjDnPObObwpCKO27OTwPngxBu2WVzWnfoAgWTXkfcsnn6EXtpqZ3ive
         Ku2dNvYsK2L/szsfT0Y5nUBXmjXrRO6bU8cZb9gEdRozjkPezgE6tSm+cOhvev9jk6El
         yKrYvkWMBBjkofCbx+6mLmQSSRKw7hPD6VagRhc/JWMMahENxUxYhQSAI0KurR6ynn/1
         kvoLuXbnrnlq6b0bFh3LJexyiqQM5Oced+yCuhqR5Tnosw+ucU6BJwBCo7uqFr6XXKup
         HSkV2O2NUXRiI1gQNfxTGpP2G8+QEbZwTIsbYzGBMna926aPnJLq/xDcZK+UlpIrjBmT
         hEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fQw5jthS2ZQ6I6BWVowsPzS49MCUe1xz1/T90GLuSTo=;
        b=oRy79YV3cMqc0LzFk2sI4aH5mFASZd208FlqhTcWFtAWe4+eclLRFEdhF8FxK+rd4I
         zIl/t6zxJZ90mRt1NaVpiVfZe+/rXX3L3qSujcRa5fTnTbJotL/RraK/FoqN3R06wTT3
         C0FntQfvo5XhHlqILSwUiI0DXGBR3aXcAQ8bV60ijDbwa3dmL6I4uudAB0HmK1FW0TGb
         57343HRyaR1Sd1Xy3jPYilUEVxWL6x1nVBrU7HSbZmfAVn7nyCgSut/AD1cipiZFyORv
         7+E3H2rSrEFe4NyjLOZ3oX12QmBs0uQiS0XS+XyTTRdqvcdRsagFMC+VHLAjwOIMnvx6
         wmlg==
X-Gm-Message-State: AOAM531oFiqiSEY08wz8guNfdUBNk9DFbY06Q2W97KOqNcoInS/tynDE
        BIfF7Qeg1vwqE6tmAhgF6shTza/2Py2biR06bZXhEA==
X-Google-Smtp-Source: ABdhPJyZQ+x5V0C/Io7xe62f9KkHNwUDn8j1cEHE2C45NP7RgLLL5gxs+BNfjzf7lR2tYYuF8hFAHVqA4X596lHMoIw=
X-Received: by 2002:a63:5b20:: with SMTP id p32mr3233144pgb.173.1620292632214;
 Thu, 06 May 2021 02:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210420161310.16189-1-m.chetan.kumar@intel.com> <20210420161310.16189-8-m.chetan.kumar@intel.com>
In-Reply-To: <20210420161310.16189-8-m.chetan.kumar@intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 6 May 2021 11:25:45 +0200
Message-ID: <CAMZdPi8h7ubOvUBaF2wh87UBwzJz3GpQ3gZwSXy0miV7Aw2NXw@mail.gmail.com>
Subject: Re: [PATCH V2 07/16] net: iosm: mbim control device
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chetan,

On Tue, 20 Apr 2021 at 18:14, M Chetan Kumar <m.chetan.kumar@intel.com> wrote:
>
> Implements a char device for MBIM protocol communication &
> provides a simple IOCTL for max transfer buffer size
> configuration.
>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>

Now that the initial wwan framework support landed, could you migrate
to it for creating the MBIM 'WWAN port' instead of creating yet
another char driver? I see you introduced an IOCTL for packet size, I
see no objection to add that in the wwan core.

Regards,
Loic
