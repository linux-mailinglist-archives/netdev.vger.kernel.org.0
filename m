Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C9628AC00
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 04:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgJLCKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 22:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbgJLCKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 22:10:42 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A49C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 19:10:42 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id p16so6038624ilq.5
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 19:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Qgr6ByemHXmWNefPGhyJHmNNR2Q+e9+Lw7uIVUrQNI=;
        b=pWPAdFBS+nBYcGVrTOC4yto/ULAqinpGNNojUQw793jCzrsP/ZcoTsrKDpQi27CQdS
         gctvALCdXC7VmjYkNMsaiYoj8gGTk5tiK4SU7zU8e+W9XVOXxNCIFSCtOSbs6OlsXWLk
         /cMoit4iAS0a7Rn3MV26uOah4zmGoyVXh5yDIjgSHxoa2n38/PxVCXmH/vyffQ005G4Z
         eDHZPDf7ZsUE6GshCVsmjmelcVd3QlyqLckDvql2yUghH6Ip7jsoEgMzGb1+cVnjlosu
         VPvEtBpCFj/alLq6fpXGSd0Of1GCyWl38fLUhfW1VcayhOeajmhws5Uo0eO1QstorrO1
         5XeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Qgr6ByemHXmWNefPGhyJHmNNR2Q+e9+Lw7uIVUrQNI=;
        b=O1t1qPhDFA5XIxMoOD6skMUzL/G//a0wYMYqGVEC5uud8TgLwnesTkclpHlasqSIci
         FXy2aAG1R/s+qF1gP7gqU3FH24VOMWR4JVQFORwuM4ej48k+d+BuRzyzBxJkWYaOhMNq
         dgYen2jyR1Qto7j683vnEcX4vispxmORi5ECwvAjb2HzdKuhrnOWJ2EuAxWWGqToSeB7
         EwfE+z2sDdiL31MZ5BUc/GpunEsRFHtDgBSWXZQJxJBznme4zv6n6zYKiaefYYHzfpqu
         LulybnMaF+yoESatnIXO8k64JmhkrhX/FlGoQyPys2yvLvf4Nb5TnsO9UDgzF3Rb0h25
         lcAg==
X-Gm-Message-State: AOAM530208NOJuj5s2kZThzSh7coehQ4jr2/97nYPc+Lnnwt7Ejo/5wy
        sjGTRzU+DtKPNwqS+ZrhsHuV/HWg7Tc=
X-Google-Smtp-Source: ABdhPJxKWbw87Qew9anpKqFGp9lmHc+PrviuFnNkgd27L6dhhU/5RVeTnZTIAm21AIRazUXtJekJ4A==
X-Received: by 2002:a05:6e02:d83:: with SMTP id i3mr16992606ilj.221.1602468641824;
        Sun, 11 Oct 2020 19:10:41 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:85e0:a5a2:ceeb:837])
        by smtp.googlemail.com with ESMTPSA id h14sm8262250ilc.38.2020.10.11.19.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 19:10:40 -0700 (PDT)
Subject: Re: [PATCH v3] genl: ctrl: print op -> policy idx mapping
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
References: <20201003084532.59283-1-johannes@sipsolutions.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3661130d-f6b3-ec07-c5ea-387fd6e8b459@gmail.com>
Date:   Sun, 11 Oct 2020 20:10:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201003084532.59283-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/3/20 1:45 AM, Johannes Berg wrote:
> Newer kernels can dump per-op policies, so print out the new
> mapping attribute to indicate which op has which policy.
> 
> v2:
>  * print out both do/dump policy idx
> v3:
>  * fix userspace API which renumbered after patch rebasing
> 

applied to iproute2-next.

