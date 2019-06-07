Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A499038329
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 05:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfFGDcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 23:32:47 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42066 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFGDcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 23:32:46 -0400
Received: by mail-pg1-f195.google.com with SMTP id e6so385140pgd.9;
        Thu, 06 Jun 2019 20:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Uid5j8Xhkx1Up2P/L/dzyxeFX18f8LJ+y3dsMZAvABE=;
        b=VWf1N2/7qRnL6GliVgGLRsKMZY9lK9c3sG2D8m+7hzOSdzhoDoPUasj/LxVOTU09kQ
         DLF0evu6aStur0COx3yoDrA2WSD4xRsoXdQRo9ae5HX101EPQ1+Upw+O1To53tWWhqNG
         k9fIN+nu+0pLNT0vG9wQESwVyyz+NowLqzieud6gInVawhCG4/iW61zB5aeiEHaMT+RW
         pzp4Z4c4nxjDgBPM398kj9l9REJzBZeYjOxFeht5R80RrJ35BXJ501LXN4FQ2EDx6m70
         vMAhI05FHpaF+eu9m3oZwKl1Yyic9xCYy/nC+OcvgWF1yGHjxUVCvxhvZIq3+RJD7+d3
         RakQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Uid5j8Xhkx1Up2P/L/dzyxeFX18f8LJ+y3dsMZAvABE=;
        b=CkKXaI73mY1YTPoUVEj2yG62JgzoOVDOSYflRpII39vLKWS4g93t8I6c6mrksg9m99
         GZfhXAUUYmLOqjiWJvLvvhzqTtffWdNICJyIWIzTSSaUaMt8XoRE4kN1TVU8OZS7uqtd
         3SH0cLtqOZR0bMS8TsRn+epwprsVG2o+3glmkSTMiR8t4FYY1LlMSTulCj2es6G0sbp6
         2VJZlEa8A5hl7YExk8j9LiLyC59ttImwAwGfOSpsgA6KZVjWYu4BULYUmWhzgrs7/sbH
         Q5Sv9zVqCeXXWvbQoWgeuoepbmfpjP0EivJc5Pl9EDhmqpOKrQQ/p5NG5OpHbnPiYcb1
         4QiA==
X-Gm-Message-State: APjAAAX80y130jlbPnMNOncV8kjxziEVvPJR+HpzKcMOzOUzXor/gOSW
        9XOzseD8vfY7+5UEP/iTbUg=
X-Google-Smtp-Source: APXvYqxj5lrNGYMpJ4UD+bpaXMalgKDNsmj3X7TucZ0MPOjcr90U/gLYZ8CU3k9AjNirwQH9GAasSQ==
X-Received: by 2002:a17:90a:ac0e:: with SMTP id o14mr3244614pjq.142.1559878366329;
        Thu, 06 Jun 2019 20:32:46 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id p6sm472522pjp.7.2019.06.06.20.32.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 20:32:45 -0700 (PDT)
Date:   Thu, 6 Jun 2019 20:32:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA driver
Message-ID: <20190607033242.expuqccmzhxdkwzq@localhost>
References: <20190604170756.14338-1-olteanv@gmail.com>
 <20190604.202258.1443410652869724565.davem@davemloft.net>
 <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
 <CA+h21hrJYm4GLn+LpJ623_dpgxE2z-k3xTMD=z1QQ9WqXg7zrQ@mail.gmail.com>
 <20190605174547.b4rwbfrzjqzujxno@localhost>
 <CA+h21hqdmu3+YQVMXyvckrUjXW7mstjG1MDafWGy4qFHB9zdtg@mail.gmail.com>
 <20190606031135.6lyydjb6hqfeuzt3@localhost>
 <CA+h21hosUmUu98QdzKTJPUd2PEwa+sUg1SNY1ti95kD6kOqE6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hosUmUu98QdzKTJPUd2PEwa+sUg1SNY1ti95kD6kOqE6A@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 04:40:19PM +0300, Vladimir Oltean wrote:
> Plain and simply because it doesn't work very well.
> Even phc2sys from the system clock to the hardware (no timestamps
> involved) has trouble staying put (under 1000 ns offset).
> And using the hardware-corrected timestamps triggers a lot of clockchecks.

It sounds like a bug in reading or adjusting the HW clock.  Is the HW
clock stable when you don't adjust its frequency?

Thanks,
Richard



