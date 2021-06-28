Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81F03B6B7D
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbhF1XlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbhF1XlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 19:41:05 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6ECC061760
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:38:38 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id g21so13894926pfc.11
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nclVkiYLXoFffUj1wobBCMhr60BViPV9a1xYgpiDQHs=;
        b=Kh6TzMpNSOhv0BACwIlqCmBJd8NsGnlsaawevKUSRyia8r+koFfANsrazUAMiuLN+O
         ckR+SOZHIYau+qwqNHj4mdnlfRkluKxH+oNMhaMZrbgEEo+m0sJzfbpYSriIvAftZkvq
         lXIlhWmAlHtNZwzrnbM6B/UkxMWNi723cUzd1cqf0zp7+c+msWJiu4e1PcwAVz/ZUzIo
         y3NExWAU3K5/aWr0CVXfg6oJEfdBRx/f0rgcb2cBHW9mVPgcFI7CUhiclxSGHmJAFdIB
         OSCNDCuvCOsSRxtHNYsB/QqYF8OcUTWh3bBjngnPeYCKwFtMWas7GkY5VFWG5IJlLy0D
         bHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nclVkiYLXoFffUj1wobBCMhr60BViPV9a1xYgpiDQHs=;
        b=g+y9LFVyL/BmIEU/te9RuJYlKXcPmEqVIxmwWa1Vlxb8HyHS1D13dCbaVyBWp6B/tC
         Pqo83/Umw1TREk2jVLtLcdIZeQsUEQHgRca7kkKql/v/O72f1lxDeEWWIvRYp27EY6Es
         0X6y3Frs9lNbkPC8kDgsZwrSFTRx2Z/Druec07yFrtOKh76wml3JgyVvFVPNzhTdgZY2
         ylnmFqwdXQbZBRQZGn0mQ9uFvKKnee6/2jWYZlshnvlmkbVpPJOS0ToohqgFSUODOFJf
         43rlSSolneewSONUXvPG/CRlR7o5h5pPnb920W6ABXQCn1/4mSpNJ9ylQNgzbNH9mPqi
         G35g==
X-Gm-Message-State: AOAM530GrDS7Yu/0hkh3zazjkncZ2slwAnr0jMRQasBqscKAv2/qffuo
        gB0aV2X9W6P9dvueC4CfLe0=
X-Google-Smtp-Source: ABdhPJyQeLUcYA6niXGgUsxsLblENEONhaJO8Tlr4nn6pTPCqsq2Kr1D11ERnWWtQfD6zRvNWoVEew==
X-Received: by 2002:a63:ae01:: with SMTP id q1mr24831967pgf.216.1624923517638;
        Mon, 28 Jun 2021 16:38:37 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y9sm5637458pfa.197.2021.06.28.16.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 16:38:37 -0700 (PDT)
Date:   Mon, 28 Jun 2021 16:38:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Set lookup cookie when creating a PTP PPS source.
Message-ID: <20210628233835.GB766@hoboy.vegasvil.org>
References: <20210628182533.2930715-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628182533.2930715-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 11:25:33AM -0700, Jonathan Lemon wrote:
> When creating a PTP device, the configuration block allows
> creation of an associated PPS device.  However, there isn't
> any way to associate the two devices after creation.
> 
> Set the PPS cookie, so pps_lookup_dev(ptp) performs correctly.

Setting lookup_cookie is harmless, AFAICT, but I wonder about the use
case.  The doc for pps_lookup_dev() says,

 * This is a bit of a kludge that is currently used only by the PPS                                                                      
 * serial line discipline.

and indeed that is the case.

The PHC devices are never serial ports, so how does this help?

Thanks,
Richard
