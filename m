Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C191D75C9
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgERLB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgERLB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:01:56 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB639C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 04:01:54 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id m185so4957625wme.3
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 04:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BVl5olhVPmjYidcFxBvUHyoAkX9xQJo2lm8D8haMCqw=;
        b=xVfTWbFhXJbVCfOwkx5Xvw2ykpaCzuynd1veG/v9erWqevxr0YaPYZd59I9y21AWfU
         YL3MHSLke5iBEDy+6gxjlBb1uU9HuCaz2AfSbAh5TAGOL8PM4ZcnLp/auuSN7ZWryyV+
         j1aMmjriov6DDPvkpmZNFNo8VI7pfOsRKaoph+Lz3rRz//bNkranPV9J8x9K1sJ5CmW/
         LALDHK2/Y0R6YOLyoLfjs+aq5Kl4lTKMz18kzNSTL2UTimdhPXCxZsyo3XQGiOlUKbjE
         f6Mk7tP+kszUwg2zdZJAVjPgkQk+6X9OHHlqE4BdIPFnb+LTE6vRhW4XyfavkJqDyScz
         u90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BVl5olhVPmjYidcFxBvUHyoAkX9xQJo2lm8D8haMCqw=;
        b=iO4Yu2ds2tBujZgox4NM1QKul7acVhTr7ktVrEW/chPC4DbVKXovdaGZK7b3pK3JeO
         ANqYt9kO3c58CIqEW92DzHj20CoxwTNV3NdR4G1BqNUF10e8cnqwZ6P9MdJItcR8HT1W
         PpvEpQm+1Vhl+cLg1atwlRPqBm35nxooCpiz4CvwPxZsgKcuufm3hipk6/1l8mHnh8DG
         ++uBZj1RO4H6vaRCSIoRyoToSPQHvzTGm0XpREnqUAlES8fweQSUCWhcEnH4hG7bidEZ
         2Q5C/jG5jbhz95JsgN/CckCaFLzhPGp9s5JGsm0kahLdvfT2/f8wGGGbSisjeAAlIM9P
         0KPg==
X-Gm-Message-State: AOAM531nPLcvcnwgrlpNJzvdDaBfiV38bXC1zH3WKcOExR7AJLubP9MD
        epuLQdRYY2b1waYMFYTAgT2esQEH/2w=
X-Google-Smtp-Source: ABdhPJxl7eAxmizzCaGJwkN1JKmC4Tnw+k2cEL0w4+zFXovqkGs8pyxUu+QonNuuGcVAHjmSxUPQiQ==
X-Received: by 2002:a1c:720d:: with SMTP id n13mr18790995wmc.130.1589799713600;
        Mon, 18 May 2020 04:01:53 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v126sm16940374wmb.4.2020.05.18.04.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 04:01:53 -0700 (PDT)
Date:   Mon, 18 May 2020 13:01:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
Message-ID: <20200518110152.GB2193@nanopsycho>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 18, 2020 at 10:27:15AM CEST, vasundhara-v.volam@broadcom.com wrote:
>This patchset adds support for a "enable_hot_fw_reset" generic devlink
>parameter and use it in bnxt_en driver.
>
>Also, firmware spec. is updated to 1.10.1.40.

Hi.

We've been discussing this internally for some time.
I don't like to use params for this purpose.
We already have "devlink dev flash" and "devlink dev reload" commands.
Combination of these two with appropriate attributes should provide what
you want. The "param" you are introducing is related to either "flash"
or "reload", so I don't think it is good to have separate param, when we
can extend the command attributes.

How does flash&reload work for mlxsw now:

# devlink flash
Now new version is pending, old FW is running
# devlink reload
Driver resets the device, new FW is loaded

I propose to extend reload like this:

 devlink dev reload DEV [ level { driver-default | fw-reset | driver-only | fw-live-patch } ]
   driver-default - means one of following to, according to what is
                    default for the driver
   fw-reset - does FW reset and driver entities re-instantiation
   driver-only - does driver entities re-instantiation only
   fw-live-patch - does only FW live patching - no effect on kernel

Could be an enum or bitfield. Does not matter. The point is to use
reload with attribute to achieve what user wants. In your usecase, user
would do:

# devlink flash
# devlink reload level fw-live-patch
