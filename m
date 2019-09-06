Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F70AB213
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 07:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392379AbfIFFgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 01:36:00 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37369 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392368AbfIFFgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 01:36:00 -0400
Received: by mail-pl1-f196.google.com with SMTP id b10so2579055plr.4;
        Thu, 05 Sep 2019 22:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vhdxc4ZQN68NuRvF/4TxwiVsBNkRj8a+6R5dyH9hgtQ=;
        b=UrbyERNhnioC9vM34TKgslxPC9GDfQAzTuSQw1mIryRCBUBREBB3hRfMeTRKB3RKwN
         zaeC1a0uYHuXi+N/QuPzAkGCJklAb5Pp7HS/M/tySpADiIZ2yynwvXPSkfbp612R3rCV
         7j4rcZuODuOl1kFW4R+pvyrMSRSVtqIVPHRl4tcyctkiOm/t4o9h4D+vSb1bvg8vAgRt
         0voKOxH55NyFoUcR3vu6R69BK6sxvO/tMATBib7tjmotXSif/9/doHVZMYHhq3PStpXC
         fQDuoH+SZOkyp1TEnoizNbtOPuPFc2F7ZcDVeQOGokj8h1cPYnVa2X3dhlcdvBCeYebb
         htGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vhdxc4ZQN68NuRvF/4TxwiVsBNkRj8a+6R5dyH9hgtQ=;
        b=fbMC7e50rkPjzx0UvRwEaAjwRMuqdrn/kzvmWWkOoTERtYenZYB3qqJtgYCkLMuP5h
         YgHsNGbrzeVXCidwEGJp1amBb6mASmhIXi5+piX0iIuJQn7GbQ1lqOP4Ea0txzFZiYWa
         OoPaFltEfKiS3KMj3ECbPx5ukFnSZZvrQWliTqV3ncXYOR5rJmS0ZGz+Ct5wlCTcZs51
         7sHI3zCDZa6ARB82j9yNlVZPKyouHYxPggPj0BLcBGAZkgrJ3QFQmjFvjddy+mwx1O5E
         pcoGxzIwaRZwcKqfBXQh3MRnUoP96QdfI4zBob/p5eUIycBTO1MXiemRDqBZUVkMKOCQ
         4RLA==
X-Gm-Message-State: APjAAAXkw7FYIjBLkyrlsrXgDngB8a0QVWbTox78H+C4heQ7c4IU4Zl/
        k1crL/Pbj3uinuhWiQn0PqE=
X-Google-Smtp-Source: APXvYqwGOW6Dpz2/9KfdUuRutFfvd8nZK3snjg8Bnj4/+KQGpsMsMmWnW43raxny+4AGWGhjfFy/GQ==
X-Received: by 2002:a17:902:f301:: with SMTP id gb1mr7279804plb.249.1567748159836;
        Thu, 05 Sep 2019 22:35:59 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id v12sm3671516pgr.86.2019.09.05.22.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 22:35:58 -0700 (PDT)
Date:   Thu, 5 Sep 2019 22:35:56 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v2 2/2] PTP: add support for one-shot output
Message-ID: <20190906053556.GB1422@localhost>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com>
 <20190829095825.2108-2-felipe.balbi@linux.intel.com>
 <20190829172509.GB2166@localhost>
 <20190829172848.GC2166@localhost>
 <87r253ulpn.fsf@gmail.com>
 <20190831144732.GA1692@localhost>
 <87h85roy9p.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h85roy9p.fsf@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 05, 2019 at 01:03:46PM +0300, Felipe Balbi wrote:
> This a bit confusing, really. Specially when the comment right above
> those flags states:
> 
> /* PTP_xxx bits, for the flags field within the request structures. */

Agreed, it is confusing.  Go ahead and remove this comment.

> Seems like we will, at least, make it clear which flags are valid for
> which request structures.

Yes, please do make it as clear as you can.

Thanks,
Richard
