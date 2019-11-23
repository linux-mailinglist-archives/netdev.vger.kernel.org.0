Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709FE108040
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfKWUMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:12:00 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:36433 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWUMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:12:00 -0500
Received: by mail-pj1-f45.google.com with SMTP id cq11so4658961pjb.3
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2LwGmjdObMGCnA4E6/PwJpJ5df/udZNVgfH7GkGh/oc=;
        b=Q0EmNISSInoOvhlmikNTjum3LlD9Bq/qK0AvznuuhFB4UyNQA0dPlGO7J86G07pie/
         sIMJAFma09qhXr0aglmPxsxyg8tC6Ns3BywWGe1E43Vnd4GeSc7KL/RQw8DlpfV/HpeF
         /od13j4QJtiJrfnvIs07RkcP/LO9h4FoZ52tb4FG7Xhj8QpJCTvIR2aEjniopWT0GS7C
         Y3g39WvUYAu9w2uA7Gm1P5ILB87vHUAraiv4dQYRLOV+ArhXXrbP4GazOmmAIOaq4Pq7
         IDXU11X2AbVE2P7cgm7+E9qMIC7hz7A4x566XYb+PHhZQsNCZz29C10rVZ3alFntjFK8
         McyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2LwGmjdObMGCnA4E6/PwJpJ5df/udZNVgfH7GkGh/oc=;
        b=lYrQSUrJI6rYHbDK14T4VqHC/CcqN5Owm0+ucSYYLvNbt7XZk0OYC1AOag7kTFSzTy
         nfSkgIaZ5PeK2p2ZsBl43oUVQpXFFChCjdSFeCF9zN5iFt4AFmePYBpMVW6bcr8UyKDk
         mMaYl3Y1crwxnSsntrbSpzvNxLJM6k+YO9gvUDgiLg74TjSLCMwusZnp7YQcFlSC2f2t
         GcWj0T5+kAJJwAAk3F9nvpQfpcNplgwJH7g43vYsr3j7stra4ZC/C8Y4MpqRZKZv1FBd
         pKC+xishDqfCNeL7tvdHgeyqXUdkuxdA1ONPBE8KglnQelt1iSkgA9+tsKO63uh6t9k4
         g8Zg==
X-Gm-Message-State: APjAAAWFgGqt6dbhbCHVMJD+dxYFBpnhxLEuVyErI7MOLKVRog7wZli4
        343e+URrWHXMg1hFEaI16cLMn2M+7GQ=
X-Google-Smtp-Source: APXvYqxQY37u3OyU+rrvyD9DzJNHqrJwrpPwJ556Gw1Wf6vlpWctZBQ9v1e6FPtiVFL6DkvcDlKuow==
X-Received: by 2002:a17:90a:fc91:: with SMTP id ci17mr27357513pjb.13.1574539919455;
        Sat, 23 Nov 2019 12:11:59 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id s24sm2795197pgm.79.2019.11.23.12.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 12:11:59 -0800 (PST)
Date:   Sat, 23 Nov 2019 12:11:54 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2019-11-22
Message-ID: <20191123121154.685d0f1b@cakuba.netronome.com>
In-Reply-To: <0101016e9468c9df-b9fff56f-0e3f-48d1-bcff-e6586926e7b6-000000@us-west-2.amazonses.com>
References: <0101016e9468c9df-b9fff56f-0e3f-48d1-bcff-e6586926e7b6-000000@us-west-2.amazonses.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 18:38:46 +0000, Kalle Valo wrote:
> wireless-drivers-next patches for v5.5
> 
> Last set of patches for v5.5. Major features here 802.11ax support for
> qtnfmac and airtime fairness support to mt76. And naturally smaller
> fixes and improvements all over.
> 
> Major changes:
> 
> qtnfmac
> 
> * add 802.11ax support in AP mode
> 
> * enable offload bridging support
> 
> iwlwifi
> 
> * support TX/RX antennas reporting
> 
> mt76
> 
> * mt7615 smart carrier sense support
> 
> * aggregation statistics via debugfs
> 
> * airtime fairness (ATF) support
> 
> * mt76x0 OF mac address support

Pulled, thanks!
