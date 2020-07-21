Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E802273B6
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGUAVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgGUAVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:21:53 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD11C0619D4;
        Mon, 20 Jul 2020 17:21:53 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id o22so766705pjw.2;
        Mon, 20 Jul 2020 17:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0QEiMFp+qaL7hTwc5yZW08lBN5tHgXVvDuusU/E3plE=;
        b=mRk/TITb2c2/0ZkhLAiVGicSOfVzcJ6m1KONccwfiNvfRcPPUmO8aa/9vVUbzVr/wP
         iPOCnxXA5zv9SW3xBOf73OdsSDtRO6FT206XKuzzxKJ9JEj7uxA3cSB7svvM2sFcYsoK
         Cj/+IY5FGGeNsdiPwEKBcsKhaoXMZTZdkpbA1rmCkB8Toi9aoA3coTj4aqfaDguX7QWK
         XF+NxTL4JZZdG7LIt18cBxa5CUnnC8N7NWUClQ0jX4+heqX/SxM2QPJNfG93ig2C4WWQ
         OlKJ0V4vfzKk+Ss2XS3XrCYE0+9QiYfoHLoZ4Iut7HcZyojEB+kFeBuieoGD/8Ttm7/6
         59gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0QEiMFp+qaL7hTwc5yZW08lBN5tHgXVvDuusU/E3plE=;
        b=f0i05IFC0XtuMYMs1QoX4fLhMY6YGNSqnWc1D9cVlSpWMy76SfjgRRgWx4DftZBMHM
         7TONVCP+qmk7W1EsSDjI5hLe0i9gdBK572VoWbXvRz4zM90qTTp8alpKi+TD6Z3QfOtF
         ttV78+5PL5iAgnV1ILyYpwCZ1cxGIsvFH41a6Tzb8OL5/w9VLXrk/lwCxlSvASpimh8p
         d1wKMgUZGa8l9D05YMMxv5F9FCiufaWsNrLcpICiKSnSDjpk7Ml0D8+O9DovWPgxyBC0
         d1lsoaOqprC9V5JmLiQyu0mv5iXiL3EuaA/jJD2oCc06lY4AlxknfLV0gz4ZkJ8vXYdN
         Q+VA==
X-Gm-Message-State: AOAM531vw3YtnxY+2RVH+5J3J2JVe8GmNlEclxwbqneWlBw+RuY43SaY
        z9DKGwk/qHx5HGGmOBf7Ucg=
X-Google-Smtp-Source: ABdhPJwy+GuwsFOhdsuCGjezyhr7wCZ8Yf+483VJXn2TOYJxV4XqyT0WS6VRu9PzU7OM/xmRRBUPyw==
X-Received: by 2002:a17:90b:94f:: with SMTP id dw15mr1936778pjb.199.1595290913270;
        Mon, 20 Jul 2020 17:21:53 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q24sm15499070pgg.3.2020.07.20.17.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 17:21:52 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:21:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set
 of frequently asked questions
Message-ID: <20200721002150.GB21585@hoboy>
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
 <20200718113519.htopj6tgfvimaywn@skbuf>
 <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
 <20200720210518.5uddqqbjuci5wxki@skbuf>
 <0fb4754b-6545-f8dc-484f-56aee25796f6@intel.com>
 <20200720221314.xkdbw25nsjsyvgbv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720221314.xkdbw25nsjsyvgbv@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 01:13:14AM +0300, Vladimir Oltean wrote:
> I think at least part of the reason why this keeps going on is that
> there aren't any hard and fast rules that say you shouldn't do it. When
> there isn't even a convincing percentage of DSA/PHY drivers that do set
> SKBTX_HW_TSTAMP, the chances are pretty low that you'll get a stacked
> PHC driver that sets the flag, plus a MAC driver that checks for it
> incorrectly. So people tend to ignore this case.

Right.

> Even though, if stacked
> DSA drivers started supporting software TX timestamping (which is not
> unlikely, given the fact that this would also give you compatibility
> with PHY timestamping), I'm sure things would change, because more
> people would become aware of the issue once mv88e6xxx starts getting
> affected.

I really can't see the utility in having a SW time stamp from a DSA
interface.  The whole point of DSA time stamping is to get the ingress
and egress time of frames on the external ports, in order to correct
for the residence time within the switch.

Thanks,
Richard
