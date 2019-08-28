Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4983BA0253
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfH1M5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 08:57:47 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:44883 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfH1M5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 08:57:46 -0400
Received: by mail-pf1-f170.google.com with SMTP id c81so1668200pfc.11;
        Wed, 28 Aug 2019 05:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DOX928M42E78kp/YSIbAI/Nv6Ph0nAcuo13mkFHY0MU=;
        b=RYBknpDeoyfQ9ZcUL07mKLD0eQTIvPt3BPHuJW2YqcJUSmH8hzjJgyGvitqMIzOEzY
         2zBP9rK8j46PJuKWOXdCbJ4M6+q7ql2KZRkH0EIoaYYlhNJlkDHu/JqQHtdLIet1qWHA
         JOEtM5P08jc05VZ1UUfRbvfy+qak0M6RwfDC4oOChg+bk7uferGyJMftSkrGzNKcvFO2
         fhcUlo76GLPW6ksIFvlHMDstbmPPmb8okSE+EDet2x8LlGJNb5ZeYDiCV34t4wh0wkS4
         s7KVu0YfQCv9JfpXUND3Bt+xUtIvHRXcBSVE9/K9aNPkKIxvdazE1bnzz4ndqfkprQNi
         1S4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DOX928M42E78kp/YSIbAI/Nv6Ph0nAcuo13mkFHY0MU=;
        b=gxq4373UxqcPq9Mww7dx2+N5NN2Q3oZx4iLyQ+UCaEGg/TCjG0Gt5yY3zXlVoPgXgO
         jMMbXnGgW6uWMLa8OE8dp5cHJuHDUwhHBqo7YwZcktmPOapLNH7pjPl16HTIfqk5qRsP
         Vh8/8Vdc4B3fk32L7qzOeCWFV6ZhHG764qWjPnJKD1MNvga+aZ61dszunlnhC2gky+3r
         Di2W9pGK15bc0wcVgSCneR9hMZi7M7qg/+NgQCdvrSnZIC/G/6kZTXUmWH59RwFq8tch
         wFAkWsUBBw8lBa7Ab32ujhwEtxd5mtZsKwLX5nHXYnoE038+HYKiEy1pTjBlv2Dd0OKa
         zzdQ==
X-Gm-Message-State: APjAAAUulr5TSHrVM8D5aAMJqh3RZRB5cWbJi2v4TFfRaOzcv5dEy4oQ
        ZSZBLCaYlVtBE61bsl13ew6D0Gvv
X-Google-Smtp-Source: APXvYqxfiuV173gFNc1NaXDpHZXTqeYeYZgQhxafHP23pgKRh9h5lg6iG2P6cqY75YFohV/TV0HXUA==
X-Received: by 2002:a62:1941:: with SMTP id 62mr4525112pfz.188.1566997066099;
        Wed, 28 Aug 2019 05:57:46 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 11sm2099371pgo.43.2019.08.28.05.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 05:57:45 -0700 (PDT)
Date:   Wed, 28 Aug 2019 05:57:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Joe Perches <joe@perches.com>,
        Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PTP: introduce new versions of IOCTLs
Message-ID: <20190828125743.GA1534@localhost>
References: <20190814074712.10684-1-felipe.balbi@linux.intel.com>
 <20190817155927.GA1540@localhost>
 <a146c1356b4272c481e5cc63666c6e58b8442407.camel@perches.com>
 <20190818201150.GA1316@localhost>
 <83075553a61ede1de9cbf77b90a5acdeab5aacbf.camel@perches.com>
 <20190819154320.GB2883@localhost>
 <0f1487356ae2e9ff185ede2359381630007538c7.camel@perches.com>
 <87k1axwvei.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k1axwvei.fsf@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 11:23:33AM +0300, Felipe Balbi wrote:
> Originally I had memset only on the three cases where they were
> needed. Richard, which do you prefer? I don't mind changing it back.

Go ahead and change it back.

Thanks,
Richard
