Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E6C1A4B3C
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 22:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDJUj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 16:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgDJUj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 16:39:27 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D7C020936;
        Fri, 10 Apr 2020 20:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586551167;
        bh=fx/YNx4dh/aRYlOkh+d8yQlgMojYPrhWbJbg1ZKbAn4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jURIy8M8FEXXB1EpC8iZakWlnt+L9s03r6fN4IvDeGeFcgziPpQvGZFT0T4ru1dDU
         +u6gVkEECNvjwZNRyc/DhrSvze9xqhZSdg4xko38D4yMY7FSPjBxjZXlk9vRKMKZ0Q
         LwH6LMx17f7XJnJr8KGaf0Ji+hY1leOfEZThBNbc=
Subject: Re: [PATCH] selftests/seccomp: allow clock_nanosleep instead of
 nanosleep
To:     Kees Cook <keescook@chromium.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        luto@amacapital.net, wad@chromium.org, shuah <shuah@kernel.org>
References: <20200408235753.8566-1-cascardo@canonical.com>
 <202004101328.075568852D@keescook>
From:   shuah <shuah@kernel.org>
Message-ID: <0d4e5356-d40a-8d17-1c61-d5c3c92fd11e@kernel.org>
Date:   Fri, 10 Apr 2020 14:38:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <202004101328.075568852D@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/20 2:29 PM, Kees Cook wrote:
> On Wed, Apr 08, 2020 at 08:57:53PM -0300, Thadeu Lima de Souza Cascardo wrote:
>> glibc 2.31 calls clock_nanosleep when its nanosleep function is used. So
>> the restart_syscall fails after that. In order to deal with it, we trace
>> clock_nanosleep and nanosleep. Then we check for either.
>>
>> This works just fine on systems with both glibc 2.30 and glibc 2.31,
>> whereas it failed before on a system with glibc 2.31.
>>
>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> 
> Actually, sorry, this should go via Shuah's tree. :) Shuah, do you have
> anything going Linus's way already for -rc2?
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 

I have a few patches for rc2. I will pick this up.

thanks,
-- Shuah
