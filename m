Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EEB35F9BC
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 19:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348498AbhDNRYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 13:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbhDNRYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 13:24:48 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C10C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 10:24:24 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id a21so8299394oib.10
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 10:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sJDAUqCam5UAJMym4zOYAwPuTsP5A19Qk9E5u2wAl3o=;
        b=CCZp60ANKzcNc7wx6CS3nksZGsZNoaU++QXtJQ554/9epgZdbiq7AO6cVQURLJuHMk
         eb6cS/7339pT6dR8mqpVhAlwG0eXf7fXXktfBYm9Xii9w7AKLod/bsR5Oe3Dzs+6T+vP
         acBS3rgvJfF2P+LyZld+Rhj2Y3qeeCqjKQOHYJ9VLioKn476llgiQ5X67zN5VNL38GV6
         HPyD+aNQnW06hL5DN912RTZCrFBcv0A4Rm3DM5POgoo2roofyqGl4k2HtvnFA9e/Ij9/
         2BHcHgt8tmp4hzkedUABO9+nq12Etz3IDQEHjUm7KidUHE6V8tjtjQVngq5m6N1YYEj1
         q0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sJDAUqCam5UAJMym4zOYAwPuTsP5A19Qk9E5u2wAl3o=;
        b=WvsKjsLv8nBlbts1DUF6MP4YbJOr1lUkpvn5TC2aopioLZCCn+Z+ngjeVIOv1zq0J+
         tP2WBHfs0CYhTG4N4F40Gj7HSaVsSZaW9nYmf6nADQ2rEWMSyrWA1G4OCa7G3YKMPnD/
         QEnn7XEh15u50iTdtLnna+SDm6EGOQYXBJ905xHvxz/AVbeAyMvTQUGyW3YqLAwWyLas
         zx5Rhwa+Y6V82GHxBM0pTjXr3P1H4AXshYkUvebaoUqMQCtXm+wgtLYbk1OT5J/nXFKl
         +5gJ5v7+0rPZsvmMSgX4daIA4Bq1ZXKLw8IblkV/V/hNktM30smLsnDUnpUrvS0X0F7Q
         MDww==
X-Gm-Message-State: AOAM532DiSH2qbTTP6rRLwxhUxcpr9RzJ6FwKLfjg+0KSyrdgY77Vfxo
        GF1fwoGET2BL4UpTcGGaVlnxrHOhS3Y=
X-Google-Smtp-Source: ABdhPJwJAz7Ejoap8hNedXSMja1t792M/6NkuTcIAKvAtUuT6d/G4FsQk03v9Lsk7FC8GcXglc1XqQ==
X-Received: by 2002:a54:4711:: with SMTP id k17mr3002295oik.163.1618421064132;
        Wed, 14 Apr 2021 10:24:24 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.70])
        by smtp.googlemail.com with ESMTPSA id u66sm27848oif.23.2021.04.14.10.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 10:24:23 -0700 (PDT)
Subject: Re: [PATCH net] vrf: fix a comment about loopback device
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
References: <20210414100325.14705-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4a500c52-7110-453a-1d49-2a897cf2de59@gmail.com>
Date:   Wed, 14 Apr 2021 10:24:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414100325.14705-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/21 3:03 AM, Nicolas Dichtel wrote:
> This is a leftover of the below commit.
> 
> Fixes: 4f04256c983a ("net: vrf: Drop local rtable and rt6_info")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  drivers/net/vrf.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 

Acked-by: David Ahern <dsahern@gmail.com>

Thanks, Nicolas.

