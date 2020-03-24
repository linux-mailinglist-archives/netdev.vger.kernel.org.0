Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42236191A38
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCXTnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:43:40 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36755 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgCXTnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:43:39 -0400
Received: by mail-oi1-f196.google.com with SMTP id k18so19728652oib.3;
        Tue, 24 Mar 2020 12:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v0Lb179Xsvu+pLNHsFIahOHyMAoUJr1uLEfB5vqXXMM=;
        b=ruDc8SuvLVcsBTW3zKpfpxzuqp4x7GDsF50RjqtpN7Z/X0f9q9YstwV4Vgnxf9DP+7
         MNDp+WAEB2gKLbRcOIbywTwd1zpJgjcLjDfXuI7GJUm6lvPyFQNzwTWy2YAX2XUiSqxi
         LeuHtet8IQMM9PI1iVsPXyLi/cvsBjBLIMgdSU9RmTs1hnNms0GEJMWFwrXn0RvMkMtc
         DKk98KD2D2S7ZFwm4NRtUEqidf/qgMVj5QQp3xJ2hMzFB/7H1/8Fwc6IqdDPAGGnjBg+
         i9D5sK8KOvqTPQZq9ywIlYH43MpqFkMkcqSKjsSPuUHXUYk4WDb1Kggfqj4Qlc+zIca1
         aPmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v0Lb179Xsvu+pLNHsFIahOHyMAoUJr1uLEfB5vqXXMM=;
        b=qboqbPzmXkBx9bj1JGt/UA0nt84rMPOIwbFcyiG+eM2BGDWF1CbXL6AelC/PkusdTx
         SAZcmbVG4jYm9eFEFuCAqQXPctyGIN2sXgJZg9KNInpuqSecFHU9bGL7iq3IDBk0dcxX
         uiJjp0hs1HXnNLsq1Qwuzi4XPIGMJcxkgdHWzteI2TMVvqdvoOYFJGa+3jI7U8MUp+cR
         iA3i4EBTnDjwW7r2DBy8VlzpC/vCDL3X+LL6XNWISCJmQahcQpFibngdD/L5sPwXqvXC
         0r6H9LOTPqP5f2PLIITf3yIUpWqiKu+BEKepq4QrpnlwadCUB7Iu0oMAdfcYF3hV2R9K
         EGfA==
X-Gm-Message-State: ANhLgQ3G+921WophAVxHq+3uiuEY7BSdnMTS7IbzSIIPZl48TgKcPidd
        D6//M576/T1mga6sDV6YNeo=
X-Google-Smtp-Source: ADFU+vtZVcKOXuht2eESgZdnD2MDhbi4oXJHnGGTpgfoHAPYp/e9rYAIxsXcrOu9EgDkSnHGEyRf2Q==
X-Received: by 2002:aca:b5c3:: with SMTP id e186mr4511758oif.114.1585079018625;
        Tue, 24 Mar 2020 12:43:38 -0700 (PDT)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id n20sm6360504ota.54.2020.03.24.12.43.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Mar 2020 12:43:37 -0700 (PDT)
Date:   Tue, 24 Mar 2020 12:43:36 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michal Marek <michal.lkml@markovi.net>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH 3/3] kbuild: remove AS variable
Message-ID: <20200324194336.GA15310@ubuntu-m2-xlarge-x86>
References: <20200324161539.7538-1-masahiroy@kernel.org>
 <20200324161539.7538-3-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324161539.7538-3-masahiroy@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 01:15:39AM +0900, Masahiro Yamada wrote:
> As commit 5ef872636ca7 ("kbuild: get rid of misleading $(AS) from
> documents") noted, we rarely use $(AS) in the kernel build.
> 
> Now that the only/last user of $(AS) in drivers/net/wan/Makefile was
> converted to $(CC), $(AS) is no longer used in the build process.
> 
> You can still pass in AS=clang, which is just a switch to turn on
> the LLVM integrated assembler.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
