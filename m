Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC73E36266
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 19:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfFERX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 13:23:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37579 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFERX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 13:23:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id 20so12765889pgr.4
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 10:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ccqbvVPhRWEwkTa2YljRGCQ4NUR6OIKnqESg/VblPQo=;
        b=Q3ssyOoOxn4YIa8EbY9UYoNvPxteyHaiJcQ28+qmTlYJFTC7Z7Y0NDQQAo3A0oL520
         jtlXjOgpMz9b3LOw0Q8A3H3mOdOVDvugywcHlYqH5Av+1ipKB/Y8SHMtxKGuq2tP2OtF
         C3x0U38+qvCQqAjAvgYFZN4AsN7UE8SiMRAMH8T2eeoWuS+8DKuXtH1rvWlM67oMNrBF
         NUFQrcZ0jSVcD6W276g45rQDYnfUM7pZFfedEbbYWrDCScOY/wPZIzzdpFvtcHs4XbpV
         zPjp19UwBPsutwQZPMvp5jhjouiaimjdqfDtNtUWKonHkM7puvXbk2Nxfek0EKfhI35s
         fZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ccqbvVPhRWEwkTa2YljRGCQ4NUR6OIKnqESg/VblPQo=;
        b=mQRfh83U9cvfHSej4n6tIaODT5djv1uQAvex4yMFgan7juBrKMtidYOTqj8HsfOU/Z
         oTdaqmZfAQV1rpwDoDGM4qJLZKpJBwJVGXhHVe1lTh3WXVNGux3jC9216AMrPudQno19
         BsKucRkP2uVPPd1x4B3ygQwcOoKQH9XwJsEmK935E9Tuws0JXZvGuSgANfTz4N+8tEEI
         m7RtonliiV1NV+6u9Ouh2fMo+zY3p9isr/zI8/WC0OU3bK22ktx/VcAC5pgHRxAl9W79
         OyjBYdD7puQr0wacqhlQ03X6ey8Hj8x3xoDLbUtS1u41n+dLVkJO/PTn72RGNSe7En2N
         eL9w==
X-Gm-Message-State: APjAAAVfKtRM1a0lhJermYfvZJ34p+nJwvR/uSm1VeKfLLpdyGectsTi
        3Xh2ZB9dAwYd5QgrG/2cr44=
X-Google-Smtp-Source: APXvYqx/RY5FNVXTwRNVG3ZZrXhYQBoTXzFgo1wMgDMnyn3kdEMt/ApOjF9TPTLwytpJ0omQ5E5sDw==
X-Received: by 2002:a63:1d5c:: with SMTP id d28mr5961801pgm.10.1559755437736;
        Wed, 05 Jun 2019 10:23:57 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id d132sm8017621pfd.61.2019.06.05.10.23.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 10:23:56 -0700 (PDT)
Date:   Wed, 5 Jun 2019 10:23:54 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shalom Toledo <shalomt@mellanox.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Message-ID: <20190605172354.gixuid7t72yoxjks@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-5-idosch@idosch.org>
 <20190604141724.rwzthxdrcnvjboen@localhost>
 <05498adb-364e-18c9-f1d1-bb32462e4036@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05498adb-364e-18c9-f1d1-bb32462e4036@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 11:30:06AM +0000, Shalom Toledo wrote:
> On 04/06/2019 17:17, Richard Cochran wrote:
> > On Mon, Jun 03, 2019 at 03:12:39PM +0300, Ido Schimmel wrote:
> >> From: Shalom Toledo <shalomt@mellanox.com>
> >>
> >> The MTUTC register configures the HW UTC counter.
> > 
> > Why is this called the "UTC" counter?
> > 
> > The PTP time scale is TAI.  Is this counter intended to reflect the
> > Linux CLOCK_REALTIME system time?
> 
> Exactly. The hardware doesn't have the ability to convert the FRC to UTC, so
> we, as a driver, need to do it and align the hardware with this value.

What does "FRC" mean?

Thanks,
Richard
