Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8CE7F2FF
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 11:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406168AbfHBJxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 05:53:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39517 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405452AbfHBJxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 05:53:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so35817476pgi.6
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 02:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9vVjG5m42v/NuFNkyTXj5a6oSEBfl6MvKaCLr1Ls4jw=;
        b=Qu3gbpQgODT9VPQnFOUAbslp/d7FaRmU/7Demsn/ZutIUnsUiNgtFl77Y9rz0aoa7Y
         rWNYLpZuTd/y7zZrJszod/ntw6lWgEZb2IgLvlAC1WfVs/50s8Y5xVl3kHTrD2DPBAey
         WLgQu0rBwDd4B63qgQYYyvyubwOVjKqz4vzLmH0Nk4bq90HL1Cvb139G/jqS3kUUSADW
         2thDiE0riZ7sdaaxO0Ek4EbwVD+4Ig4613qZRPrtEwnU7OO3Rp1On7dSTFuNuUtWNGmk
         0BhjtwNEA8f5yYFGzllNkjW3/ThqcmNgeI6DbhPmis2X07CeypWh57XU/701GLyHOcy9
         8YYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9vVjG5m42v/NuFNkyTXj5a6oSEBfl6MvKaCLr1Ls4jw=;
        b=PxukeAneamvXosrgjvbY9UbB/bh6eHcYkQDZ4WD4rX6TpaKRmzsZwZ7TtCRWM6lwXQ
         47q8RLXYUtdwtgcwVyTX74kDakBaIoabx7y4C0Y0bpOU3U8l2HH1LomhjYffMfw42uRo
         SqjsTzEncRW8pmL+qwl6I8fjNnM1e0E1Zr7Oi+RKSmP6D68oTfwMGRRJ+BybQ1MW78/6
         jSBTRK9VWZrGyeCDf7mS3cbPrLTKaayfF88eiSBMc0zkSaat2fkvAaDXHHJ2uk5nMZiX
         8lSHEsanP8JlSs/ZduFfb54c6OAZTczhiXqYP1GIjbI2CWxO8aSRvgRc/+A6rHiDUZNp
         sSzw==
X-Gm-Message-State: APjAAAUmF/64+rE4EQiU5rs0rIhU2JnSEy0NTXxCT9xJuEgKmtJV5eBu
        KlA1pQEG+F3uiEyGcI/Cl2iONANH4g4RvQ==
X-Google-Smtp-Source: APXvYqxuMx0uFGb8XcRnMGZc+VqEP7n0pcnb9ogkE3MPgIifEzHoCgAJlGlv7opLOtnIumu2d2QgLg==
X-Received: by 2002:a63:2b0c:: with SMTP id r12mr123410385pgr.206.1564739591011;
        Fri, 02 Aug 2019 02:53:11 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p68sm87023154pfb.80.2019.08.02.02.53.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 02:53:10 -0700 (PDT)
Date:   Fri, 2 Aug 2019 17:53:01 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH net] ibmveth: use net_err_ratelimited when
 set_multicast_list
Message-ID: <20190802095300.GU18865@dhcp-12-139.nay.redhat.com>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
 <20190801.125114.1466241781699884892.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801.125114.1466241781699884892.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 12:51:14PM -0400, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Thu,  1 Aug 2019 17:03:47 +0800
> 
> > When setting lots of multicast list on ibmveth, e.g. add 3000 membership on a
> > multicast group, the following error message flushes our log file
> > 
> > 8507    [  901.478251] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
> > ...
> > 1718386 [ 5636.808658] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
> > 
> > We got 1.5 million lines of messages in 1.3h. Let's replace netdev_err() by
> > net_err_ratelimited() to avoid this issue. I don't use netdev_err_once() in
> > case h_multicast_ctrl() return different lpar_rc types.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Let's work on fixing what causes this problem, or adding a retry
> mechanism, rather than making the message less painful.

Yes, the multicast issue should also be fixed. It looks more like a
driver issue as I haven't seen it on other drivers.

I think these should be two different fixes.

Thanks
Hangbin
> 
> What is worse is that these failures are not in any way communicated
> back up the callchain to show that the operation didn't complete
> sucessfully.
> 
> This is a real mess in behavior and error handling, don't make it
> worse please.
