Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF52F5BD2
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfKHXcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:32:09 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42095 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKHXcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:32:08 -0500
Received: by mail-pf1-f196.google.com with SMTP id s5so5878167pfh.9
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 15:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x4QUPGOc37+Xf3sHlndHYzcZZ5n3qCEMfTqm4ibHTd4=;
        b=JB4RvCNIKAoTEvSiyqpGKcVKmss9MUUThBcP1/uq+OhxFN1rkCpbo7ZNvooHeTy7Gk
         r61Kmdw08FXvLVLKLLy0YrpKwEPQWiTBg2MIFxKI5/inYXpY1FsbO/Cb70OoNw3eER7k
         39ELjbZUSd9BXFruY6tCIwYXVO0LZ/QIKM+bEsdKgAILDoofmpXF9sBZbTs0LShSDSy1
         JCJVJJvV/7kQOHEt6IpvQlsavv1z+EdvZeAx0hnJgWVuBe14XUY4a8e9EnTtC6rJTHlK
         0HoX2KnB06bQx+zL2WvA/KZVhXU+zeEoFibzmMG1X8E5aWFHEbYoYloJ8fDpXC3drsTZ
         R+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x4QUPGOc37+Xf3sHlndHYzcZZ5n3qCEMfTqm4ibHTd4=;
        b=CLoFMXpu+ONGtCTWu2NFG01Dqn/Of8shmmZe6p++zviIWIJQfsjClneKqL6cGWzSSU
         /5Uqd4MzXRhp3dfjpn6BKSDmU++qTNl9xqk0ZslWL29EXu+eYoy3oGZ5aBZHZOIdgn6r
         RwoufF5fBnQaSJTIZECJ1vMhyhIpNb+MS8NClhjr9+PL2IM2ASqRPtwl8OGHqc6U/rb9
         q8+cQe9Z3la0TIJSSfFO+qUx2P2ujgDXNJsatbNk7u2HiI8jVGKHj++EEns8Mnrl3qve
         ml2CJpuvCS/o+96Uyy0NKUpg3b+VkaLF003tMlgXAVtHyoKjiLasXKvai/IRGhT8IjkC
         usIA==
X-Gm-Message-State: APjAAAU9z+wJqnyraP6W3J1Ew2VajY0V+6oFvqk0OSoyZTapqyIg1hbn
        aKbjERLc5HRo6AdeAz8wHjjq6Q==
X-Google-Smtp-Source: APXvYqyE/p1E5rqkJ3Qo//zO3mprA4vSLEm28eFWRAlcQ4YO/OyFULU2uC5f2NETfOPnaJlOuINMUg==
X-Received: by 2002:a17:90a:b90b:: with SMTP id p11mr17926418pjr.73.1573255928035;
        Fri, 08 Nov 2019 15:32:08 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j12sm7243486pfe.32.2019.11.08.15.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 15:32:07 -0800 (PST)
Date:   Fri, 8 Nov 2019 15:31:59 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] man: remove ppp from list of devices not
 allowed to change netns
Message-ID: <20191108153159.25e09c8a@hermes.lan>
In-Reply-To: <beefb89b340483d75c39c46a9ec69384e839f663.1573248448.git.gnault@redhat.com>
References: <beefb89b340483d75c39c46a9ec69384e839f663.1573248448.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 22:28:04 +0100
Guillaume Nault <gnault@redhat.com> wrote:

> PPP devices can be moved to different network namespaces. The feature
> was added by commit 79c441ae505c ("ppp: implement x-netns support")
> in Linux 4.3.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  man/man8/ip-link.8.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index 9629a649..939e2ad4 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -1921,7 +1921,7 @@ move the device to the network namespace associated with name
>  .RI process " PID".
>  
>  Some devices are not allowed to change network namespace: loopback, bridge,
> -ppp, wireless. These are network namespace local devices. In such case
> +wireless. These are network namespace local devices. In such case
>  .B ip
>  tool will return "Invalid argument" error. It is possible to find out
>  if device is local to a single network namespace by checking

This doesn't have to wait for net-next
