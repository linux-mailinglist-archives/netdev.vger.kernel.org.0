Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2C645F27F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbhKZQzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350033AbhKZQxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 11:53:47 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF008C061A30;
        Fri, 26 Nov 2021 08:36:11 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id v19so7029727plo.7;
        Fri, 26 Nov 2021 08:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UIAMYZphiediKm1iUagoWKS9HwT1nKaBzibHVok6Up8=;
        b=SMhfKvTiH5Xk52WFxWryJoxwnQPSCEHuGUEbzDYp+ioWIltf5bJ1ea7oUPlsjLUN5F
         +/v4hC8G0iaiKx9UhiMvhw3/4/av72R27S3KdkQe1KDW9w8caf3So+6c+f3Lcg4Gy+D1
         ZeW+w6vGhHkZa6t3tExnayFOUKNCWeWOKYZTzuM5ClpQvxGLZaw2r+q2VngVZzEoz0zg
         etvMmHmRlU0MKRoZoXAMSoxRjbRLTyOweK+MJngPVAh8pNxuxuT8dpbmBmXPxvPY64Re
         huf7kA5WOU3W9baZPFLugQCuI9RsM6adX53yf/0D4w75L6jqbrF2VjKVeKMH8vW9RyIo
         IKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UIAMYZphiediKm1iUagoWKS9HwT1nKaBzibHVok6Up8=;
        b=JaDxnaRzQWHXpLBAeKVgrl4Y6XI5PyUzTlBpkw68FhXkUuRoru+kHgElh+tRnn1rqJ
         r/XReTlU61Eyj0ftNPsjenxonszh+KvjTfE/n6EjGqMEKtVDDkHofklgw3z4affBhY9u
         Sv1O8rNAaVPwNS9u6hWRMveGtRrU/UAxhmX/VbbRvoIh5RQXrMMLOEWb3jnxOH5bBUat
         LfcOfP9DAkB8HqoXslwjGatGgsYIgQ34dFuqM8XWgh1XXVvqtbrVWD7RzetBoj1wiMhi
         22Q6vP01K2hbWgcTnNW2h0j0537r+10VADWBdYbAgFZMArmg5RV10EiDYW+gbPdyIXgt
         UPSQ==
X-Gm-Message-State: AOAM5334vrlKr5yJiu0YdyIjlDlm2DpSOOk/cFKxZCpnCVx0btouKO7z
        zYTWZIY4tyS8dJ1xauOAgoVJhikOxJo=
X-Google-Smtp-Source: ABdhPJyYOtPbS8kYXbeUx6unszpl/1+UzaDwRXbLf7EVVLcThBnfE12piJ69tltyiYbJ5B/PeO93Xg==
X-Received: by 2002:a17:90b:4c51:: with SMTP id np17mr16706315pjb.213.1637944571455;
        Fri, 26 Nov 2021 08:36:11 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a23sm5465827pgl.37.2021.11.26.08.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 08:36:11 -0800 (PST)
Date:   Fri, 26 Nov 2021 08:36:09 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net] ptp: fix filter names in the documentation
Message-ID: <20211126163609.GB27081@hoboy.vegasvil.org>
References: <20211126031921.2466944-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126031921.2466944-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 07:19:21PM -0800, Jakub Kicinski wrote:
> All the filter names are missing _PTP in them.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Richard Cochran <richardcochran@gmail.com>
