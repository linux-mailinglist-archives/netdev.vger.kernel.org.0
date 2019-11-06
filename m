Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D7CF1D9B
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732444AbfKFSd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:33:56 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44849 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfKFSd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 13:33:56 -0500
Received: by mail-ot1-f66.google.com with SMTP id c19so5593892otr.11;
        Wed, 06 Nov 2019 10:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=NaBv7i8Bvb+Nh7AUP99bMks2ey3ZpHBIKQxNdaEVNi0=;
        b=MKc7VUJJ0V/sAeBy2uCFu+tjBwm8cteZ+cOgZQjrrliLE09kwu+UfmXKF7JAjDwONQ
         W2p5r8mxWTbA2FxYySMXEfocXYvV06JlzqK7qXB+ehgm2VjgrMa36tll1Isv0cpGeFjV
         pI02a2hAmI8rDpFpMkLI8dhzev5pKJLGmdNOHh7oWsgkay3AxJ6dyJ0U1NRXOrWAYEgZ
         hFJlfaIe1pBM4q1Tkpmm/4caWD8OADMVcuGxoQwCn8yn2P2QVXH5BQ4f1/8xW+8UQASA
         b08AD1nXVr96c3IpP0g/2m7ivr+/likVDNW7pcLA/beK5aUjerrvcvWMsx31liv0Lixt
         guAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=NaBv7i8Bvb+Nh7AUP99bMks2ey3ZpHBIKQxNdaEVNi0=;
        b=d/UTcHw57QEn0V2jZgZ9fO1RiUlT7fsmKERcbdwJRRExOXg1rMjNJc86yuhwEqZn02
         ROjNKrhwPIOvs54uF9Wu15gFLrGkdYQSjJwfoDGCftCp5/l8kjeC9EFeIJGKmXDjm8NY
         wCjhtE2v4cid4NjINjhwATKSCcj6f6FD2B7HAj1PkdRTf6SolydRDMIkanx0eLar9vwX
         lfvOJhn8/aRgReHHo640hgK0D5yzJt/Gt8D6AGtIGvVFFZP/bpReqUkvWPdLW6B4NamL
         VhM+xa3On8gP7hG7yeZY4dFBoVJyPZZxP8jz6vSjNUTG2KnZFhGFsmotRNJG9S4SJk0Z
         gCxw==
X-Gm-Message-State: APjAAAUC1OJGTLl1TrwDk3WuniA5NN1W7w7c6JJN0HO8qd5z+dZfplwu
        Ihi6KQFtv2+kGkerZ55iRNR20D8iZZEbl5sG6TY=
X-Google-Smtp-Source: APXvYqz60uFQoaLI3TGk/tRSFQHzj+M/3oJFUHnreNIoBaZNzbqvlDF3xOTdHhbBsFzjnKUwyP1Z2kE1RV9wWhUJft8=
X-Received: by 2002:a05:6830:22ef:: with SMTP id t15mr2900337otc.256.1573065235432;
 Wed, 06 Nov 2019 10:33:55 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:384:0:0:0:0:0 with HTTP; Wed, 6 Nov 2019 10:33:54 -0800 (PST)
In-Reply-To: <87y2ws3lvh.fsf@kamboji.qca.qualcomm.com>
References: <20191101054035.42101-1-ikjn@chromium.org> <87y2ws3lvh.fsf@kamboji.qca.qualcomm.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 6 Nov 2019 19:33:54 +0100
Message-ID: <CAKR_QVKqGv+hpiENHmNFE4y=FY+Mqb7cAh7_5xhTXH27HW+Taw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: disable cpuidle during downloading firmware.
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ikjoon Jang <ikjn@chromium.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/11/2019, Kalle Valo <kvalo@codeaurora.org> wrote:
> Ikjoon Jang <ikjn@chromium.org> writes:
>
>> Downloading ath10k firmware needs a large number of IOs and
>> cpuidle's miss predictions make it worse. In the worst case,
>> resume time can be three times longer than the average on sdio.
>>
>> This patch disables cpuidle during firmware downloading by
>> applying PM_QOS_CPU_DMA_LATENCY in ath10k_download_fw().
>>
>> Signed-off-by: Ikjoon Jang <ikjn@chromium.org>
>
> On what hardware and firmware versions did you test this? I'll add that
> to the commit log.
>
> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches#guidelines
>
> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
>

Hi

I've tested this on QCA9880. No issues during firmware download.
