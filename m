Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFBE972DB
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 08:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfHUGvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 02:51:18 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:45751 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfHUGvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 02:51:17 -0400
Received: by mail-pf1-f174.google.com with SMTP id w26so767651pfq.12
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 23:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Duy/99WqLuIZ/zHDh4L17wpHwLwOWeLWXcipihutdTM=;
        b=ZsbtHtDVsTNLERqkSx+zP45gNECcVKK2O54z0Ak7eoHtlfwXqz9esGQUFJIkza7SlZ
         FqPVvBLQ+2QXetzYbNR15F6zZl5En+GSSVZtqrHLkdysLrw5loLWJowpBpNwsANcp/ha
         a8Uy35d1AvRgoCtjrLQ9PPSAno45vKcCQsS88orVWmZrejf5Yjk3RphsWi0aFCTvT3Us
         1Q1cas5nt2foy4LZ7cJLJY9gH+EorPu6FtvQJsGxL2sSFSXfvWVvIrgocOLIYH1xZGoU
         98MYXjziKd+yJz8e4eSgngI4W+6vY+xZoFkQGeUtnjGi2euVmOU6BoTVRhtBy6QYIk7H
         8byw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Duy/99WqLuIZ/zHDh4L17wpHwLwOWeLWXcipihutdTM=;
        b=M2b5Wsk4EMMCYf2HJ8FHsEa+6Q/zz7rZb7Sw6cRbKd+YCf4tLHe2trwgy4cMLQnd5O
         isJojzBm2ZGw7UO+k6BNmS2qSM0rupXwgOd97nftEnyVt+pJ4MmJXu7oKGhrYdgg71CM
         Nrc9IApIuOdJ32wn99yFh8tuq0W+048p5mV3Y777S6BAmqCNm4+XcBNTW16df/2tw9jR
         vjl+XBjEtINoqlZoViI5iNEF09l4O1zCjZbTSDRjI1d4dv0AUOrXChAiTzVJQ7nhvqTR
         AEO/5q1ntzypNn/otfOJm3D/0YFBPrmW039OYivNltrfYA5mQkYIxCwdiCKqBVU7M6AK
         FYbA==
X-Gm-Message-State: APjAAAWQj+Lm0GOhmeamTnbXohIv/IC0LprCQYFpzIZJljhZu5pCPaZu
        7OBhbmADHZEuYesfBQwDgDTkhg==
X-Google-Smtp-Source: APXvYqwzxv5ZoMPZpNsGpeUx6rVNuP4bug7j5pGX37pVKAaFZAjrLYC/SNi8Oyna89Q8uVJSHKIQBw==
X-Received: by 2002:a62:8344:: with SMTP id h65mr34189657pfe.85.1566370276885;
        Tue, 20 Aug 2019 23:51:16 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id y23sm27441842pfr.86.2019.08.20.23.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 23:51:16 -0700 (PDT)
Date:   Tue, 20 Aug 2019 23:51:12 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: various TLS bug fixes...
Message-ID: <20190820235112.2b5348aa@cakuba.netronome.com>
In-Reply-To: <5d5cd426e18be_67732ae0ef5705bc4@john-XPS-13-9370.notmuch>
References: <20190820.160517.617004656524634921.davem@davemloft.net>
        <20190820172411.70250551@cakuba.netronome.com>
        <5d5cd426e18be_67732ae0ef5705bc4@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 22:18:30 -0700, John Fastabend wrote:
> > > I suspect you've triaged through this already on your side for other
> > > reasons, so perhaps you could help come up with a sane set of TLS
> > > bug fix backports that would be appropriate for -stable?  
> > 
> > I'm planning to spend tomorrow working exactly on v4.19 backport. 
> > I have internal reports of openssl failing on v4.19 while v4.20 
> > works fine.. Hopefully I'll be able to figure that one out, test the
> > above and see if there are any other missing fixes.
> > 
> > Is it okay if I come back to this tomorrow?  
> 
> Is the failure with hw offload or sw case? 

SW case, strangely enough. Large file transfer, I think with openssl
client..

> If its sendpage related looks like we also need to push the following
> patch back to 4.19,
>
> commit 648ee6cea7dde4a5cdf817e5d964fd60b22006a4
> Author: John Fastabend <john.fastabend@gmail.com>
> Date:   Wed Jun 12 17:23:57 2019 +0000
> 
>     net: tls, correctly account for copied bytes with multiple sk_msgs

I had a quick look at that, but the commit in Fixes is not in v4.19.

> If you have more details I can also spend some cycles looking into it.

Awesome, I'll let you know what the details are as soon as I get them.
