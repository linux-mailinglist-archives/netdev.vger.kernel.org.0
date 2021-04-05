Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59373546BC
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 20:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhDESXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 14:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbhDESXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 14:23:39 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18620C061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 11:23:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h8so6073406plt.7
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 11:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=/rgYvZOR96hVJwdVg1HGJnuISqKz0TKUJ2ixZZ12lds=;
        b=nVv83mWvxXmN1ahWjB/5/h17ElLA+ljKMoF3tAaleC7o6L5XvKvb0Kc0J2kSc6mHUV
         jG4OilyAFxejh2dc0GOhvHSJ19USe2iHD3DshpT69g0FW14hA2OZr0ruc2/isGEKShRH
         OnrP6bZeh05QN3zxxPe+Mzix45nxc29qglX+x1KgcecoZwEidw+kk9Gg87na/Dn47afr
         JNBn7q3Yr1PobP1cTmN3t1LZLiKnKrcG3YOtm68LYARh/s7lQ6oGHW7MysNiV9+amEHB
         ZO7fDG6q/Ux+2l1xDQl4PDFebEz8WYlRrioppcZ0SR9zDw3f66pYYoyiOGh4tBpOBJMp
         IULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=/rgYvZOR96hVJwdVg1HGJnuISqKz0TKUJ2ixZZ12lds=;
        b=b8b0TSybmHYQts0ko4ETmEwlyVfHqudqfMbcvtDRdPiQwVNFSBR5XtpR+QWSI4luTP
         Nn+dDT4y0AkEzsnQh1tdeMEVnvOsNCQv8tjGCSloZRDeyh+ZGJpZuv/VzPOLXiyXq52L
         lLNfeWhtbQOWXZ4quW98ReO4QwetHT01Z4L8omrXlozSZET7sAUKdu1utyV2A0xcpmLO
         4lLqVfhNTFMedd0HeMp+SltgJBvM0NprCZc7tFKAbmeSdSBhIpsaTjSFYLDDXm+WkM3O
         QHtzsNwnRrLKHHQYcWkdyzMfoR/nIMQneJcxAX1QHb+ULbDs0BUtM5NFed9Siw0uVrn3
         myyQ==
X-Gm-Message-State: AOAM531XbIvITXmDbajhJuSMQlqUKTlnWNLBGxbm5jtmYWwanRjdSkdL
        sUBDhlLUqqlMnWCr4SMviIE=
X-Google-Smtp-Source: ABdhPJw1yooL3WnpgB0GBgiirWv65jvw2unZk8NDmuz3a+mmOb4bvBXLl9bIblVoxYWbNC3UIdRGFA==
X-Received: by 2002:a17:90a:9309:: with SMTP id p9mr408400pjo.37.1617647011795;
        Mon, 05 Apr 2021 11:23:31 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id mv9sm148818pjb.29.2021.04.05.11.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 11:23:31 -0700 (PDT)
Date:   Mon, 5 Apr 2021 11:23:29 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 12/12] ionic: advertise support for hardware
 timestamps
Message-ID: <20210405182329.GC29333@hoboy.vegasvil.org>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-13-snelson@pensando.io>
 <20210404234359.GE24720@hoboy.vegasvil.org>
 <58f57a07-ef4c-c408-652d-708647f44e3d@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58f57a07-ef4c-c408-652d-708647f44e3d@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 09:33:46AM -0700, Shannon Nelson wrote:
> Yes, I supposed they could have gone together.  However, I believe that in a
> bisection this will only slightly confuse the user space tools, but won't
> cause any kernel pain.

Bisection typically involves running tests from user space.  The test
failing or passing determines whether the commit will be marked GOOD
or BAD.  This use case is a real thing.

Thanks,
Richard
