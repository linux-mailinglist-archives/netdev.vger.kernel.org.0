Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C58E28FA9C
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 23:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgJOVXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 17:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgJOVXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 17:23:53 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FE3C061755;
        Thu, 15 Oct 2020 14:23:53 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t18so82378plo.1;
        Thu, 15 Oct 2020 14:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Thkec37BhMNj0b3b5u0X9DG3U0+Cmg1zxAXDs/fXpzk=;
        b=EzEZUblnMKoKReX3cMluKftiEW74l6xKElXl6P7zjwQaObYff2xO9j8u1fSPU8+Kig
         iz36fdIUFVWtlSTw/lZIguAZVsBTqL6y0IKxfy993v+ZiU/wNgRS3IsBlcqPp8gox3ym
         ILxHVbBX5fabINJlAXwIJk7PcGTV3OaM/cXigxJtH0KePCbK3+AYWVjWbXeJYiUUmbL2
         RToIycJ88jJkQuu3eQshNLJr2IcX1dzOQfpk92f+gE50l0x2+wnP+TOov6l2DdrJQYxe
         OYGRqIcs/WaLSQVeNNuuXmmrH+s8wKlhsL/uWxKi/MJ34Q5/4wGj8tcrpsvC6ZhqtTtP
         mAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Thkec37BhMNj0b3b5u0X9DG3U0+Cmg1zxAXDs/fXpzk=;
        b=G9UGKYgDSgRr3v7DGlPZhWN6mzba9okPqjxKVx35NcPd33jxaLpjqutCflPBI7K/Oh
         vngA5WIP8827Yx4tVOWoLLHLcWm6hZ3ZpsWNrgfkvSHOD8IzRFR4UiPoXkM35AdbaxJv
         o6hhLpMCjHol53jpD0rq/eB0Xi8lpmntWgKXBDnHE6ZTkzfKgcLfahsJDkmL3XSbJfwC
         PR/76YVSZesVJjjruW0rDcQNZhhxF5smWOUdzWkwBmwbmiTIgD2l4ZKAvtkVFKyGNNNq
         TxKkkp8M3djE5MkTe9Zpl+IF4lPV+BwHg4oHBTr0DL6idHs2PEiUheY6dBf2i1c/PyUC
         yPNQ==
X-Gm-Message-State: AOAM532D16hOWdSc5SC2DkMZfaYYJNsY/VwsN8hOCA0UP8hi4selUouv
        nX2ykGT9V4imKLkk5ne3ZrgsCBQrovI=
X-Google-Smtp-Source: ABdhPJzLwylql+oObqVfAwFtEA61Mba2lr3DdKWjrkVkEetB3mCu+fMmYp4YA0CspYSBFxTjYsFkFA==
X-Received: by 2002:a17:90a:3:: with SMTP id 3mr613584pja.184.1602797032971;
        Thu, 15 Oct 2020 14:23:52 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z6sm216796pfg.12.2020.10.15.14.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 14:23:51 -0700 (PDT)
Date:   Thu, 15 Oct 2020 14:23:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/4] ptp: ptp_idt82p33: update to support adjphase
Message-ID: <20201015212349.GA9385@hoboy>
References: <1596815755-10994-1-git-send-email-min.li.xe@renesas.com>
 <OSAPR01MB178028345EC84C1564DD104ABA020@OSAPR01MB1780.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB178028345EC84C1564DD104ABA020@OSAPR01MB1780.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 07:30:38PM +0000, Min Li wrote:
> When you have time, can you take a look at this change? Thanks

Min,

I think your series was posted during a time when net-next was closed.
Please report the series.

Thanks,
Richard
