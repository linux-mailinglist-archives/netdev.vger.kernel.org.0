Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434493A4C16
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 03:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhFLBVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 21:21:46 -0400
Received: from mail-oi1-f178.google.com ([209.85.167.178]:39768 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhFLBVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 21:21:44 -0400
Received: by mail-oi1-f178.google.com with SMTP id m137so7694541oig.6;
        Fri, 11 Jun 2021 18:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=moiUVsFkDQas4Wlpd6FFZm9ZzBRCz9cqXJmOseQtnPQ=;
        b=W3t7vXy/ZUHT7Uqaa+cS5uDyHk3DCmoCLbZ0r6FhzCTnzesGoCH3kWq3V/+4H7d5Tx
         P//U2t5A3zSD5lvZHgwjDIZ++d14VW6UOPuiChFNDlIbzJkMKsaEP4GcQNxPcYPXC5CA
         O/Sl2MNkwWRSqHk8PUFcgUH1a+EgZe132KXSHWfK+p5IXddNobRbJrX+1Vb2BQGNbtUn
         2nJEZkejymfTSo/pxi2NnRbiSnKCQbMFxb1vnJZeN/fxqvJqcmR8+/sLaXSvuZV28lPh
         EQdmU+sRed0Rxmp4DJ+mWVMCutUg7w+BbPvws78C0rPJWSKVDV0uLc5CJRkc/bsbTZ0w
         0CmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=moiUVsFkDQas4Wlpd6FFZm9ZzBRCz9cqXJmOseQtnPQ=;
        b=LeamyxNXcs1gwRAI1HMMOActw7hYmifAnu6kMIPzvbktlF/8SCYRipTJMeFpULfT0M
         ws/1wfkxqe7fOYnIQkXnbFuAxLjLzX8Ql3OfVUdlMyHiGtjHeD8Pp6JyWSFwdH75d6ay
         /q37hX9bG/Wn3yfLtpixz/cQ69amGb2A15jw4xuo9XrWKqwCJi+K7TJhy7O4rllGDwn5
         TUmFjRnWWn7L2qf3X4A1M63XcbkDrUa60+KiqR+D6r8zXwXBJO6jwQ+1hfXtgPvpIWLi
         BpQoHxZdZftbml0BKB1Tlt/V8jRQgvnTD5KwGHYUY0VlXJeCgiOpp+RYfsD7kyvlGTv4
         Bk5g==
X-Gm-Message-State: AOAM532rkGCjhyNoDVkOpQD9ZnghbGJeNNYCk9nduNOxUtnu4NmfdxqX
        FEnJ+QyfiXR4khO0fXbxbouinE6k2goqGCTm2LJbj63DCps=
X-Google-Smtp-Source: ABdhPJxAX0x8JGmdI7bh4C3+vFEpipR+j78B6kNE6q/Wi7hJF0nMO3gKf8JMgQI2BtC1RLEVl1nj7iCNIDhSDVbxtDQ=
X-Received: by 2002:aca:4dc3:: with SMTP id a186mr4769782oib.63.1623460725357;
 Fri, 11 Jun 2021 18:18:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170449.28031-1-m.chetan.kumar@intel.com> <20210608170449.28031-17-m.chetan.kumar@intel.com>
In-Reply-To: <20210608170449.28031-17-m.chetan.kumar@intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 12 Jun 2021 04:18:36 +0300
Message-ID: <CAHNKnsSgcf5PWvPhUJuXibamUR6oZt2xLLzNLwQP8OM1e0A1Bg@mail.gmail.com>
Subject: Re: [PATCH V4 16/16] net: iosm: infrastructure
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Chetan,

On Tue, Jun 8, 2021 at 8:09 PM M Chetan Kumar <m.chetan.kumar@intel.com> wrote:

[skipped]

> +/dev/wwan0p3MBIM character device
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +The driver exposes an MBIM interface to the MBIM function by implementing
> +MBIM WWAN Port. The userspace end of the control channel pipe is a
> +/dev/wwan0p3MBIM character device. Application shall use this interface for
> +MBIM protocol communication.

A one nitpick. Since f458709ff40b ("net: wwan: core: make port names
more user-friendly") the first device MBIM control port will be
/dev/wwan0mbim0. If you plan to send a next version, please update the
port name in the documentation.

-- 
Sergey
