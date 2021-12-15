Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E86475ACC
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243419AbhLOOm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242239AbhLOOm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 09:42:27 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02635C061574;
        Wed, 15 Dec 2021 06:42:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso19391038pjb.2;
        Wed, 15 Dec 2021 06:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=THFGjkGAOSNztSupFqn6DyyfL2bBvbOSLqsrZfKpQ1w=;
        b=XSzXED0pwDiKXU9s3kD5hYwqxy1Fj4lXYy1boz1BM70yDgKadH5xDq7l498KJFy0J3
         EZC5CmJmoSb9TnqDBueT+6dXDKCUFl5ivrgi9uMfQNdBMeTqi4PuWmlppsuOcZy4rMdN
         oqxoKEa+5tQ9IUfYVuKl08TB8kZ0h843Zx2RjABPmqRWJh5C9CkKmHaydahgDSNG2dZ4
         08FG19C9pAdqXmZmX6bqzirCaajybjqVmYVLydwQPRNxYh2hnuyDYWnwR+AMPx23qTHM
         giEI6fYd0O+uwCaf/p8nQlkvXiXxqGFZrKDEf8oQ8DJhplA3HMQ4pKgOsRJxoLrt9Lqu
         /AFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=THFGjkGAOSNztSupFqn6DyyfL2bBvbOSLqsrZfKpQ1w=;
        b=3hCz1TS5jNF0rfQ20yeDFFXqhZLYlIXkxTosQ5In1F5cyjoYZ/cSAD67MAD1WmFxXJ
         FCpF9oxXsGvjJgLrNdJ1eG+eHzdByZSa/flnZX+WwXpQdby3EpW7R87feSzumQadjmnu
         0fzzDEyOWvQkXryElW+w19AZb5wEVOto8peZRqIENmPItQKSQLxjgU1L85Z1mweJdgUX
         DOH4gGhzduwBB13KCa38z/i2DLTJ3UpUre7ncdu2zPffTeSgxSxcI3fJGMJx4efjtd0S
         /bGEP611x6UXU1tPIpRTcNT6lN194BYQgKlTw0pE/5M2p9qRw5aAWKdz2eegAD1boBmW
         oJ5A==
X-Gm-Message-State: AOAM532AiNurBtt5kNJBC7sPh97n6Z9iy1WGP4auvtAWF5AhhK4rdc3O
        OyyhvP70b6UKvrtJhaizzv0MBq2Hyik=
X-Google-Smtp-Source: ABdhPJwFX+ULXts6rLpkGNtQE66DON8ZMhhxTHJzo74t+Ui94dhnCV0NDGvM+jEbeqcUyqN36GE12Q==
X-Received: by 2002:a17:90b:1bcf:: with SMTP id oa15mr75536pjb.161.1639579346538;
        Wed, 15 Dec 2021 06:42:26 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c2sm3127205pfl.200.2021.12.15.06.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 06:42:25 -0800 (PST)
Date:   Wed, 15 Dec 2021 06:42:23 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     cgel.zte@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH ptp-next] drivers/ptp: remove redundant variable
Message-ID: <20211215144223.GC7866@hoboy.vegasvil.org>
References: <20211215060825.442247-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215060825.442247-1-chi.minghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 06:08:25AM +0000, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return value directly instead of taking this
> in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>

NAK.  The original version is fine as it.  Please teach your robot not
to generate churn.

Thanks,
Richard
