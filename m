Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58CAF151621
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 07:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgBDGs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 01:48:57 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:35305 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgBDGs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 01:48:57 -0500
Received: by mail-wr1-f47.google.com with SMTP id w12so10570387wrt.2
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 22:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kAXZNxonL2vo5mn3WOyL1SDgpcuL3/WC4tHGYNoQMV0=;
        b=d/KZFCeiCZdQPtcj9G8N5DVQ6kXgN+7JFlSSrVqBG8c0ai7XBHuo0B+nct/SD1nOKh
         2Kc1/Ic+G4gU5vMnLTlIH0/+tzHpvX010nsjyRsdcEqKL9PhV3WG3SFpsbenbZE6xicX
         v2xycH5QjxAwCZWNXFotHkEwXG6vJu5DX1jLaAlUZJYWvSfKr5CebIpZtqmaZ7rsWMbv
         Pt59JTbjWkArYaVaSewCuXco7cCvxzuBkrFC++9BfrEcjA37u/0YflEWPQ+zUj6VSSfc
         f3XPQeCF8kpkCgtbG4/eZim91TD9n/YaCp9neacuAZ+xDqNzD+xhXtkY6Ba3/+tuSvCI
         i+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kAXZNxonL2vo5mn3WOyL1SDgpcuL3/WC4tHGYNoQMV0=;
        b=Nugxpf5kIFATQkvxs0yCeRqRNlruDPYmDknFl41L3bjO5VfQe/2SzgP71vR2cxLxfj
         yc5O/XhoQcMJEYhVAyqbFYdHvx2dsK6hza6vzJUhMfyR90NbEg5zaJ+oss/2iMtKAL1x
         fYvSAekQwFFdBgccM3BkRQbm36NX25HRvkHUcejGUuGg0hBvJzbkzsskyu4K/AShhkhy
         wPPP9BhmJ+uoGGxLgQJlJnMpn8cZ/SL4CNVmz1CE13F+0m3V/XD/BduTYpxMRT13wIX+
         BGmUcjZsKp6Y4gj+I1ER99rKFujSeVLURqJzxqAbB8bpfj/Lx+23EsgPjzMCSw5eFJTx
         U8Aw==
X-Gm-Message-State: APjAAAXSn2U9DXdKEcpEFFGTtSpBnmXADxYPoFhJJetcRksiDq65lqKt
        vfzpw5TtmdtJ7o85YEaIuPauQA==
X-Google-Smtp-Source: APXvYqwb4NZNOIRGxyQyRRUFv7hAT3ekkC210egylcZ1zTFHFkGBAIAZn9gcflFR/QlaoXSYuU1CSg==
X-Received: by 2002:a5d:538e:: with SMTP id d14mr21307843wrv.358.1580798935241;
        Mon, 03 Feb 2020 22:48:55 -0800 (PST)
Received: from localhost (ip-89-177-6-126.net.upcbroadband.cz. [89.177.6.126])
        by smtp.gmail.com with ESMTPSA id b21sm2477376wmd.37.2020.02.03.22.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 22:48:54 -0800 (PST)
Date:   Tue, 4 Feb 2020 07:48:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ray Jui <ray.jui@broadcom.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: RFC: Use of devlink/health report for non-Ethernet devices
Message-ID: <20200204064854.GK2260@nanopsycho>
References: <f8e67e40-71d4-f03c-6bc0-6496663af895@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8e67e40-71d4-f03c-6bc0-6496663af895@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 04, 2020 at 12:01:37AM CET, ray.jui@broadcom.com wrote:
>Hi Jiri/Eran/David,
>
>I've been investigating the health report feature of devlink, and have a
>couple related questions as follows:
>
>1. Based on my investigation, it seems that devlink health report mechanism
>provides the hook for a device driver to report errors, dump debug
>information, trigger object dump, initiate self-recovery, and etc. The
>current users of health report are all Ethernet based drivers. However, it
>does not seem the health report framework prohibits the use from any
>non-Ethernet based device drivers. Is my understanding correct?

The whole devlink framework is designed to be independent on
ethernet/networking.


>
>2. Following my first question, in this case, do you think it makes any sense
>to use devlink health report as a generic error reporting and recovery
>mechanism, for other devices, e.g., NVMe and Virt I/O?

Sure.


>
>3. In the Ethernet device driver based use case, if one has a "smart NIC"
>type of platform, i.e., running Linux on the embedded processor of the NIC,
>it seems to make a lot of sense to also use devlink health report to deal
>with other non-Ethernet specific errors, originated from the embedded Linux
>(or any other OSes). The front-end driver that registers various health
>reporters will still be an Ethernet based device driver, running on the host
>server system. Does this make sense to you?

Should not be ethetnet based driver. You should create the devlink
instance in a driver for the particular device you want to report
the health for.


>
>Thanks in advance for your feedback!
>
>Thanks,
>
>Ray
>
>
