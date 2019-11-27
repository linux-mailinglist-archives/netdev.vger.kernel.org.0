Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67DC810B431
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 18:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfK0ROU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 12:14:20 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39972 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbfK0ROT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 12:14:19 -0500
Received: by mail-yb1-f196.google.com with SMTP id n3so5586889ybm.7
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 09:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P6dt6mnwS/nhjUXREL+T0RU3KJ2Ao/MiaFqpAlOXqGQ=;
        b=Lo9lDiBIAxeGepstMjP+H7Xwfg0m8VQZve6xwcJFKTE4eotwL5AkyGqZU4xuMT8vcD
         eno7BAQk8zxteZEEu92lRAgJ4gcg4Os+M3uVFqatDzqY90Wh3nkyigM24yFUfBGQsWMA
         qI0ADf8FpJyUgXEfAw4aHY5p5XuBYihfYK5zMf4WqfzDYDi6MJLCtPObKzCmkSAUM/97
         HSgj4X4O4JI0bdIRSeqdlevePhRxxKtwKOpg6PwPViCbPa8p2+hXQyKFCi0Rcir0KJVF
         g3y48BTWHpF3uirW9WplO1PQfwMBIo65R9+broDhrDng4XjokvJplJ9WoKOJr0I/Ock0
         +EQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P6dt6mnwS/nhjUXREL+T0RU3KJ2Ao/MiaFqpAlOXqGQ=;
        b=aLP4+wACRw2mNXSLwvRSbn/GYAKb4wbKzmGf7RT114lZtREel4LjHzx2SIos3TXIEb
         HZ+R/BaxuwyGtqQil307oCfxG5YOC2mNdNiFGx9qoPHzfGe/AFf0S9ab/+Yex51Gzsfl
         hMjjfoMI+PvIIOfxgEsP/necF5JeFfOGi02WTjDOk0mG8CnIrSFGmBJTjkpBEdSgAPXH
         IGuAYPXfQbdDhrh8bLuU3RdY2pfqhkw1qL1V1LGNQqZweYGZtF+igxsnz2XFlbwDOGeB
         RzKewgvG6U+mQ+IPcszBIQxlX+hqdV5H6omixVAHZ/kHxDVQVb72akzwOVTuoixhf5z9
         lPog==
X-Gm-Message-State: APjAAAUWUCk0K288IPXE9HV64rXY1tiBEByIlkZR6YI9LU4YTgQP7sjP
        fs53+ueFOrMz6dVd5KrrQjWZjesK
X-Google-Smtp-Source: APXvYqwqJLiwqUQcvN+gIZEX/DigWryIS+T5PVLF6VdhhPivBXMHc6XEtffebOMs1gOT/w64owX2XQ==
X-Received: by 2002:a25:ce0f:: with SMTP id x15mr32566248ybe.420.1574874858553;
        Wed, 27 Nov 2019 09:14:18 -0800 (PST)
Received: from mail-yw1-f44.google.com (mail-yw1-f44.google.com. [209.85.161.44])
        by smtp.gmail.com with ESMTPSA id n128sm7119881ywc.99.2019.11.27.09.14.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 09:14:17 -0800 (PST)
Received: by mail-yw1-f44.google.com with SMTP id d80so8632538ywa.6
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 09:14:17 -0800 (PST)
X-Received: by 2002:a0d:cc90:: with SMTP id o138mr3958458ywd.193.1574874857025;
 Wed, 27 Nov 2019 09:14:17 -0800 (PST)
MIME-Version: 1.0
References: <20191127080850.2707eef0@hermes.lan>
In-Reply-To: <20191127080850.2707eef0@hermes.lan>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Nov 2019 12:13:40 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeBmuk0OOG_Psmj-WGz6njWDEpFLnwsUHUAMHjuc3a-rg@mail.gmail.com>
Message-ID: <CA+FuTSeBmuk0OOG_Psmj-WGz6njWDEpFLnwsUHUAMHjuc3a-rg@mail.gmail.com>
Subject: Re: Fw: [Bug 205681] New: recvmg is overwriting the buffer passed in
 msg_name by exceeding msg_namelen
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 11:09 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
>
>
> Begin forwarded message:
>
> Date: Wed, 27 Nov 2019 06:36:50 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 205681] New: recvmg is overwriting the buffer passed in msg_name by exceeding msg_namelen
>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=205681
>
>             Bug ID: 205681
>            Summary: recvmg is overwriting the buffer passed in msg_name by
>                     exceeding msg_namelen
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.4,4.0,3.0,2.6
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: sudheendrasp@gmail.com
>         Regression: No
>
> if (msg->msg_name) {
>         struct sockaddr_rxrpc *srx = msg->msg_name;
>         size_t len = sizeof(call->peer->srx);
>
>         memcpy(msg->msg_name, &call->peer->srx, len);
>         srx->srx_service = call->service_id;
>         msg->msg_namelen = len;
>     }
>
>
> As seen, recvmsg is doing memcpy of len which can be greater than msg_namelen
> passed.

__sys_recvfrom in net/socket.c always passes a struct of size
sockaddr_storage to the protocol handler. On return from the protocol
handler it calls move_addr_to_user to safely copy up to msg_namelen
only.
