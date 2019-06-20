Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60354CF00
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFTNhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:37:51 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40483 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfFTNhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 09:37:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so3205771wmj.5
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 06:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oFRRwxv0XVler1vA71mJJMEoafgkZL5b47dVSJn/UrE=;
        b=YFqmJY5ErCsKFw6wd7xnu1lUJKbcztkjLv6ZWgb06eCocM4TIMpNC0e6sZRrSEO/sm
         sytqj9Fy86EPX9UzYD/3ibdXMSTpu3armPxSbDb45478mJce3zIdhrwHAdymcxco3k28
         oWEAI8rGj2aXDKWiXr6XtCesdMkyeU876/kLaT1oWmh8a0Ra+43WXGRhGTraxJ9hZkfA
         AS4Cnz8HVzgNMG77Y5CAm1P4vsL5PUixvjcuynGjq5gcoYKwNcyl0YYpl8SCobUuEtkh
         p6M2/o1/LT7K53OslHOd8Y+SiPXD6Z2zZ9ItWL+H+/jy/8Fn4ISVC8Ni4J8qiNIZu6C7
         0vyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oFRRwxv0XVler1vA71mJJMEoafgkZL5b47dVSJn/UrE=;
        b=a7y79obGXKsN+RxhuvcWXTC0R7Z8WDmQZIZDp4gmovLNpUnODAhhlFvtrxW8R5L/r7
         dyPkYJObTRXf4Wn9p3s2XDwMUPOButFjqvqSL4jhqyxS1Aiggn6XsFdKC5lpS81vFxcy
         FlQqa2QXfjUMiW3UrxOu2LApclFUIadQ8QaGvkS8iNQd2aZ9pyUqdVQA6J5Aa2SRU3vo
         hqswfIrnYCgTrjYhyUIi3+u7bvx6f8MyfxKC+qwy1DGXtBX5t9IyRjjecaC2Mis5OaJp
         N2zu2SnIL4BelSJnuAiLs4FWqyeagSjpk0+QvwvXzTd/KHjiKf9qFttOIFSw3I+yUNiD
         IApQ==
X-Gm-Message-State: APjAAAUsYzstEvd2LOzwx4Q5FP568xM8juTCHJoISNTXiSZs8OS/58+W
        nYwE5wL03vStrJ6o6PZ8rtmrAlVWN94=
X-Google-Smtp-Source: APXvYqwsbe2Y0kuUkpC+dfNWDM7IgeFtsSYsV/Wo/nKbcRxfTqdmvCYODUJapOHZBe3MJ0Lj5QEZqQ==
X-Received: by 2002:a1c:700b:: with SMTP id l11mr2940499wmc.106.1561037869082;
        Thu, 20 Jun 2019 06:37:49 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id s3sm5555967wmh.27.2019.06.20.06.37.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 06:37:48 -0700 (PDT)
Date:   Thu, 20 Jun 2019 15:37:48 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
 configuration attributes.
Message-ID: <20190620133748.GD2504@nanopsycho>
References: <20190617114528.17086-1-skalluru@marvell.com>
 <20190617114528.17086-5-skalluru@marvell.com>
 <20190617155411.53cf07cf@cakuba.netronome.com>
 <MN2PR18MB25289FE6D99432939990C979D3E40@MN2PR18MB2528.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB25289FE6D99432939990C979D3E40@MN2PR18MB2528.namprd18.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 20, 2019 at 02:09:29PM CEST, skalluru@marvell.com wrote:
>> -----Original Message-----
>> From: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Sent: Tuesday, June 18, 2019 4:24 AM
>> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
>> Cc: davem@davemloft.net; netdev@vger.kernel.org; Michal Kalderon
>> <mkalderon@marvell.com>; Ariel Elior <aelior@marvell.com>; Jiri Pirko
>> <jiri@resnulli.us>
>> Subject: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
>> configuration attributes.
>> 
>> External Email
>> 
>> ----------------------------------------------------------------------
>> On Mon, 17 Jun 2019 04:45:28 -0700, Sudarsana Reddy Kalluru wrote:
>> > This patch adds implementation for devlink callbacks for reading/
>> > configuring the device attributes.
>> >
>> > Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
>> > Signed-off-by: Ariel Elior <aelior@marvell.com>
>> 
>> You need to provide documentation for your parameters, plus some of them
>> look like they should potentially be port params, not device params.
>
>Thanks a lot for your review. Will add the required documentation. In case of Marvell adapter, any of the device/adapter/port parameters can be read/configurable via any PF (ethdev) on the port. Hence adding the commands at device level. Hope this is fine.

No it is not. Port param should be port param.

Also please be careful not to add any generic param as driver specific.

Thanks!
