Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790C21DEE8C
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgEVRqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730858AbgEVRqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 13:46:52 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D84C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 10:46:52 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id d7so8844682ote.6
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 10:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GgoVg9jLWmk26AkVFcugaNQ8PXqCClRdYzTYJKgIBRY=;
        b=vIzkumL0YUaC1nNRF5Yv5EUvUayau7cjbkZqlNMDnkmxSEydoswo13LzVCf/x57t49
         mh4uRJ2uSXhhDGl5nh2Ex31jgK9tDoVlqywcbcjATtSufmwzwbVioNqZWGgyMTLAh7nr
         nQ7X13vwCULio0U2p8Ww+8BmkBtompv1nZc32ZlrGQR63cYlrWV/nX2m1VjPPikEMhN7
         +nKrCwNsdakxJWsm8+l5RrwfQVowePXmrRyk+I+2UOXhk87m+f7QUFAYUFmHjRBdHjYx
         Dx1OkXY9fBAjYB581ngb3rRaSOXDkoJUfpOZN7U+Xb2EtLX1QQzJaZkSnZhGBHW0Q7XC
         8iSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GgoVg9jLWmk26AkVFcugaNQ8PXqCClRdYzTYJKgIBRY=;
        b=pn2nqP78ydlLER3gWzZCQR3wVpoAiqEJ4DXevp+WiG/wiMxASmnT+mJ//pcPl33jRx
         lAPoG2AHB6yUdxTGO4Zy00kWyg2pIglbt2Pxs3IEnGtWJAmMMOaCm50ijL3jj0A0L380
         DngXQggHSu7yf95uNmYoiOB3cW46XjLuiCPpxuiqhK72uHD6Z3xJJ9+uXuhh1CZKdqy/
         rhCISCFTL+YTk1I6dVXBW7TxRkzQiNkuDtSvx1Gpk7w9LcG6JYlXXVlTz611fBIe0Vjf
         LEWQ70TQ/e9gj5gIZ5mXk/0aoBcKOZlGG4LXFnVs2YcOY6fDfsHFBUu82oX0QKUEsMrz
         Tdnw==
X-Gm-Message-State: AOAM531FjE/58fmqxzqkgTY7zl4h09BJkvK7QycH5F2ld32jhBRY7yXi
        onZqToqPoVQjXUCmLeyuPcw=
X-Google-Smtp-Source: ABdhPJyx4jwA0l9vYln63uz4KiNQTBc33h3QGA7q4cb/N5ZjvE2XbKGCLS0y01ZC+z9gcSj74wB+Yg==
X-Received: by 2002:a05:6830:1584:: with SMTP id i4mr10899961otr.285.1590169611977;
        Fri, 22 May 2020 10:46:51 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5123:b8d3:32f1:177b? ([2601:282:803:7700:5123:b8d3:32f1:177b])
        by smtp.googlemail.com with ESMTPSA id i127sm2783471oih.38.2020.05.22.10.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 10:46:51 -0700 (PDT)
Subject: Re: [PATCH RFC bpf-next 0/4] bpf: Add support for XDP programs in
 DEVMAPs
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200522010526.14649-1-dsahern@kernel.org>
 <87lflkj6zs.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f94be4c8-c547-1be0-98c8-7e7cd3b7ee71@gmail.com>
Date:   Fri, 22 May 2020 11:46:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87lflkj6zs.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 9:59 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@kernel.org> writes:
> 
>> Implementation of Daniel's proposal for allowing DEVMAP entries to be
>> a device index, program id pair. Daniel suggested an fd to specify the
>> program, but that seems odd to me that you insert the value as an fd, but
>> read it back as an id since the fd can be closed.
> 
> While I can be sympathetic to the argument that it seems odd, every
> other API uses FD for insert and returns ID, so why make it different
> here? Also, the choice has privilege implications, since the CAP_BPF
> series explicitly makes going from ID->FD a more privileged operation
> than just querying the ID.
> 

I do not like the model where the kernel changes the value the user
pushed down.
