Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6861096EE
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfKYXc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:32:58 -0500
Received: from mail-lf1-f46.google.com ([209.85.167.46]:44802 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYXc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:32:57 -0500
Received: by mail-lf1-f46.google.com with SMTP id v201so11402570lfa.11
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 15:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N7Q0GDNRCS0iTo0y5hEV48liHWR9IhwaupxCsjYsEF4=;
        b=tWGfXKj0RKzn3BUtEHj6D1PI3+v/sPUF0CYvS0L1xKde7rHJJAOqHxM4+AxMtXuBLH
         S2MeXlJqccyKxBNmnXiGDQ9EIAobPZ1e3Cilxy1qQeyxkNVMC0F95UeXWe6458y7pn4c
         x0nmZ4m4agjmFY7u1vn96fjaep850RDeiiwvrnRnjUQqjGEmW8wIJSkhHiAtpQjlSrDd
         DLzDI7e2YlDvTWAvj1isNzeb39d7jI8g8ZDxtD4NpH+rZ48v0JLGY8hmVNX9bB5+sW4x
         gUvFDsgcWtZz3CVmFI0BXcOrMJUpJWYjiQbGs1ev4wbDMHYACOw4d2Q78j0mmJfvWsS7
         n4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N7Q0GDNRCS0iTo0y5hEV48liHWR9IhwaupxCsjYsEF4=;
        b=JJBklV+tUHfv/xizrJ3FVNW57YKzmjZY/0yXG3Rsnb6bla4668z061KtK61mz09sUG
         CYAvjemj6PUAYaxHUJvLB7rF7SeRDFxoMOsXPff7x4nPWJcXXinrTVivkLxR/26g1wvy
         BqVLRuZzRi85b7eEDYti2tSt5UqQObmrKQgsLkntRmhOc1rp5QqUv/pDoauWokkkLsOV
         9Dev8e7vZnxr9A2eWBUxqmD/OxBr1iK52qN5IT2JhK0MJf0wCwwZPLKSNl+JAmp9NCTX
         XzmvUieA0zvH+rDwsai1Z3OY72nkqn1cDFHZFZDTtgyJkY0Lcdv3xvs0QXnRKUR/HNX+
         5spw==
X-Gm-Message-State: APjAAAVKNEW1di/kZyVQnsDIj1akTPrLUUKM911Vvln0e100l28sb8SH
        Cm4wJ/dsTapXKsegFIw7wXjJC97X/zcqZXSXJWA=
X-Google-Smtp-Source: APXvYqw4hotGRIRW8fOQfmM8C/ukHJ27FMbCZMuXT9674R34oxaoP+HHC9daN/eX1baGCvDt1T5vdXdVuvVyhFlbGVA=
X-Received: by 2002:ac2:430d:: with SMTP id l13mr23006640lfh.114.1574724774163;
 Mon, 25 Nov 2019 15:32:54 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGfi3vwAjYu45xRG7HqMw-CGEr4uxES8Cd7vHs+q4W4wLQ@mail.gmail.com>
 <20191124092715.252532-1-zenczykowski@gmail.com> <20191125.144522.2288594830565793222.davem@davemloft.net>
In-Reply-To: <20191125.144522.2288594830565793222.davem@davemloft.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 25 Nov 2019 15:32:44 -0800
Message-ID: <CAHo-OoxYDpcpT+nZgYw7hkUY2wi+iRdtqR97xL_ALeC6h+aiKQ@mail.gmail.com>
Subject: Re: [PATCH] net: port < inet_prot_sock(net) --> inet_port_requires_bind_service(net,
 port)
To:     David Miller <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I see ample assignments of htons() which is __u16 to unsigned short snum,
so I think the right answer is just to use unsigned short for the port
parameter.
