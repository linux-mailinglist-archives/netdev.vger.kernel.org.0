Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF5A2A18A0
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgJaPvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgJaPvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:51:11 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CE7C0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:51:10 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z5so10695324iob.1
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZHpSZWtLu+4Qgs899xAMEyhlDHJmVLZvNnrAmCViJqs=;
        b=AxLC0XgLHT7dkSUM1bfzivl7+duwvOhJ6HN0Ln/GjZVgxFGMHDlR39dT6JKrxFIUSe
         zwwl8H8COnFiDHJZzgBG5Sq44ubw52d8gF6rXnjGzJtaDjTZEVO1RhVOwG+ZLiNZpfcD
         hL4+WX/4z73SMgGHmyicEVc/m81GtP6KG0iCWqvKDlZsB3HyJzTvj31r1TdaUPpnAaBa
         v7kAcPkRp4lYDJMItsG5I6I95T7QwbNrWpyCl0e3v0sUHNIQpDC+mYv9wQ88YFhHE6uz
         Kmcbg9iwmKaCiBxWVSQMdv2JkbsgS6UVszaNjZOZiVNVsKSudd0pohEYSIKcFQLEF566
         nQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZHpSZWtLu+4Qgs899xAMEyhlDHJmVLZvNnrAmCViJqs=;
        b=CJgWftDXKiN26H+LPGtg6I/66rErjBFdOw0VJgd13V/CzznlEtVRttdRY5ZuSi9n8g
         dR6EG1qWpNdIrpdscS26OJOmSoCCJ+RSikuigRxSjTNctC4Z3DSO4yr4XIy1Vn6ZLkk0
         gYP2AMsGKgynzlXvab9Gupgv43uDPmeVwOT3dXm3IfS9fiK3+8mAUrj19OlSifh3VMCh
         OSBhWMXn1Z2BhWg/I+Ojv2+lNkGAYTrROvQnmHSYHYV4iy41p62Z0NqgOmxlf5IyhVrf
         oLVw1+EaoTaWCJlMrzHfG/m+ZePhBin9T2zG/wfcaZjjf0bBPozyu1Fl01lR73dg0lhc
         mmgQ==
X-Gm-Message-State: AOAM533DR7FQEB4LAdOAEc8X4WE9GsFoi+W3mA7VrZo48lhSOm3OV3qx
        ySmaBc0Ys37FJOLiEBLvs5Y=
X-Google-Smtp-Source: ABdhPJyDuiVEMJK87DwJt+BXHV/GOLvUN1d1btRMHrZ1Zhz8cJ46w0I5H2V7r86XBcgZ0gfNRakp8A==
X-Received: by 2002:a6b:fe11:: with SMTP id x17mr5475534ioh.192.1604159470123;
        Sat, 31 Oct 2020 08:51:10 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:10cc:b439:52ba:687f])
        by smtp.googlemail.com with ESMTPSA id e11sm6579187ioq.48.2020.10.31.08.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 08:51:09 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 00/11] Add a tool for configuration of
 DCB
To:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
References: <cover.1604059429.git.me@pmachata.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0bdc221e-e9dc-347c-a2fe-40efe358da00@gmail.com>
Date:   Sat, 31 Oct 2020 09:51:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <cover.1604059429.git.me@pmachata.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/20 6:29 AM, Petr Machata wrote:
> The Linux DCB interface allows configuration of a broad range of
> hardware-specific attributes, such as TC scheduling, flow control, per-port
> buffer configuration, TC rate, etc.
> 

...

> The patchset proceeds as follows:
> 
> - Many tools in iproute2 have an option to work in batch mode, where the
>   commands to run are given in a file. The code to handle batching is
>   largely the same independent of the tool in question. In patch #1, add a
>   helper to handle the batching, and migrate individual tools to use it.
> 
> - A number of configuration options come in a form of an on-off switch.
>   This in turn can be considered a special case of parsing one of a given
>   set of strings. In patch #2, extract helpers to parse one of a number of
>   strings, on top of which build an on-off parser.
> 
>   Currently each tool open-codes the logic to parse the on-off toggle. A
>   future patch set will migrate instances of this code over to the new
>   helpers.
> 
> - The on/off toggles from previous list item sometimes need to be dumped.
>   While in the FP output, one typically wishes to maintain consistency with
>   the command line and show actual strings, "on" and "off", in JSON output
>   one would rather use booleans. This logic is somewhat annoying to have to
>   open-code time and again. Therefore in patch #3, add a helper to do just
>   that.
> 
> - The DCB tool is built on top of libmnl. Several routines will be
>   basically the same in DCB as they are currently in devlink. In patches
>   #4-#6, extract them to a new module, mnl_utils, for easy reuse.
> 
> - Much of DCB is built around arrays. A syntax similar to the iplink_vlan's
>   ingress-qos-map / egress-qos-map is very handy for describing changes
>   done to such arrays. Therefore in patch #7, extract a helper,
>   parse_mapping(), which manages parsing of key-value arrays. In patch #8,
>   fix a buglet in the helper, and in patch #9, extend it to allow setting
>   of all array elements in one go.
> 
> - In patch #10, add a skeleton of "dcb", which contains common helpers and
>   dispatches to subtools for handling of individual objects. The skeleton
>   is empty as of this patch.
> 
>   In patch #11, add "dcb_ets", a module for handling of specifically DCB
>   ETS objects.
> 
>   The intention is to gradually add handlers for at least PFC, APP, peer
>   configuration, buffers and rates.
> 
> [1] https://github.com/Mellanox/mlnx-tools/tree/master/ofed_scripts
> 

overall this looks really good to me. Thanks for taking the time to do
the refactoring.

