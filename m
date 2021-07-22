Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1863D1C1C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 04:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhGVCLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 22:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhGVCLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 22:11:43 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC72C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 19:52:18 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so3992781otq.11
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 19:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0nsyexf5E/9/BZ7RS+9HYAQFZhWchA8hAcqQ6FMD5hk=;
        b=bHwbo0HEXR0nVkNp9y5f4VvP1CCKDqvhzXFe2xguEXzZZ+pZeCgpjPWv0uc66DSexX
         kJJ1Zr6RpiCmPfyMPy9z1WtDqdalB62zrjPClfoKxVy1iOWtdAmpTih9W2SwHwiSWW+k
         v9zZdoS/P6dMlK/t/oNJT5hasBHnQJNkVoTSYJ9xmcUzt0oUgJOOqWtU+0dqy1Rs2RVw
         5bRNg731/DCD5eO16zwrwFZuYNr/0tM9BSwhq+pshwmQx9Iqdp9hsPSWGNJ9tLYamoY0
         c36T0vSBB//pxN00qK987uUgEgk3hnnvNMvA+IfO6hVNDv+us3n9tzaCZ5Zfpn59kk3e
         1GiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0nsyexf5E/9/BZ7RS+9HYAQFZhWchA8hAcqQ6FMD5hk=;
        b=rtLMhnPYSX+AX90dAlKywixEh7KNCQfZtO2xC7JW2QzC8/Ps9ucR51iyGlGCB1cWw7
         ZlQKUAMVbuboKj0b/vYpxe/2U/huC6EgQZxivlfPF+aF3RWODBvOhLpHnURQPbsQHTBG
         WE07eKa71hbA5jcHsLMAMpVx3n1Qrg4xPzhh36PSNjHFwlnzJGLtTpaGiB924JEaahXz
         UcKBjYWn1cgTf1FtL5kGOqVW8pTowEZGFRg3R98PNMR3unHWWOyrWC8y8aeRv/i+EiBC
         rDvhTR/4PAxryN2uRYgjwm6h6/oxuZNwqfzigAAk55ByK7k7NR6DafChZBJySYKm4ZSh
         Anyg==
X-Gm-Message-State: AOAM533vuoRXpz1+bDB54HYRTYUlVfUquAyp4gfLCsHTStseISba580W
        BiotIp37francxLt5lh2ok4=
X-Google-Smtp-Source: ABdhPJxGmo3I6pg8bHu0zCk4W91GBQywcGBHUhOJnh+IBqTf6cYuDgljddKYdGm5JD8NC1iddyH+OA==
X-Received: by 2002:a9d:ba3:: with SMTP id 32mr27657005oth.126.1626922338049;
        Wed, 21 Jul 2021 19:52:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id l196sm3930464oib.14.2021.07.21.19.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 19:52:17 -0700 (PDT)
Subject: Re: [PATCH net-next v5 6/6] selftests: net: Test for the IOAM
 insertion with IPv6
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tom@herbertland.com
References: <20210720194301.23243-1-justin.iurman@uliege.be>
 <20210720194301.23243-7-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <631216ff-c8ec-b602-e1ce-95808dd92b01@gmail.com>
Date:   Wed, 21 Jul 2021 20:52:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210720194301.23243-7-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/21 1:43 PM, Justin Iurman wrote:
> +run()
> +{
> +  echo -n "IOAM test... "
> +
> +  ip netns exec ioam-node-alpha ping6 -c 5 -W 1 db02::2 &>/dev/null
> +  if [ $? != 0 ]; then
> +    echo "FAILED"
> +    cleanup &>/dev/null
> +    exit 0
> +  fi
> +
> +  ip netns exec ioam-node-gamma ./ioam6_parser veth0 2 ${IOAM_NAMESPACE} ${IOAM_TRACE_TYPE} 64 ${ALPHA[0]} ${ALPHA[1]} ${ALPHA[2]} ${ALPHA[3]} ${ALPHA[4]} ${ALPHA[5]} ${ALPHA[6]} ${ALPHA[7]} ${ALPHA[8]} "${ALPHA[9]}" 63 ${BETA[0]} ${BETA[1]} ${BETA[2]} ${BETA[3]} ${BETA[4]} ${BETA[5]} ${BETA[6]} ${BETA[7]} ${BETA[8]} &
> +
> +  local spid=$!
> +  sleep 0.1
> +
> +  ip netns exec ioam-node-alpha ping6 -c 5 -W 1 db02::2 &>/dev/null
> +
> +  wait $spid
> +  [ $? = 0 ] && echo "PASSED" || echo "FAILED"
> +}
> +
> +cleanup &>/dev/null
> +setup
> +run
> +cleanup &>/dev/null

Can you add negative tests as well? i.e, things work like they should
when enabled and configured properly, fail when the test should not and
include any invalid combinations of parameters.
