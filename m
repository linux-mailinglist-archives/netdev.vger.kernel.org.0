Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC81610B076
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfK0NmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:42:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46646 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfK0NmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 08:42:09 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so23300177wrl.13
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 05:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W7yIQV6V/bf7sevm1SN3yW0+czPNbmjKsDOahvQWvVM=;
        b=Dj65gfvoHl7ClGX7UV3NEqc1b+dX5ch0KKZMWpF4li3ZIjQIx49GLUHMhwyborQGPe
         Fs+Ug/x8/pwg1Wct5wvdTMjWD5Ds8DR3I1bXxMjjDG2bMarzidzEeXluj7hVEzzH1cCb
         fB+oGse7Qk6AHmnQh0wv8xPHuY1xSs5nV7gKnyEp1bqL9u7EKuTT/fvdQXZIAf7yWpOi
         ZqQ4dCVo/NLVzdPy9DEFDJvyikzLm/mDoBeOucD1sgxRFL8s2eupijgJHLNEWUXo1UjZ
         S2PQfwvSinK+yRgPHX4OrrRdk1emQxju579fGF27+eBkRawilnfHdXdwEqO5UvXBnaf/
         hf4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W7yIQV6V/bf7sevm1SN3yW0+czPNbmjKsDOahvQWvVM=;
        b=RXAu8hbvvpvWQOeUi1jAF4n1xhZeav/5WiJygi8t3rg5YG17GVOIZ5kmmNd9kOvdzQ
         sSeI2m9oeuYBDu+My6r+IMXT+Rl7bp+AS9DbWWyuO3BCyfScGJJ5SaBkaZpaWAd3SvVR
         /Y2/Do2KEDK7sgbOmT4VVRRLGRcDd01rmZdB7pH/XMAuvxuSO1zMMlfktc/BOkZfe/iN
         /twauqgqxFRroQGyaBF043GJfo3VsT6i8wgezNIaQnr0jE/p58xagVWIfo3OS5aLU6Sx
         7YAZODLyLQ7dx/LSS4hdPWuhKB/SZJh8hV+X1bkNk2F1M4xwyfJtl9tH6xj/4HMXoQVB
         52/w==
X-Gm-Message-State: APjAAAVeKUqSFtgoTOsLUxlSjdBNqSzykFQ7QDG4wkkgci7887cYofkc
        2YfjcxkVy5XQ9Fmn6BDuTf4ujkEiEss=
X-Google-Smtp-Source: APXvYqwtS3mo6gGIDL4ibCbiPyfFDjdeGMXvoa4pTYx6YUYjZ3vTZYolWhy19tRyi+OINwDRsgIwvA==
X-Received: by 2002:adf:ab4c:: with SMTP id r12mr41816087wrc.3.1574862127846;
        Wed, 27 Nov 2019 05:42:07 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id w10sm6602596wmd.26.2019.11.27.05.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 05:42:07 -0800 (PST)
Date:   Wed, 27 Nov 2019 14:42:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Koukal Petr <p.koukal@radiokomunikace.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: compat/devlink/mode is not present after installing
 linux-generic-hwe-18.04-edge
Message-ID: <20191127134205.GA2137@nanopsycho>
References: <10ad0e50-5753-cd42-e26d-d635a263084e@radiokomunikace.cz>
 <f9619b66-da85-a1e3-941d-dadde39718fc@radiokomunikace.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9619b66-da85-a1e3-941d-dadde39718fc@radiokomunikace.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 27, 2019 at 01:29:20PM CET, p.koukal@radiokomunikace.cz wrote:
>Hi,
>
>compat/devlink/mode is not present after installing
>linux-generic-hwe-18.04-edge
>
>After installing linux-generic-hwe-18.04-edge
>cannot set "switchdev" for vif interface when configuring asap2 SRIOV
>networking.
>
>Previously, /sys/class/net/{device}/compat/devlink/mode was available.

Hmm, this smells terribly like some out-of-tree thing. Are you sure you
didn't send this to a wrong mailing list?


>
>
>Thank you very much for your help.
>Petr
>
