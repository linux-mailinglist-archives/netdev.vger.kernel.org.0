Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9D63B6B59
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhF1Xd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbhF1Xd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 19:33:27 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47481C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:31:00 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e33so16857243pgm.3
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dxVB5rfyATVJMNStjMKNCCRzrfmWo/zfa4NCkSwj7Lw=;
        b=lGkrpZDQdncYxeJNYLubeaeQb3NSpQbxhx2QGigqJ9VPZVE7/63LRXmW+D6DJ51Hac
         mMWDg4rUmeqxnBo2e4gxrfo9a5zZ1583tRa6Uk3eJuyZjT0PYS62dJq04bD0LuPWeaCr
         69e1+1jSVYJXjjXu7NvARhTbQIipNdkPJ3p8B/CH9uE+sP5XvczTcb0iuQXU/p9rKdVg
         ZlwKLQI8jIUHIN3WFb3PPTYVH2+9VT3tTsYPQ823+UPw2vmzI+u5WJZV+krvdOCeA9Pz
         dbj3MiljQxh/vV/WM4sNDwyhzTjNF2pAJKGLhZmacpWB7U3pnd032S5E9W1lBB44Ddso
         Mmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dxVB5rfyATVJMNStjMKNCCRzrfmWo/zfa4NCkSwj7Lw=;
        b=TP+0VUYiVhBM3+2OMYFH8hW9V0Ir+AgNzTH/v+B45URvgGurqmXAT/v3FSOqwdIRtx
         ZiCKKHxXc6LchbaYQrKsG/nAPUVD7mYDUPpvNxJiC+nk/H6TbbQC15B3drvnSyQRe4Kl
         TlkeASwrwqh4A+1t6AUpAdAZNEQT62muC081UFbXqFsbCu1+k3M+/AYEcagsX9kh3POq
         2Lgl0Yc9Wfcg2r6b2+ySMG/3kokZHU75yLRXxnPWV3fDgrYI5hiW7u07PQRtNz78cOl1
         yOSuUwX5y6q4xLKLLtgTu4KQ5nTqXoJuNtzoN6f7bicxHUJAVWs0KUGKoIA+RKHnvNPu
         XPyg==
X-Gm-Message-State: AOAM532Klz0NENcKV3wiidiiGKH8vAHpVM1zJsyyctmepAwx1Tqw4fBh
        avjtbORRo6ziKxyY1Bh7W7I=
X-Google-Smtp-Source: ABdhPJzc5VMYCU/7DLjCfP0FS1TJb1vTsf3VDc5btP91TCI+pU6H4gx/teQ6/IH2xRQ4h4miHq1eMw==
X-Received: by 2002:a62:b502:0:b029:2ec:a539:e29b with SMTP id y2-20020a62b5020000b02902eca539e29bmr27142687pfe.37.1624923059752;
        Mon, 28 Jun 2021 16:30:59 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p38sm13833900pfh.151.2021.06.28.16.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 16:30:59 -0700 (PDT)
Date:   Mon, 28 Jun 2021 16:30:56 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Message-ID: <20210628233056.GA766@hoboy.vegasvil.org>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 11:46:11AM -0700, Jonathan Lemon wrote:
> This event differs from CLOCK_EXTTS in two ways:
> 
>  1) The caller provides the sec/nsec fields directly, instead of
>     needing to convert them from the timestamp field.

And that is useful?  how?
 
>  2) A 32 bit data field is attached to the event, which is returned
>     to userspace, which allows returning timestamped data information.
>     This may be used for things like returning the phase difference
>     between two time sources.

What two time sources?

What problem are you trying to solve?

As it stands, without any kind of rational at all, this patch gets a NAK.

Thanks,
Richard
