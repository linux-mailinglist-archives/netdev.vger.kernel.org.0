Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F5BEE1F0
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 15:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfKDOOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 09:14:02 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35284 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbfKDOOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 09:14:02 -0500
Received: by mail-qk1-f196.google.com with SMTP id i19so8589074qki.2;
        Mon, 04 Nov 2019 06:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2MwvcJ5K000qPvOxUI6F4rY+oHfSb/j9RCrs2a/aoEc=;
        b=JKbtk3On316fhVk3EO/By03AL5Lb/tbyMeNbuKix2nc8WDTh0Hv77IEaL+QyuMLDNg
         mHzmDwPWpuag4cnuYHktiL1EWs0NiWo9Eaonot/GhaYr54BWoR0o69kUsMeX4VkEjC8I
         itqDk29w6YiLIsd8wKaiv009FrcNDQqmCQOH2mHdqaRjUHV27MGZJ4cjSxA/0WC95QhX
         CcGGKP3z/I1wcVG+9VaQotfdVR0RWS7D3ugP7IYxRzGyNnfTBgpVtJ2BxfK00LuwDeFT
         a7ggU32FJ+Ddd/7dFS46f1hYvDe0pbkh4nBp3UNvFcHhRsXdpNTwSoDbYfJ1VvJj9y7s
         9Auw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=2MwvcJ5K000qPvOxUI6F4rY+oHfSb/j9RCrs2a/aoEc=;
        b=SMhhWELO9o0X+wCHpf0LquSkkvYSaJ/9Epmk0jsSij/iY7vS/6PHSOCNXg4xfsCL4p
         XVxCZA0oIQ25QWkggU5KvoVU7cxRst8VTjYzlPoSDonK5gZUaem8b/W2kw0gz5/yk9sw
         G31BQgDAToOL4qrLH1CBdFukphSsPqv41zrIxlxqJs8XY6FVESCNqRPAytgv6EXHRHKY
         hA8vKjAl69t0gWJ8jeJSsVn9u/XDUnVZuiBjyAwza9c6HBS1kRYl4Pq3hDBAjl3MWUda
         eJsd6pJl2DiQTnsX6hZ3xZQhcZqddN04CAk7+CKM1FPGuKt9OdZCpHyJ1XkKIq0VDNBd
         GJNA==
X-Gm-Message-State: APjAAAU3MedIxWGYM2fwv/DS0DEF49funql51REbSGTHk8p9yXWGN8DG
        xU2rTImgFmOSQkFPgkwMQQ0TZOKG9cM3ZmqG5rY=
X-Google-Smtp-Source: APXvYqyTkyVDI6shpM35BlKsNyWc4Zwh6+fM+wEX2WfNRiBubJwKDDEEPNhB3tDkmA2dQv+8/nGS1MEF3I8/aCf4mJw=
X-Received: by 2002:ae9:e708:: with SMTP id m8mr1789934qka.428.1572876841206;
 Mon, 04 Nov 2019 06:14:01 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ad4:54a5:0:0:0:0:0 with HTTP; Mon, 4 Nov 2019 06:14:00 -0800 (PST)
In-Reply-To: <20191104132508.GA53856@localhost.localdomain>
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com>
 <20191104084635.GM29418@shao2-debian> <20191104132508.GA53856@localhost.localdomain>
From:   Wei Zhao <wallyzhao@gmail.com>
Date:   Mon, 4 Nov 2019 22:14:00 +0800
Message-ID: <CAFRmqq6vNg5sBYp7voT4SoVR+i+L8fDqUUZOF68cRdcKkQcZmw@mail.gmail.com>
Subject: Re: [sctp] 327fecdaf3: BUG:kernel_NULL_pointer_dereference,address
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     kernel test robot <rong.a.chen@intel.com>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wally.zhao@nokia-sbell.com,
        lkp@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/19, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Mon, Nov 04, 2019 at 04:46:35PM +0800, kernel test robot wrote:
>> [   35.312661] BUG: kernel NULL pointer dereference, address:
>> 00000000000005d8
>> [   35.316225] #PF: supervisor read access in kernel mode
>> [   35.319178] #PF: error_code(0x0000) - not-present page
>> [   35.322078] PGD 800000021b569067 P4D 800000021b569067 PUD 21b688067 PMD
>> 0
>> [   35.325629] Oops: 0000 [#1] SMP PTI
>> [   35.327965] CPU: 0 PID: 3148 Comm: trinity-c5 Not tainted
>> 5.4.0-rc3-01107-g327fecdaf39ab #12
>> [   35.332863] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>> 1.10.2-1 04/01/2014
>> [   35.337932] RIP: 0010:sctp_packet_transmit+0x767/0x822
>
> Right, as asoc can be NULL by then. (per the check on it a few lines
> before the change here).

Yes, apologize for missing the NULL check (Actually I realized some
further check is need to correctly identify the first in flight
packet, as outstanding_bytes has already been increased by this first
in flight packet itself before getting into sctp_packet_transmit).

Anyway, I think I do not need further action, as the patch is anyway
not going to be merged, the 0day robot picks up the patch from the
mail list directly instead of git repo, right?

Thanks a lot,
Wally

>
>   Marcelo
>
