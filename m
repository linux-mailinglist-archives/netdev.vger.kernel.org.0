Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC02125406
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 22:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfLRVAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 16:00:41 -0500
Received: from mail-ua1-f50.google.com ([209.85.222.50]:43684 "EHLO
        mail-ua1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfLRVAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 16:00:40 -0500
Received: by mail-ua1-f50.google.com with SMTP id o42so1162515uad.10
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 13:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SfLOPDRTBdF/lcpFJdFkw/ySmkMTjkmNjlIgvA/uTXs=;
        b=cLET42C8Hv5e/U2Eyd/ivw5Hz0nB/+M7FuDgCzuTbOhU57punGNKVOwd4wMzjHu6Rk
         cQ4mtimuJeXg1cnCTveWZuvpv6x7xKMYiANmZvNUQMCj3CgC6LJTbwCxsk9phN0MyEMC
         Tmz4F1ScLac5zEUWeTDinVF2lzqoP5PUQSeJoxSXEydqqGQ8aqq4FJf5uHkGqsC4t3Ka
         GJ8d62sF2iVgjpcpDJMv+ZWp1ySsouDw0yXUqt+mCEDEVC6GmZ/Wkhfo3+x3YqxWwCJG
         mAwn+KtwwrKYrNrCixkqTUyje5ri88IfjXVUOkuQ3TwE79WmqbA8lCbXVgcJhRTyiugB
         avEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SfLOPDRTBdF/lcpFJdFkw/ySmkMTjkmNjlIgvA/uTXs=;
        b=BUDNf+DxRWg1TcXidOBthcAShFLEVc3y5RpPYn+bnK7Gz99IgagDKyCggS1YZDlZUu
         fz4nUuUxano9eUkLAEzkFRR5yQbkuwZ44wXfxtlGPFbmfh8B3uKp3oa9ff+i/PEiTZzW
         WPVUp8nnk3sxSOicFpz6Xml3GVd9jXYzI39j474UJXxru9fZX0W8q4YDhQMTJ1UNOE1a
         DDSeaLLuXd/3PFRudsGOiKmmdXwbG0P6KOkOlHXhWU90o9eFRFv1CMDve6kWaQl/bOfy
         3YuO+EpYD2Mr85m9lpokqmDPg7WUVaYr9iZqgjHK6UwFOahmeQ/4LV7ioyrMBqPG8Gg1
         Qsvg==
X-Gm-Message-State: APjAAAVzHztHxCL9sQcM2QvuSw2bXc78YvM2Wbf+SDyhjSxLV5A8/zCz
        LWBQEouP05tb0LP17E3rb9qAD4yt+h/sbY4viQ==
X-Google-Smtp-Source: APXvYqznK97Kc89MLanUFKXLl3kDM1icF9z9EaNRyPemGd0o1RASqUDCkxTVgVFaxwj1SR3/vKy1trWBhPfEiUIXFNk=
X-Received: by 2002:ab0:53c9:: with SMTP id l9mr3058312uaa.27.1576702839764;
 Wed, 18 Dec 2019 13:00:39 -0800 (PST)
MIME-Version: 1.0
References: <CACwWb3CYP9MENZJAzBt5buMNxkck7+Qig9yYG8nTYrdBw1fk5A@mail.gmail.com>
In-Reply-To: <CACwWb3CYP9MENZJAzBt5buMNxkck7+Qig9yYG8nTYrdBw1fk5A@mail.gmail.com>
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
Date:   Wed, 18 Dec 2019 16:00:28 -0500
Message-ID: <CAHapkUgCWS4DxGVL2qJsXmiAEq4rGY+sPTROx4iftO6mD_261g@mail.gmail.com>
Subject: Re: IPv6 test fail
To:     Levente <leventelist@gmail.com>,
        Captain Wiggum <captwiggum@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am curious: what kernel version are you testing?
I recall that several months ago there is a thread on TAHI IPv6.
Including the person who started the thread.

Stephen.

On Thu, Oct 24, 2019 at 7:43 AM Levente <leventelist@gmail.com> wrote:
>
> Dear list,
>
>
> We are testing IPv6 again against the test specification of ipv6forum.
>
> https://www.ipv6ready.org/?page=documents&tag=ipv6-core-protocols
>
> The test house state that some certain packages doesn't arrive to the
> device under test. We fail test cases
>
> V6LC.1.2.2: No Next Header After Extension Header
> V6LC.1.2.3: Unreacognized Next Header in Extension Header - End Node
> V6LC.1.2.4: Extension Header Processing Order
> V6LC.1.2.5: Option Processing Order
> V6LC.1.2.8: Option Processing Destination Options Header
>
> The question is that is it possible that the this is the intended way
> of operation? I.e. the kernel swallows those malformed packages? We
> use tcpdump to log the traffic.
>
>
> Thank you for your help.
>
> Levente
