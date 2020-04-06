Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7294C19F513
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgDFLrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:47:53 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43563 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgDFLrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 07:47:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id w15so10810534wrv.10;
        Mon, 06 Apr 2020 04:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dJij1m4N6mxqkseV1MSa9W/wHgiUr5ZF09GnOkMojW4=;
        b=eNU/0aylCxcjMTT34VU2egNOVyd5w0Al0DWGQVS/gKUumVvmC8yxh3Ca9K5kLK8DyS
         WG7iRe8ghVfYboCuvWIR5rQvZENJOBYYeEhymlJEixO/zwKrnDEfFcRb6Tubv/iUMZyB
         A0w0MCiSSQ68QSDozhSbbxUTUkQCQrlr40N9W3P7LhmjS7fKjzbqroh30qrhygCdrzje
         Qi0uTiotmnvpRvVWZrakknZzvAXsoa3mwMSZJ7s+BV6lfOPZUl4D5DLKCCxf1pGvQb2U
         AZFUmhiJfUinZY2hepF2TSnHhLIUZaJ5BNk5SgTdPoYAX9w4j87gSWtUUWILAagCDeLo
         797g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dJij1m4N6mxqkseV1MSa9W/wHgiUr5ZF09GnOkMojW4=;
        b=s+VAwF1LETmlgRoxPcyGv5d89HaBy4x8rIF2l/CL4a/gzBG/7tTKlku9SPXDBZLYnf
         79adIkB006muFygj0HngLxp9ca8brCFuYMHtRlERPR9y76V1/nnpK9Q3xyprFV8QBryD
         1UYffbpNwEszKLk2+cOHSflnuHtAke/PXVG3H+q2QfnEM2Uq0NBO9hP7sis4fC/u3+tF
         I65EwmW2XSItqtAeIOiJ7xQYUeNj1xBMXVmL7nTKZ7LaW0EZPR3jgSGs0AtmqOzEG/NC
         +F869/KJFSaEKTXTSsgGvqbdtgjNu/1GDs/3F/w2+UERa8l0JH9KBgOXOrS93lAkW2jo
         dnjQ==
X-Gm-Message-State: AGi0Pua86BcCBzUbNCJvwjc1O3OIZ1eTFmgQlxaTYhDwAUgVh/OSw7yr
        Q1CVijNeQpM+qcaTZC2vFQc=
X-Google-Smtp-Source: APiQypLE3reBpDcE5Ibab6hsLGUq+vrw0eul7laAeFithMseufHRAGpU7SkfEpDVxv9AYShoUmcxyA==
X-Received: by 2002:a05:6000:370:: with SMTP id f16mr24648490wrf.9.1586173670108;
        Mon, 06 Apr 2020 04:47:50 -0700 (PDT)
Received: from ?IPv6:2001:a61:2482:101:3351:6160:8173:cc31? ([2001:a61:2482:101:3351:6160:8173:cc31])
        by smtp.gmail.com with ESMTPSA id a15sm24426918wme.17.2020.04.06.04.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 04:47:49 -0700 (PDT)
Cc:     mtk.manpages@gmail.com
Subject: Re: connect() man page
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>, linux-man@vger.kernel.org
References: <f8517600-620b-1604-5f30-0f0698f5e33c@gmail.com>
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <f215d6b5-0aed-a3d1-39d3-f3bf12fdfc78@gmail.com>
Date:   Mon, 6 Apr 2020 13:47:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <f8517600-620b-1604-5f30-0f0698f5e33c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

My apologies for the delayed reply.

On 2/12/20 6:50 PM, Eric Dumazet wrote:
> Hi Michael
> 
> connect() man page seems obsolete or confusing :
> 
>    Generally,  connection-based  protocol  sockets may successfully
>    connect() only once; connectionless protocol  sockets  may  use
>    connect()  multiple times  to  change  their association.
>    Connectionless sockets may dissolve the association by connecting to
>    an address with the sa_family  member  of sockaddr set to AF_UNSPEC
>    (supported on Linux since kernel 2.2).
> 
> 
> 1) At least TCP has supported AF_UNSPEC thing forever.

Thanks for the heads-up,

> 2) By definition connectionless sockets do not have an association,
>    why would they call connect(AF_UNSPEC) to remove a connection 
>    which does not exist ...

Calling connect() on a connectionless socket serves two purposes:
a) Assigns a default outgoing address for datagrams (sent using write(2)).
b) Causes datagrams sent from sources other than the peer address to be 
   discarded.

Both of these things are true in AF_UNIX and the Internet domains.
Using connect(AF_UNSPEC) allows the local datagram socket to clear 
this association (without having to connect() to a *different* peer),
so that now it can send datagrams to any peer and receive
datagrams for any peer, (I've just retested all of this.)

> 
> Maybe we should rewrite this paragraph to match reality, since 
> this causes confusion.
> 
> 
>    Some protocol sockets may successfully connect() only once.
>    Some protocol sockets may use connect() multiple times  to  change
>    their association.
>    Some protocol sockets may dissolve the association by connecting to
>    an address with the sa_family member of sockaddr set to AF_UNSPEC
>    (supported on Linux since kernel 2.2).

When I first saw your note, I was afraid that I had written
the offending text. But, I see it has been there since the 
manual page was first added in 1992 (other than the piece 
"(supported since on Linux since kernel 2.2)", which I added in
2007). Perhaps it was true in 1992.

Anyway, I confirm your statement about TCP sockets. The 
connect(AF_UNSPEC) thing works; thereafter, the socket may be
connected to another socket.

Interestingly, connect(AF_UNSPEC) does not seem to work for
UNIX domain stream sockets. (My light testing gives an EINVAL
error on connect(AF_UNSPEC) of an already connected UNIX stream
socket. I could not easily spot where this error was being
generated in the kernel though.)

I like your proposed text, but would like to include more
information. How about this:

       Some protocol sockets (e.g., UNIX domain stream sockets) may  suc‐
       cessfully connect() only once.

       Some  protocol  sockets  (e.g.,  datagram  sockets in the UNIX and
       Internet domains) may use connect() multiple times to change their
       association.

       Some protocol sockets (e.g., TCP sockets as well as datagram sock‐
       ets in the UNIX and Internet domains) may dissolve the association
       by  connecting to an address with the sa_family member of sockaddr
       set to AF_UNSPEC; thereafter,  the  socket  can  be  connected  to
       another  address.   (AF_UNSPEC  is supported on Linux since kernel
       2.2.)

?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
