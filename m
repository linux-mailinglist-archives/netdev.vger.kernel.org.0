Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8842F2626
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbhALCPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbhALCPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 21:15:04 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDE7C061575;
        Mon, 11 Jan 2021 18:14:24 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id v19so392862pgj.12;
        Mon, 11 Jan 2021 18:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HKwXEUt2KV6yKFtidI9ws3+xlcJfaSAZDwRiqf3lrro=;
        b=hYKPwKhE2oU3iWkqGCpi/yuf+O+T231tjBRvlO+6Xuu+HiZZQG9uWqHKQ9HHbqY1A2
         eRVIfiz8M/v9v7O5bbkyxPZoXS2fgBWJ+TGb3j4CZwAaB/qDjDR/fPKl2Cb7GbMMF3Mg
         UbW7/Wpy3gAOpMn3Th39IycQtbDbx3OkfVF0e9iS4B7oMhteQDfQfFPJLjMAklqxS/G8
         2bTDftSWBMaKyPUGu4tSigE6dCpa4hch6hTYrjTPssQuYz4CgkBjEeetRkAoo1akqVfx
         KTwg+kupB2acjFapYmLz0tXVDvKIR7HIJ30yRvuu+kKgijJ2iQGPYnWb3rPvQuAtuO1l
         fb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HKwXEUt2KV6yKFtidI9ws3+xlcJfaSAZDwRiqf3lrro=;
        b=UsPk3k6N5ZwnyZZ1r8YQ401zATF4lSHEmnrvXv77MH3D5aZdjnVpjB+sde8xFXcyyn
         GobG6sngSX5GFWvaTvfCFGaDC03y1XPH5DzDucrZs+mvCXs9OYi/Y3p4QPymGSEXaYOZ
         b4qsvXY87/dui5Xk35t7apEb4d3UNfMJLJLAoG1WIhYxlFvnyx2diHMurWCYx6y0lB5a
         Prak/tCHApg7aBs86B8huJoCQRJckPR8PBQuZCX3L5Zw8jDcO2aCy7UsPurwBdkR5dEj
         2cSK8csVFKEWocCZuR271RpzGyKozrHlKfIxJ7T9YZ+KuFETQY1HM+CnGoYq0TTcV23K
         9FSA==
X-Gm-Message-State: AOAM530oRW1cQyRnPxPgwChYPZz2MoOAAKM6uwEzAg9yZGazYuRpFGeq
        VfKWAfWU3cs1sUUM0+fZmKY=
X-Google-Smtp-Source: ABdhPJw9slzE8OzBbO4J+eiwaR63/+A8LmJOYK2IcTk2DUpF3XBWYgYkRWdbJ2m7CsHVB3685yLJQA==
X-Received: by 2002:a62:1ad3:0:b029:19d:cc02:5d07 with SMTP id a202-20020a621ad30000b029019dcc025d07mr2302990pfa.70.1610417663981;
        Mon, 11 Jan 2021 18:14:23 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id i25sm1092775pgb.33.2021.01.11.18.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 18:14:22 -0800 (PST)
Date:   Mon, 11 Jan 2021 18:14:20 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] can: dev: add software tx timestamps
Message-ID: <20210112021420.GA18703@hoboy.vegasvil.org>
References: <20210110124903.109773-1-mailhol.vincent@wanadoo.fr>
 <20210110124903.109773-2-mailhol.vincent@wanadoo.fr>
 <20210111171152.GB11715@hoboy.vegasvil.org>
 <CAMZ6RqJqWOGVb_oAhk+CSZAvsej_xSDR6jqktU_nwLgFpWTb9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJqWOGVb_oAhk+CSZAvsej_xSDR6jqktU_nwLgFpWTb9Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 09:00:33AM +0900, Vincent MAILHOL wrote:
> Out of curiosity, which programs do you use? I guess wireshark
> but please let me know if you use any other programs (I just use
> to write a small C program to do the stuff).

I was thinking of PTP over DeviceNET (which, in turn, is over CAN).
This is specified in Annex G of IEEE 1588.

The linuxptp stack has modular design and could one day support
DeviceNET.  It would be much easier for linuxptp if CAN interfaces
support hardware time stamping in the same way as other network
interfaces.

Thanks,
Richard
