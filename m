Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BF5B5002
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 16:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfIQOJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 10:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbfIQOJt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 10:09:49 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A41D206C2;
        Tue, 17 Sep 2019 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568729388;
        bh=KFwph7a3NLAqJ2SmDpmG/ijd2kzcKrqWVg3/D/v5zMg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gBWa9t46COVeM8W9Fm//z3KOlRGJXJX0JfFItum33ty5Nwpo70PVSms1rMriQ+aqI
         nSuFZ18C7sL7jpZqrtXSFF7AYwBjktC4moA+ToyjF57OoNBv44HonkFxas/tNTW/Sc
         uMShTXMt7KHGNm0DHKWvaJGZERSTxzML7g32JFKA=
Subject: Re: [PATCH] selftests/net: replace AF_MAX with INT_MAX in socket.c
To:     Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20190916150337.18049-1-marcelo.cerri@canonical.com>
 <212adcf8-566e-e06d-529f-f0ac18bd6a35@kernel.org>
 <20190917071222.6nfzmcxt4kxzgpki@gallifrey>
From:   shuah <shuah@kernel.org>
Message-ID: <2a2f3436-4e10-5c7c-3e69-a46491b10960@kernel.org>
Date:   Tue, 17 Sep 2019 08:09:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190917071222.6nfzmcxt4kxzgpki@gallifrey>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/19 1:12 AM, Marcelo Henrique Cerri wrote:
> So the problem arises because the headers we have in userspace might
> be older and not match what we have in the kernel. In that case, the
> actual value of AF_MAX in the userspace headers might be a valid
> protocol family in the new kernel.
> 
> That happens relatively often for us because we support different
> kernel versions at the same time in a given Ubuntu series.
> 

Right. This is an evolving use-case for kselftest to make it easier to
run on distribution kernels.

> An alternative is to use the headers we have in the kernel tree, but I
> believe that might cause other issues.
> 

Kselftest is tied to the kernel in such as way that you do need to use
the kernel headers to compile.

Do you run newer tests on older kernels? Where do you build them? What
I would like to see is fixing the test to run on older kernels and not
changing the tests to suit older kernel needs.

This definitely isn't a change that is good to make. We have to come
with a better way to solve this. Could you please send me the errors
you are seeing so I can help you find a better solution.

thanks,
-- Shuah
