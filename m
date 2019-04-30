Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F4AFFAB
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfD3SXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:23:16 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35321 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfD3SXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 14:23:16 -0400
Received: by mail-pf1-f194.google.com with SMTP id t21so7478760pfh.2
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 11:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f8pxTs3dwceHEcKoUZ8IveiI6Ua1SOusN87dK1uxhpw=;
        b=ZT+pxB7yfWnxeFw0CUiQr71Oq5ZQQEG56wMoGR9ltxc2au1b7l/olJFSWZxS/mUC2Y
         Ctx+4j7IZTbsuWkb3EKUYjoWq0APeMjrTQcOVmfzwIH0YwdqM2/uVUH1UZnN8v+/T+X4
         BS0PFUkIqKJ0Dxbdg0sZiUBdK91p86m7Ub0ZbwJo46LiRGWR5YTSG/hvxCPcMjuYoqFW
         oK/IE+Fduv/TO0VXEG02wKcSV7LIwqGVp5J+u1pMCVTcPfdRecDEEFvfTEelYbTGoReR
         MWIBClP2rD22+lIeyadv7C2lGrqBQwZ5GFZ4amIA7pJ8XBW5tGDA4WTo+YLNGIzlmtAJ
         cbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f8pxTs3dwceHEcKoUZ8IveiI6Ua1SOusN87dK1uxhpw=;
        b=Mj7k4KitmFWDXL53vHJD+DHGNSjJ7jCgCcR5zm6gVuflXezRiCBJReMRJH3jGRj8/U
         2hYZtgMX8iBAw0NojAqqPeitylNrsVblvsPMaVBkmeu9dPp2E1UiDhTpqR0iRi8EQPWk
         Ofla6asweCawoKLVlLvT1pUza8ocz429KtsvdSN02YNuKqbPZOGqNmH4KjhowErMUnWP
         WbhFkSgWPe5yGq57mUPrjcYc+vAQbgLRMIEmRUmctxqtfK1CQe2dBely8d8di286k8+9
         UviNxACGESVxu7KoYsQw1LN+o1BX8FARrazYolv2/FRYk/HIJI8Vk4g9hBJEF4ynBY6T
         MPEg==
X-Gm-Message-State: APjAAAW4/UwR0v22DzoydlmshOyiD5iw5I6zJHRjR+z/Had8ulShjrFf
        +DMHFhU40qKdPP4ccxb2ruc=
X-Google-Smtp-Source: APXvYqz1UHGEZMOf8k++dHD1L+m8XuBkkNSKUzfMmnMWmkhkg/7pV71AtjGDmYC/EybRRSmcpIjsQA==
X-Received: by 2002:a63:191b:: with SMTP id z27mr2605095pgl.327.1556648595617;
        Tue, 30 Apr 2019 11:23:15 -0700 (PDT)
Received: from [172.27.227.169] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id u5sm9449305pfb.60.2019.04.30.11.23.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 11:23:14 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] devlink: Increase column size for larger
 shared buffers
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     alexanderk@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20190430084208.4693-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <95526302-cccb-7f19-d2ff-1a5701749af7@gmail.com>
Date:   Tue, 30 Apr 2019 12:23:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190430084208.4693-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/19 2:42 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> With current number of spaces the output is mangled if the shared buffer
> is congested.
> 

...

> 
> v2:
> * Increase number of spaces to make the change more future-proof
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
> ---
>  devlink/devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

applied to iproute2-next. Thanks


