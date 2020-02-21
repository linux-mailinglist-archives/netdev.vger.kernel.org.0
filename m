Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67C07167D5C
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 13:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgBUMWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 07:22:49 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:38465 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbgBUMWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 07:22:49 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ae69edc7;
        Fri, 21 Feb 2020 12:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=uhQCAVDb4364mtjJv6SpTB65UHI=; b=W2LUF+
        cv8YS3So0N9HhPcAaDjEC3yO7K9nXdhN3Ra/LCX6BzXlputceFhbmqhbowO4pJOs
        U7RIWQ06Vd+4ZFxaiDK/l/0YLbLnLsw+dFMbDEVmg5nR0ykQ1/urB+d2CbyL00IM
        pIEozkJikuT+7Rl0LzFG7iPs6KCJK1MJ50iGFNvucQAyTRpsjVly428cVeeAcv6i
        pznknhVrmpUhCPXjyd9VlF9oBrgGJDDcqErvQ7U6cb09Y3Eep0lHLoHNHtWeHtNW
        SjLbFgMGjfNngCv+fr7AkCCh6cHU6cwlEaGZ1BazexiFn+TCcfEIJLbNwtWBYfsj
        W5qK8D4XQhEMAxag==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dfc282aa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 21 Feb 2020 12:19:46 +0000 (UTC)
Received: by mail-oi1-f170.google.com with SMTP id l136so1393238oig.1;
        Fri, 21 Feb 2020 04:22:46 -0800 (PST)
X-Gm-Message-State: APjAAAXI0+QiGxe/eQRMI/2FQG68MCX8av3gp4V650EQJFQgwhhcCMp1
        289WXvZEqHkh4Gi4PGfQ+99VR3Ai+8X5FvLWLm0=
X-Google-Smtp-Source: APXvYqx/gekI9G4Z55x1wRyYB/MJ/2qeEFf/kPEOn+vk71fqK0y/SAfYdl5pBHlDGpLivFV6vx8dxGdDCMMxdyIgJ28=
X-Received: by 2002:aca:815:: with SMTP id 21mr1815304oii.52.1582287766123;
 Fri, 21 Feb 2020 04:22:46 -0800 (PST)
MIME-Version: 1.0
References: <20200221072209.10612-1-yuehaibing@huawei.com>
In-Reply-To: <20200221072209.10612-1-yuehaibing@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 21 Feb 2020 13:22:35 +0100
X-Gmail-Original-Message-ID: <CAHmME9po5q_EYiy0yX0VxcnTdiQe1Aa74WLXsYMmxepasUHtww@mail.gmail.com>
Message-ID: <CAHmME9po5q_EYiy0yX0VxcnTdiQe1Aa74WLXsYMmxepasUHtww@mail.gmail.com>
Subject: Re: [PATCH net-next] wireguard: selftests: remove duplicated include <sys/types.h>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Shuah Khan <shuah@kernel.org>, David Miller <davem@davemloft.net>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 8:23 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Remove duplicated include.

Thanks. Applied to the wireguard-linux tree.
