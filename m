Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C8FF1185
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 09:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbfKFIzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 03:55:36 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56108 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbfKFIzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 03:55:35 -0500
Received: by mail-wm1-f67.google.com with SMTP id m17so2354122wmi.5
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 00:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h6vSALk2sIidp7n88L5dCqRoAaDIlwVzuVc3D3Hxuwg=;
        b=HcnrE9U1GpQ53tzOCe2rK8qD33v/LmTJTg91EbD9ioQ2FYsF/5mh6mOnbT+m1jsvDk
         Ie2KI+KbUxGOVmMdPG1Spk8ivL39mIeuinOHDDP1v2mHL6BQIEs8Pc4dmqQSABU8jAW5
         59+qm16c86H0ecYIG9yTZeqatXJuyrd97iPgvrfN48FfwQYt3VYH7Xx9NqMmiGmuyMA8
         qq+qkNO3XcxfOjlxunLD3hwbeOJ4zVIbJXd+c+wx7QaJhly7dm/JZS5+ID8hSlOiIXDr
         uMIfIuQcPsGBY66m9LjJlswTfl4roHatnCH/s8O2W/pEdF7Pj5ndZ1Hlmlqay5CIy3V0
         eRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h6vSALk2sIidp7n88L5dCqRoAaDIlwVzuVc3D3Hxuwg=;
        b=fc65u7Mr0SMuEOzD5fQCvJrhqQLDcvFVCBKY6qV9slb7Hm69ueXi7AmTsqZmxTlsuS
         EmjKI5SKyzbBngbDeRYiMEwVPX31q93NTZZI1sQzloh8xDzIdEr51p/uo9YlmAag03uy
         F4rOf827csGSelQqHdUVq6WvlPMICb99XILGnKptyU07IFv5NraZAflgbwIN8HL5vNIw
         UKEN83lFiaVVYOmj0KfnktXV4YGEtwXxKAZbGhHtE4ZrxfnQ9TdG2IhFl8ezPjr90QNc
         JaKcTAajtcJGyn/LIHq8pf3MDiY5PrJlChNkKkwC6ZGeNccL4vPxGIVWv/Mw1dkrkrjA
         Tvng==
X-Gm-Message-State: APjAAAUoAVUdhYQaC3AyuNKZiyxtCYbD7I9QA4Au37HgjTNqEOtg2L/N
        ptnt4rXQ43eIExjEfRSz+bVVfw==
X-Google-Smtp-Source: APXvYqyZCMtjvAcjztOLKuP6IYPADmw6fO28IiqjhicSosmRA95Q5wTXe8uHvKkIFr8EIWZCy6HU7A==
X-Received: by 2002:a05:600c:3cc:: with SMTP id z12mr1464523wmd.151.1573030534021;
        Wed, 06 Nov 2019 00:55:34 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id 76sm2415953wma.0.2019.11.06.00.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 00:55:33 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:55:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, daniel@iogearbox.net,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next 1/2] netdevsim: drop code duplicated by a merge
Message-ID: <20191106085533.GF2112@nanopsycho>
References: <20191105212612.10737-1-jakub.kicinski@netronome.com>
 <20191105212612.10737-2-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105212612.10737-2-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 05, 2019 at 10:26:11PM CET, jakub.kicinski@netronome.com wrote:
>Looks like the port adding loop makes a re-appearance on net-next
>after net was merged back into it (even though it doesn't feature
>in the merge diff).
>
>The ports are already added in nsim_dev_create() so when we try
>to add them again get EEXIST, and see:
>
>netdevsim: probe of netdevsim0 failed with error -17
>
>in the logs. When we remove the loop again the nsim_dev_probe()
>and nsim_dev_remove() become a wrapper of nsim_dev_create() and
>nsim_dev_destroy(). Remove this layer of indirection.
>
>Fixes: d31e95585ca6 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
>Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

lgtm
Acked-by: Jiri Pirko <jiri@mellanox.com>
