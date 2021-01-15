Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141192F76E8
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 11:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbhAOKnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 05:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731597AbhAOKnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 05:43:02 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C07C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 02:42:16 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id o6so17148845iob.10
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 02:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3WziMzMlpDQny9OmQLegGMEVnRn11mbJDrmEoffrpPg=;
        b=RZQnBhM+70MBAOt8V+WF1xxEARu4RAPtj/N2SIiW6zG5KtT4SoG4CMIUuKtJRpAMEM
         og1NQ17LtFJkiN0077KvHEfRs7J2VS5K/rGqzzWEsR8oBG/dpf0aU+BWu7SLchsgixkB
         qm7O+2r+rl7wAc/iXXbzW7TSuhMaI9pQUvxA6jX3nmzVx+xVE+qfSph1EiWbtI6HDbC9
         iEp6oUieHq1geMVKFB7DcDYO0yuvuW5jhN60eSWSXnjyDK3QXIEwG9ueD50Fn5A9Mbht
         TfevGUvt79LH44d9PUYvvaesbGNRWOfZYY+ZnueVV1RrzW4/IAhlRQ+2vvlwoJ/C0IUn
         IA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3WziMzMlpDQny9OmQLegGMEVnRn11mbJDrmEoffrpPg=;
        b=g5v9jVIZ5/g3pam1Y+84NbJA9twlgzC0i/ovm8utSLyPdManiGv38o7kxCYDxpzkvd
         /1wKE3lOST5UnkyIphwRqAr78vLOdv1RujEjf1MB6a/uPG/slUPjm6bqYniS0YK7tmsF
         w6XZQUkEC4nidIK57Uj01TE5rHurw2DWhP18a/ykHVrUAC51dWKhWfRUswP4waRGXmi2
         kWxiKDH+DAvhb+MwxiqqmbtxQ6g52H4iQKYUn5kNhMLE5Xw0W8Fyv//nwVljWD126gHK
         QSQS2k0+WWkTFhZvhEpR1TAb4at/UPFqjt+GUPVTihPQY7m+5WC3g4vIEnUQfkWlTrqn
         eRww==
X-Gm-Message-State: AOAM530NG0o4HtOZmfUZ5PLy8vzmT1xY9n/XRnZcQXCJxl/eyFBwDGCA
        w+vlDc+zgqgs61Hw6/l1CWeAaA==
X-Google-Smtp-Source: ABdhPJw0k5jswm7iZ8swCZ95R7G2bJnZ3cdZhXeek6DNwjYIU6WOkjuSsHjmuk28pCW815fvrF46Ug==
X-Received: by 2002:a05:6602:2c49:: with SMTP id x9mr292563iov.173.1610707336091;
        Fri, 15 Jan 2021 02:42:16 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id s1sm3870489iot.0.2021.01.15.02.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 02:42:15 -0800 (PST)
Subject: Re: [PATCH net-next 0/6] net: ipa: GSI interrupt updates
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210113171532.19248-1-elder@linaro.org>
 <183ca04bc2b03a5f9c64fa29a3148983e4594963.camel@kernel.org>
 <20210114180837.793879ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <7cce0055-3fd3-693b-b663-c8cf5c8b4982@linaro.org>
Date:   Fri, 15 Jan 2021 04:42:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210114180837.793879ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/21 8:08 PM, Jakub Kicinski wrote:
> Dropped the fixes tags (since its not a series of fixes) and applied.

Thanks for applying these.

Do you only want "Fixes" tags on patches posted for the net
branch (and not net-next)?

I think I might have debated sending these as bug fixes but
decided they weren't serious enough to warrant that.  Anyway
if I know it's important to *not* use that tag I can avoid
including it.

Thanks.

					-Alex
