Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639BEB5A28
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 05:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfIRDmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 23:42:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35898 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbfIRDmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 23:42:39 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so3456252pfr.3;
        Tue, 17 Sep 2019 20:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GbKlbpTFe+CN6SKqbKlc9mQcgb7sBfZRnKgAQN3AI1c=;
        b=BXmh30TEdIEExjRnV42l+vfzdAPAD/riGCZ7IGy53Z0oadUQcEpZgqiw024GpCiSq8
         NcizBJivS4lGx4OFb7vZPgLvHK8tM/KgFGWseCGnc0Jq7rALDywN/Inxh+NR32tUJKby
         7+cbX14kBGQ/C+JTIUDbxcnQeYbv9b7du5xjArn7Fz9gc52iX0hXQXy91a7hKR6vhP4i
         eCQTiL+hpsslW1kg5MoLRgQu61dcQnBf/X0i+dg7irCtegc7acCSboWsHkp4rNTnpyx3
         lG9ZuPq4a8uvsV+nEI8o2dvsvrGxw67x10BLJLSJCEbnqe9/zZ7HKZnVXiKCaAnNrCJc
         n/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GbKlbpTFe+CN6SKqbKlc9mQcgb7sBfZRnKgAQN3AI1c=;
        b=IjVFzYBBlE2VIZ32C2wxPLjRQc1hBoExXRtDUuuda29moJ44rmFn+Fm6OlDV3JSuMf
         S+siG5xEBTXEd1+TItfktoW7jfmrLIiHWin3yiq0Lsh/LyIXrA86dhOzCXPbS36hAORv
         yUhgnIj95jxsBLtErl2mYzJq1e0XGD3+jleSu3O4r1QKxYIdqiski8Li5lfjoRmH40VM
         Se4b627V6r5M6cPPk1q71N8Q5v7nFrXSDqmpRptUaQeP0OItijZ1PjWaP75RhihQnEfL
         6mjpyYj9Yk6I4eO+3P7JTFCu/FHGx4PC3Y9uYIh+GuWvvtuk1mbkgZ5ZgRBiS1PrXpNN
         pnJA==
X-Gm-Message-State: APjAAAX4jWAAenDJEZSNqV6iyBRcpaJ0kEPJs0iafV+Y0ZS/eS5OdrCa
        /ZMv/JV6DNUxfjGApuYOjWU=
X-Google-Smtp-Source: APXvYqy08BeDDvIm2kVHdHR9PG1EFVLBSMzaosfyRmNnZq/cEClwPDdxo8DDn68lUaEDauBJgWoLBw==
X-Received: by 2002:a62:1402:: with SMTP id 2mr1920506pfu.226.1568778159141;
        Tue, 17 Sep 2019 20:42:39 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id n21sm652294pjo.21.2019.09.17.20.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 20:42:38 -0700 (PDT)
Date:   Tue, 17 Sep 2019 20:42:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        Mark.Rutland@arm.com, Will.Deacon@arm.com, suzuki.poulose@arm.com,
        linux-kernel@vger.kernel.org, Steve.Capper@arm.com,
        Kaly.Xin@arm.com, justin.he@arm.com, nd@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/6] Timer: expose monotonic clock and counter value
Message-ID: <20190918034235.GA1469@localhost>
References: <20190917112430.45680-1-jianyong.wu@arm.com>
 <20190917112430.45680-4-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917112430.45680-4-jianyong.wu@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 07:24:27AM -0400, Jianyong Wu wrote:
> A number of PTP drivers (such as ptp-kvm) are assuming what the
> current clock source is, which could lead to interesting effects on
> systems where the clocksource can change depending on external events.
> 
> For this purpose, add a new API that retrives both the current
> monotonic clock as well as its counter value.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  include/linux/timekeeping.h |  3 +++
>  kernel/time/timekeeping.c   | 13 +++++++++++++
>  2 files changed, 16 insertions(+)

For core time keeping changes, you must CC lkml, tglx, and John Stultz.

Thanks,
Richard
