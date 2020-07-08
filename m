Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A05218C76
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgGHQAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730179AbgGHQAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 12:00:53 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623D5C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 09:00:53 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d27so34886111qtg.4
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 09:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r2kAm9ImfAoL9iHCU1qn7FVfAasZNPHmlDTAjkYz4NQ=;
        b=ikUGGiA9Ps6CZTdDiszDkrI/ENUgmRVLHt0ONdBZ61GJTSG/4j29M5gD9+l1o9KkWf
         UwY3Xz1LRpbf49mU/4Z87evyEtkp40kUwo60V6qCbOe8nNz/3KKA6TySOzSZS2KINLh3
         u9tVjlAoO4s0lgm23hSeVbbqbJ8EUlcWM3yg0AerLYNl846e3U7A+C+JCCUWP7R5k8Nk
         Cl3s8/Xj+3rlukYKSyqiv9dHmnVG5wBApfOv7gte+q/dYdeM4q/O5GMLCCmyI/y3XomI
         yjXsGuDzMaPvBPAfZBEKrwsZIlh4dVdTm1xljAFeMFXiSQy0O3xzcF84WeowjXa1Tyh+
         +W1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r2kAm9ImfAoL9iHCU1qn7FVfAasZNPHmlDTAjkYz4NQ=;
        b=LAf1YBdPgTDoP8r0XN0brk2ZJeyyDL3y+58aYHWYPjhxOD/KvbjWCv7JLLh87+g+gS
         C1YUAbFWDdrWWczmwVOsWOpsUT0vAgmzzHsgHHSsQc0/5jefiv4oNTVHzq8ztCpMRmaR
         mB1DhH3NnQ/lFhJGgFhlEcKV8GkQyRvJbYLY4XUTTNmgPSXOclJG8uVzUZPcdke8Jn56
         D/gTG0iWZw5tVRd+T6OGYuQmzMZPsbMjN5EZz9fFZpJAdhNyx35NuFJ7oqPCqqjY8CoC
         2F5ZlJ6QCW02v/TYshJ7O5gOiqIObbJzIGdbBDBRBtRi0blzSxB5wbGl0fXlp8UkzCvd
         1+dQ==
X-Gm-Message-State: AOAM5334kiT+hOtKQb6PEbOfhRscB9qUIy3aYU7kuoRu/JSOgHiUKI9h
        j1ymuBsp033GaQgRojDWvUU=
X-Google-Smtp-Source: ABdhPJytkksOsqqn9E1Bcu1JmkyJ4RAtQnpiFwfYyifgnYCYAxuoF0n6b5lmF30C7sxxqZlu5C7nEQ==
X-Received: by 2002:ac8:1a12:: with SMTP id v18mr61693168qtj.347.1594224052702;
        Wed, 08 Jul 2020 09:00:52 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:35d7:e173:4535:718f? ([2601:282:803:7700:35d7:e173:4535:718f])
        by smtp.googlemail.com with ESMTPSA id y143sm252651qka.22.2020.07.08.09.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 09:00:52 -0700 (PDT)
Subject: Re: [PATCH v2 iproute2-next] devlink: Add board.serial_number to info
 subcommand.
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
References: <1593416584-24145-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200705110301.20baf5c2@hermes.lan>
 <CAACQVJogqmNG_jb0W-gV23uWTcpitrx=TF9asZ9s0kfrjbB2ZA@mail.gmail.com>
 <20200708113505.GA3667@nanopsycho.orion>
 <CAACQVJpxsOXFPaSn9pjqeEeVRu_VJumvndpPpYNs_zx5SmiHgA@mail.gmail.com>
 <20200708082623.2252d2e8@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7a815f0d-717b-6b34-9bd4-0fc9cf606b93@gmail.com>
Date:   Wed, 8 Jul 2020 10:00:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708082623.2252d2e8@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 9:26 AM, Stephen Hemminger wrote:
> Resolving may mean doing more widespread changes across iproute

some of the devlink messages come from the driver, so it is not just
iproute2.
