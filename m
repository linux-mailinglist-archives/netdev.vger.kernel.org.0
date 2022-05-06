Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF2E51CF69
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 05:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388537AbiEFD3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 23:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352476AbiEFD3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 23:29:49 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C16A5A15A
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 20:26:08 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id a11so5234170pff.1
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 20:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9km1PlRIKW7YuCltBXEwS6g9xW++l5YU05wV6gL0Yxc=;
        b=NWVSLlbLwYYrBz/bbA1PkKha0EXTERUYL5QeESPBG9Amnz16p+fdyzLE4NHBHLcDWZ
         EzVV+9s4YNTzh8owtcTeRO/ySsgGsq18KkKEXnloekK3v6BT0TC4gfOnJk6RfbpHnk8d
         hTmTAYxnYBXXfT0JZjt5zQv96hmyEM0/F2y1t01Jqvf6Nn1IQr9GaTtp3znpNu22x+8C
         /3tUOGfcS5Z6iYn3C6W1Q6BwXzuEp1y1P4kwj9lFIiT7mDy9hBrKUQnNT7iRTlDpLUjk
         DALFlNW/5Ig4F9QUZslNAt5T+3h1CSMJumTJR9R36vEXfp4bLNVW1km0LrYwRgbUofmg
         urwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9km1PlRIKW7YuCltBXEwS6g9xW++l5YU05wV6gL0Yxc=;
        b=qyHXtXB1YLZG1bcWLaoMaYpt88fBGVezEnm6sqG/6QGLF40jxIajsSqynZ+Qgevizl
         xSKKQwvN403cte75co6IE+OnoYKgnEuHnPvD2yMaLyvuoe+W7Y8LgHjSnW/PdNPAw0ea
         AYZ67sOBvrfsVkoTl9/U7U/67qjv8ETtOrptWiZaeYeAwYYvhE8qACACoBCN4g0pIr3g
         8r0htMy/CwQr1Uub/+ZjzkrkTU71sMrGpQOPCZSeAx+YxNElgAPYKcvKTPuw2iT+NzUr
         fJkIp11jiwnrN8I7SMI7lijkEFIzqYj/h2vL6mV72AXEdMMGBSdEJFr4u8X5JkF8ixx9
         sIaA==
X-Gm-Message-State: AOAM5322iFOZI2pE7AMUx00bcHMFlVBt2w3FjjDFs1sD6n8Hjrr8yCl8
        tYj4uDkwSZjQj4dszKOywtFuBEJ414Q=
X-Google-Smtp-Source: ABdhPJz/VsXfmhVrRgx8Kwqv93sI7OXVtlFV8KB9+ROyWRgpmTUFly4CxeZCpdRVyUKI+eJlHKPc+Q==
X-Received: by 2002:a63:cc4f:0:b0:3c5:fc22:f6a with SMTP id q15-20020a63cc4f000000b003c5fc220f6amr1099286pgi.67.1651807567632;
        Thu, 05 May 2022 20:26:07 -0700 (PDT)
Received: from [172.16.0.2] ([8.45.42.186])
        by smtp.googlemail.com with ESMTPSA id z12-20020a63330c000000b003c14af50629sm2045791pgz.65.2022.05.05.20.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 20:26:06 -0700 (PDT)
Message-ID: <9278f614-9994-362c-75ae-5a0fe009ef01@gmail.com>
Date:   Thu, 5 May 2022 20:26:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH iproute2 net-next 0/3] support for vxlan vni filtering
Content-Language: en-US
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        razor@blackwall.org
References: <20220501001205.33782-1-roopa@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220501001205.33782-1-roopa@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/22 5:12 PM, Roopa Prabhu wrote:
> This series adds bridge command to manage
> recently added vnifilter on a collect metadata
> vxlan (external) device. Also includes per vni stats
> support.
> 
> examples:
> $bridge vni add dev vxlan0 vni 400
> 
> $bridge vni add dev vxlan0 vni 200 group 239.1.1.101
> 
> $bridge vni del dev vxlan0 vni 400
> 
> $bridge vni show
> 
> $bridge -s vni show
> 
> 

hey Roopa: sorry for the delay; traveling. The patches have a number of
new uses of matches(). We are not taking any more of those; please
convert to strcmp. The rest looks fine to me.

