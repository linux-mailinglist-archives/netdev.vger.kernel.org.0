Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69EAD120000
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 09:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfLPIjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 03:39:00 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:33113 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfLPIi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 03:38:59 -0500
Received: from [192.168.1.155] ([77.2.44.177]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mbkac-1i8GtY2cKk-00dEbt; Mon, 16 Dec 2019 09:38:50 +0100
Subject: Re: [PATCH] net: l2tp: remove unneeded MODULE_VERSION() usage
To:     David Miller <davem@davemloft.net>, info@metux.net
Cc:     linux-kernel@vger.kernel.org, jchapman@katalix.com,
        netdev@vger.kernel.org
References: <20191212133613.25376-1-info@metux.net>
 <20191212.110354.354662228217900367.davem@davemloft.net>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <75d6a169-d977-441a-f9b5-292be0c9a3f1@metux.net>
Date:   Mon, 16 Dec 2019 09:38:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191212.110354.354662228217900367.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: tl
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:2CqXzjJ/9Rl87J4VRB8rGMWHTiQg+TNck86VRyWGGfMGIhsEhLc
 YvLGIyG0jCvZO3wy5RAQHLeKqWEELlQ7MkliKqSmhhT6Dr0FZkHypk0Q83op505Om8TLCco
 VhSVxW4bYHGfdE6ywonzLOd/HFEn3IOzX3W36a3Jk35WQkeofO6U0zbayqrIXL+0jpOwJuA
 tneSCDpLmGZ5pmbOkSeXA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8Nfwt0ybmJc=:A4391fXndGZ/zwrcm7kqf7
 KP/GcKlirwiXeqt0Xq5gpj3wbVesvKNygGkvJmyDXc/GhtF8mVP/Iu9gmCukA8fB5Uce9E/8a
 1p2rwmbmsA1jel6nXi+rwRnFKc1uHykMo/PNo3brFBTniprpZSZro1RTAKleKL40vkGHMRBVs
 FxZz8hLqzE7NDMbnika8wtLikC5E81vbOTJBsqwp5Y+SDZGg25Fo7Q7Rwq9M8kXyl3EwGCFky
 Xn9OXU2N+SPboglQ+dLyYFr7Lk97aEej3XN69xOUuI+GxPutOdF5MU0mIT0WP/dLJ94xQnofp
 ak+aBMbG0nkmMlbNN6d8gxNHC3GfX3c//Fe5KlIWLbvWUZsvX8+Cot+T7DlS0rXezsXtfHdyT
 26gE7MnsQxJOsCvn+Uhk0v5TG9j+6w0+cT+XFSAzR6HIgmeutEFQFMs3JtDGqDg1wg1DnSCdC
 OFLmSPrrUNTucqQX3Nknve/hw6of6MWmWWpM3dkEtpF57pIgbSfiAYbbIW7DGs8wIcfCKcvHV
 BjsRaJDLtjI1rtWNAqeMVEEzWBAmqeKTyMrTrrqy7sT3LU6NsZBQjUCxHL4nq2qZgQxmUwBFR
 rKq12ya6obp9GuIcUIqcpaLH2XXEvFTzY43ag7W+GmG4PbT7F8s9/XzVpG6ehps9TKRUAGisU
 em7n+fPbab4Y9NK0av/aFk3idd7D0oVyswNfri5aRz2HG775LCo7PGZyAUjyvahzp6it8J2Mv
 6xhcQ2ib9JfZhyMsHoGFrxJ/DDw294bvyc5j0a9xF8rtF9lkwnOjzUcxmqXgt9JZfe7bga24t
 1SkZdovYC3SBYOjwuza6WriEMwZ3dp8JqEmZN/3y3x5e7wKfiNhpEJuzPqebVH+CRF/d5uniE
 dMCl/u2s6p0D0ckMoO/Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.12.19 20:03, David Miller wrote:

Hi,

> Is there a plan to remove MODULE_VERSION across the entire kernel tree?

I'm not entirely sure, but for all I know it just doesn't make sense at
all to have it (maybe except for OOT modules) and already was removed in
several places. For example, Greg cleansed it from the input subsys a
few years ago:

	https://lkml.org/lkml/2017/11/22/480

Similar patch for gpio subsys was accepted recently.

This got my attention by some discussion on some patches introducing new
module w/ including such macro call. The consensus from the discussion
was that the MODULE_VERSION() shouldn't be used, so I prepared some
patches to remove it in many places.

If you like to keep it in, give me a clear reject (maybe also a short
list of other areas under your maintainership), so I can skip it out
and don't bother you again :)

Personally, I believe, we shouldn't keep things that don't really serve
any purpose. Does anybody ever actually use it ?


By the way: we've got a similar thing with network devices, they've got
a version field. But it seems not all drivers filling it.

What is that used for ?



--mtx

---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
