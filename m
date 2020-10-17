Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C797B2912AE
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 17:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438545AbgJQPe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 11:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438523AbgJQPe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 11:34:56 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6C7C061755
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 08:34:56 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k21so7663562ioa.9
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 08:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z9hsfHCe/1daCe1rvAUfKp4OGqcUMI5g2ZX7YXDspV8=;
        b=TlBVmRBPrRvWgLZukerSDf9vB2LOkmD/aPQo9Osw9fGbtDGj2NQapYcvPEgktIfsmk
         fcADpNv7ro9OIJWke8MeFk/8nUfdiECC6Fk0sxXRjrNeYKr0dc0gjFuSPgL2kBBgySVc
         ij/n09LMoJaiLZ6gLec9HfwfREfmj8g9UOPpvBB3pro/GebKToy/fjGZIcPoDrWMo8Vi
         BEico42nTM15EhlTSr/NrVBi0jL0gVE00p5K5KTS5crioNeBju4K29ykK1lR3KDOvgDo
         JM3ZcqwK/Wnwqwi4Qo56QeNVRl3Xv13aJNVqwaC6MCv0VhL4VIVRLpKPbNRKzyPyFbC9
         s8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z9hsfHCe/1daCe1rvAUfKp4OGqcUMI5g2ZX7YXDspV8=;
        b=UL3S/fQCrBnD7uaYLZ5U1Qaoma/pa+a6py7HiueqX7L9WLHZM3jXtxmvqF9WOQLecR
         dkikL7xPcosBYJAXexUWowdqz7XqI5ZOgZ8CtAj9JSxPB/8lCJ51idhYaU8VAsBsT1qg
         3HgDPUzJENA05+WrL5tDMXJowt3pqg6TPz5o6LAH8RcwSNwzzRcXCije1zWnCuloAEJt
         PtZ9udgrcqpqv2xosw6EKw3yl6iDANvivi02FcuFpK2QiuwwDTsWBJxpf8GyuheC9MXe
         bXQMNzk6ddzsERVNqid2ej3H01P6eKVJVQ0OJt0CVcWOLQKOLcPw2OsUE0CyuU/kU0Aj
         ZfLw==
X-Gm-Message-State: AOAM533SYiQIeCUsRpER0PPlLqA9ySi4tLAG9q8MrEnU+ZQ/Md61Eaee
        nmPFbmFPk/ln0F87xFAkB4rs5XOKvq4=
X-Google-Smtp-Source: ABdhPJxWZvefYMJFXa1dX+8OdbwIQ6BMz0q6lDbp6KtENfHZTLSSc7WcAj7hM26ibot2bgw62wbnrg==
X-Received: by 2002:a05:6638:1189:: with SMTP id f9mr6596205jas.10.1602948894935;
        Sat, 17 Oct 2020 08:34:54 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:685f:6f0f:2fad:a95])
        by smtp.googlemail.com with ESMTPSA id c18sm5756883iod.28.2020.10.17.08.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 08:34:54 -0700 (PDT)
Subject: Re: [iproute2-next v3] devlink: display elapsed time during flash
 update
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Shannon Nelson <snelson@pensando.io>
References: <20201014223104.3494850-1-jacob.e.keller@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f510e3b5-b856-e1a0-3c2b-149b85f9588f@gmail.com>
Date:   Sat, 17 Oct 2020 09:34:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201014223104.3494850-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/20 4:31 PM, Jacob Keller wrote:
> For some devices, updating the flash can take significant time during
> operations where no status can meaningfully be reported. This can be
> somewhat confusing to a user who sees devlink appear to hang on the
> terminal waiting for the device to update.
> 
> Recent changes to the kernel interface allow such long running commands
> to provide a timeout value indicating some upper bound on how long the
> relevant action could take.
> 
> Provide a ticking counter of the time elapsed since the previous status
> message in order to make it clear that the program is not simply stuck.
> 
> Display this message whenever the status message from the kernel
> indicates a timeout value. Additionally also display the message if
> we've received no status for more than couple of seconds. If we elapse
> more than the timeout provided by the status message, replace the
> timeout display with "timeout reached".
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> Changes since v2
> * use clock_gettime on CLOCK_MONOTONIC instead of gettimeofday
> * remove use of timersub since we're now using struct timespec
> 
>  devlink/devlink.c | 105 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 104 insertions(+), 1 deletion(-)
> 

applied to iproute2-next.

The DEVLINK attributes are ridiculously long --
DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT is 40 characters -- which
forces really long code lines or oddly wrapped lines. Going forward
please consider abbreviations on name components to reduce their lengths.
