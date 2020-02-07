Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E28155CB1
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgBGRRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:17:39 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34235 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgBGRRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:17:39 -0500
Received: by mail-lj1-f193.google.com with SMTP id x7so124424ljc.1
        for <netdev@vger.kernel.org>; Fri, 07 Feb 2020 09:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+3Iqkt4MVXjWZGBV015Jcs9RMmQrhCpmKzo2XOdRy6s=;
        b=zEKd6yGScHa2K0iECeZbhO0XjWI99X5SJjftT/fmqcLVLMycCQJ+7QU2JFU/KEmSym
         xV3/luzzPlLjt/pCbk9ATk8QEahfIkoGWHKpAMAYcSlIyH9PJrvXsFoiJlAnW+9KFkyL
         Hm6k8LS5YXlk43jRVp0OCuV8DWva5V5Egqq92jZ2rC4pYON9frYAaPqc1Xnz9pY64MU0
         H45p0C579NYh/nxhJ1B2VKLVMaBkdtTyqAR21G06y8664XAn8/lBqTBDFOhBGcKBcFW8
         LiadacqrX/7RaTlE8AfMkldn/alfMwoEvcKzbMx2YnZmxsyzrg50ldS7n7RFXP7ZF3HA
         Aa0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+3Iqkt4MVXjWZGBV015Jcs9RMmQrhCpmKzo2XOdRy6s=;
        b=SapqyhX+cliiyAIWn/qDzNO+d5cySE9bSSaSwhaWs/I44m6E8IhDy2LPx4Tcdzv2dp
         MZfS4dL3E1E7cCukLyiWYnB6oNL8NAngUuDpSXWKSu5paPbCv9p5+GRjGAmYtKWrMLnx
         QJ+0KGTtzBSB0fjba+xQ85jnUO7wH5Jlo5HrmRWbEtdx4O60u3jVC+3xaIpzUoV12RQq
         UGLT7PRlYVlpbkxIDr6w1deVOr5vD37NriXigTcMmruYvrhvz8U3/5aMcR/to7vTYy49
         B7+fOCExpu4YYoR90p+B+fLWZewv7jHU1Wx2Ye16nc5Zifpoe440AIvyzPwfa4AOTj3W
         oq+Q==
X-Gm-Message-State: APjAAAWTfhtlzpUDtRcXSE79ql2gDWK5cSYXM7z32veqIoDxVOIjmPsq
        UxanClpZsmRqNQdiVlpYCWHuNpcI6jTUsdd/x9p5vQ==
X-Google-Smtp-Source: APXvYqyzv/j2Eu5b+5c1brAZEyAJvaN5OVlyXbW5amY0PgYq0jfxHZX/4J5eB7zvR7Ut2RgG4CuzIXEW9LjxaMgTG/4=
X-Received: by 2002:a2e:7d0c:: with SMTP id y12mr155054ljc.39.1581095857258;
 Fri, 07 Feb 2020 09:17:37 -0800 (PST)
MIME-Version: 1.0
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
In-Reply-To: <20191211214852.26317-1-christopher.s.hall@intel.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 7 Feb 2020 18:17:26 +0100
Message-ID: <CACRpkdbQ-o0NOLzQK3Jb06wx2u62ik2xv1Q8UNpN_SMmGhgVXg@mail.gmail.com>
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO
 Driver with PHC interface changes to support additional H/W Features
To:     christopher.s.hall@intel.com
Cc:     netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        jacob.e.keller@intel.com,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, sean.v.kelley@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 7:40 AM <christopher.s.hall@intel.com> wrote:

> The TGPIO hardware doesn't implement interrupts. For TGPIO input, the
> output edge-timestamp API is re-used to implement a user-space polling
> interface.

It you modeled it reusing the GPIO subsystem (which I don't know if
you can) you would get access to the gpiochip character device
/dev/gpiochipN and be able to read timestamped events like
the tool in tools/gpio/gpio-event-mon.c does.

That said I am still confused about what this driver does or what the
purpose is.

GPIO pins in or out? Network coming in or going out using PTP?

What is the use case?

Yours,
Linus Walleij
