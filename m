Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E348A8B083
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfHMHOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:14:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52370 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfHMHOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:14:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id o4so350560wmh.2
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 00:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9u8NDCl3d4hiqlfgCDxCc1GG+tnwPWuKGTzzdb2v0wI=;
        b=nGpfbgNCNSnAHuafWLl5F1pzE2KKGZjuVOG/GHTbGdpe88c/zXd+tFjI2+DQnHMDWu
         tez6phCx8M1jbfVgxxmjmJCXI/wxTRJWMWAaVR6BIhuEs0eaPPRvDH3HGa9aYMEbBA0p
         exXN/Ux7gaOWmHItSWsJDdo2msFZBavPwGMbpFm75c15izCeM96Fv/Gk+Z0dVeHe7oQX
         CIsh4hnlyhqoeceiFzjhcSbaV/6Brer80cMo2ftbuvQ3VtVFfnO9+JAvq6UElqHu0Rcm
         MPWCQLq6wIS2wy1rlZOsY29+zUj59mS2M+HTlIrrLtszyyrrSQULzQE0rDG+Oh7YpMyk
         hrVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9u8NDCl3d4hiqlfgCDxCc1GG+tnwPWuKGTzzdb2v0wI=;
        b=sdt3ci2gggeYBOwhKfdh06kzVmdvyN4b8fRyaVWjcJ6RBNngMyg2B3KXsjf/BOFlgN
         b4J9a8kAQvFFvMQtyXYwRVtzHViX3eENA8PVNkER6HblLbocxH1k73g5+kKrixJifbIY
         oQ8RtpWY1+PB+8tbEqFFJ+0w61iUmZKPU3REFBeNJfjM/30fR7vRmPZTw9h8+b8INlvc
         js8gIba3SlK5bJqfadECTRpopmmOcZjssLePGDXesA4HNdfdyyRiOVVXjYjSqjr5jCYV
         gR9gh5bIx+O6tO9yClBZZgLY2uLL66D1b7W8FiE3OrIbkQ8SKVt8kyKMl52Egp9zE+/X
         rxBQ==
X-Gm-Message-State: APjAAAXa9PSPLiS+pV0vSifNJ1mY05cynf+1nv1bkDPwCDGlEttj+RcM
        xP6xuqn6yz2tQ9Qu+0ipOEDHIrc8tfI=
X-Google-Smtp-Source: APXvYqx3C33CTlEyp5/Q1PM58vRo5DgKJiSL5bJVGQsDZDbeiZ3ufkXiF1CxUnv2BPGjofW8YhFYkw==
X-Received: by 2002:a1c:4383:: with SMTP id q125mr1435554wma.16.1565680486621;
        Tue, 13 Aug 2019 00:14:46 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id a84sm666859wmf.29.2019.08.13.00.14.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 00:14:46 -0700 (PDT)
Date:   Tue, 13 Aug 2019 09:14:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
Message-ID: <20190813071445.GL2428@nanopsycho>
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190811.210218.1719186095860421886.davem@davemloft.net>
 <20190812083635.GB2428@nanopsycho>
 <20190812.082802.570039169834175740.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812.082802.570039169834175740.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 12, 2019 at 05:28:02PM CEST, davem@davemloft.net wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Mon, 12 Aug 2019 10:36:35 +0200
>
>> I understand it with real devices, but dummy testing device, who's
>> purpose is just to test API. Why?
>
>Because you'll break all of the wonderful testing infrastructure
>people like David have created.
 
Are you referring to selftests? There is no such test there :(
But if it would be, could implement the limitations
properly (like using cgroups), change the tests and remove this
code from netdevsim?
