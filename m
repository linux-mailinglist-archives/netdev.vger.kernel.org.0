Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8AF2D2DC7
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 16:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbgLHPCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 10:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729899AbgLHPCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 10:02:22 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C8BC061749;
        Tue,  8 Dec 2020 07:01:42 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id a6so2318891wmc.2;
        Tue, 08 Dec 2020 07:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lOJIjTS4kMwJd31tqpSHnz0o1TfB4QgqzCSeT7sm2A0=;
        b=Gd4Dd6DSLTE+c03ass2Xm8hfDC8TX2uhKMc37AMWWOOLlnvI7vJOMbdPjfxFqCs1w8
         VI8ujbw1LLm1PYoBMpsgHEv6eojQYEH4k404OQvVCHUfoh8k+vKqc4zC+ed7doH6NRXb
         Mz8umYQi1ZjAdNEf0cGNWmtjaa0fwnev6Jb/6qth/pgRPyt6reNg7xIfeO7A8XuOt2yZ
         KAtke5VgEhVRqhL+00m2p3Q57TU07f2yKFDj2PhUseTiFNuJZDJCxO5wvdKvkCAZhbnh
         ysEkUDOBnZfytjUwNtHtR5o0GnStE/dU+j5veeF7cXqJcTT7Iqg6MqO7i/NkQu9MBRbB
         C9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lOJIjTS4kMwJd31tqpSHnz0o1TfB4QgqzCSeT7sm2A0=;
        b=X8aaG9ZxeYcJ+KN+OAZFZn7YmX7ojTeZ0ChgWJdOsoIquGUZRkXU8KJYX6gKXjYCQ+
         +NS6zZHj8M0PiC9dgLeUS2g/nvVA+3b2mQlPpXEr9dqU9udotVE5aYTgxYurrmxrrFGU
         9oVlNow61x3J2zfNPvIgwRCSbpc0HS2JHsp8/qXSWocb3TOwu3TpN/AtWkgNBiAzycJw
         Tnn+5V1p2/cTY38nNuJC+1UvRsEwyGHr5QHP/+SwVhyo7eSwadSn38bMTy4r1GOpYXso
         vcieq+ZrW0gbWP8QDrzj0krcpCd5yKVs/9uLbWKQTs5TgGvRhDX93+9Ijtlu5ObC9THq
         tJEA==
X-Gm-Message-State: AOAM533tRusS5IXy3nwwUvjlaNXfI+y8Yy7UNOf/xccghsPlrNm+kfJJ
        c/Kno5G8p95DsC9OSJzLt4MkdUbjFkgN2g==
X-Google-Smtp-Source: ABdhPJxTBcW/FhGPZIZRlN2bppi+/UQdzewd1Ocw/u6zQ18JvY7TCiVdKIYbiQvkGJKhQs/vPg2Pfw==
X-Received: by 2002:a1c:4e0a:: with SMTP id g10mr4231939wmh.51.1607439700643;
        Tue, 08 Dec 2020 07:01:40 -0800 (PST)
Received: from [80.5.128.40] (cpc108961-cmbg20-2-0-cust39.5-4.cable.virginm.net. [80.5.128.40])
        by smtp.gmail.com with ESMTPSA id d9sm20925433wrs.26.2020.12.08.07.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 07:01:39 -0800 (PST)
Subject: Re: pull-request: wireless-drivers-next-2020-12-03
To:     Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <20201203185732.9CFA5C433ED@smtp.codeaurora.org>
 <20201204111715.04d5b198@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87tusxgar5.fsf@codeaurora.org>
 <CA+ASDXNT+uKLLhTV0Nr-wxGkM16_OkedUyoEwx5FgV3ML9SMsQ@mail.gmail.com>
 <20201207121029.77d48f2c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <bd5f9ded-e575-705b-a56b-a92f7765235f@gmail.com>
Date:   Tue, 8 Dec 2020 15:01:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201207121029.77d48f2c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2020 20:10, Jakub Kicinski wrote:
> On Mon, 7 Dec 2020 11:35:53 -0800 Brian Norris wrote:
>> Is there some reference for this rule (e.g., dictate from on high; or
>> some explanation of reasons)? Or limitations on it?
> 
> TBH its one of those "widely accepted truth" in networking which was
> probably discussed before I started compiling kernels so I don't know
> the full background.

My understanding is that it's because users can have them in their
 modprobe.conf, which causes breakage if an update removes the param.
 I think the module insert fails if there are unrecognised parameters
 there.

>> this sounds like one could never drop a module parameter, or remove
>> obsolete features.
Not far from the truth.  If you stop the network from coming up on
 boot you can really ruin a sysadmin's day :-/
But usually you can remove the feature, and leave the modparam not
 connected to anything, except maybe a deprecation warning printk if
 it's set to something other than the default.

-ed
