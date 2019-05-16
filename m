Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0EF210FC
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 01:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfEPXZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 19:25:27 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44963 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbfEPXZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 19:25:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id z16so2288701pgv.11
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 16:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/CBAL7ziIilFr4+6cSFD+fB4hY4nta8zjkUko7+t7ZY=;
        b=OEzT3yeIG+tU1P2txqT+HuWmNI+RqOGYK1meZsH1GEV6z/m2X+J8LMxM60P8tqxUZc
         lseBoeS+upXVripcBe6yx7gaUtGbkYO1UYq/+7PlGbIwpoIRDbBvQROcMA1uyQq6pcby
         XBpDqjXxsvOO8tCEDHkxPt+gRA2vCpa2GjolcqRdKKKa+01nIT1OsUJv8e64Z/B4no92
         Y2sxhV4zI2awJVeCEvfLBmXgqpvhht3BdbvEyaOTxCz4M8y1ZnDRPKXdEUkfZONu+QwE
         Cdte098mCvIDHrh6NR794vD73NuZyLYiTpD700Wx/lOK9QCe+ZaazY+r/SdCnmZaElvZ
         JtsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/CBAL7ziIilFr4+6cSFD+fB4hY4nta8zjkUko7+t7ZY=;
        b=umN/kWWg0VbPNucssTnpVcg63Zn/vCJTeGk6Nip7gkpA/bl20Ud9enOWbBCB2ujy1L
         TSz6SUXF+dEPNhvYbpgwPH+6xvBkoX2CHWrFDoGOGnpMaFF8Ljv4UW6AUgpGZhKt3jMK
         0wJZ/htizRyrzJBkl1LQyxVf85jrQMvstwJ6l59XL+go+bj1u3Z1QnS8oXskSBVV2HIv
         wOriyRQ74jq7uotWt4oUoqGMT6HIje/PTFlDd4BOTjTK+UkCNO+kK+fkQ7dE+8lKWLIs
         ApVz8+YIrKH+K+7d6f1btqDQ47IzI/eihkrN2+qEWLurafiYxtQ1/fsXZXKTa1qi0IGS
         HwYw==
X-Gm-Message-State: APjAAAXEnJf6/n72YbyBc/25PB92RQzkzj7uC+vKtjsQc7VguCXlOiVR
        O9JOSWbXI90UanO3SxENIWtE9w==
X-Google-Smtp-Source: APXvYqzFutdViqEsg6s4Naj7gr4QHnXUIId7UOF4ecSL+mRePIasDB28+rtypiEWa7VdWcBA9L+c5g==
X-Received: by 2002:a63:7989:: with SMTP id u131mr44898655pgc.180.1558049126774;
        Thu, 16 May 2019 16:25:26 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i22sm7701552pfa.127.2019.05.16.16.25.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 May 2019 16:25:26 -0700 (PDT)
Date:   Thu, 16 May 2019 16:25:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: Re: [PATCH net 3/3] netdevice: clarify meaning of rx_handler_result
Message-ID: <20190516162519.06910fa9@hermes.lan>
In-Reply-To: <20190516152543.729c6cb0@cakuba.netronome.com>
References: <20190516215423.14185-1-sthemmin@microsoft.com>
        <20190516215423.14185-4-sthemmin@microsoft.com>
        <20190516152543.729c6cb0@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 15:25:43 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Thu, 16 May 2019 14:54:23 -0700, Stephen Hemminger wrote:
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 44b47e9df94a..56f613561909 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -374,10 +374,10 @@ typedef enum gro_result gro_result_t;
> >  
> >  /*
> >   * enum rx_handler_result - Possible return values for rx_handlers.
> > - * @RX_HANDLER_CONSUMED: skb was consumed by rx_handler, do not process it
> > - * further.
> > - * @RX_HANDLER_ANOTHER: Do another round in receive path. This is indicated in
> > - * case skb->dev was changed by rx_handler.
> > + * @RX_HANDLER_CONSUMED: skb was consumed by rx_handler.
> > + *  Do not process it further.
> > + * @RX_HANDLER_ANOTHER: skb->dev was modified by rx_handler,
> > + *  Do another round in receive path. This is indicated in  
> 
> s/ This is indicated in//

Thanks, left over from previous version forgot to trim.
