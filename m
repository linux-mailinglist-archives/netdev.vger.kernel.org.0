Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF2C10155C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 06:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbfKSFnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 00:43:20 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:34803 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730713AbfKSFnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 00:43:19 -0500
Received: by mail-pl1-f176.google.com with SMTP id h13so11154480plr.1
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 21:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vX0pgWD4eJP8efW+dsX/jJhxVK3905FH6ltuzbxOcIs=;
        b=eNxBmWT5NXegDVinesTaJ0J5Y1gYqJAZ4bSneQhass+Lx60B2+nUhLYCYgUWQEG0Rv
         csUwQ5smgX7rUElGQLqyr0dQjB3KeWSo9OCnJjgwXFrFUo15/LnYv+h/qE/pGpFZVPfS
         pf5/zVvJWr6UXZLbootm7WPXuhkAW3dKeupbFnJCXzpIuSvOaJiY7w17+aqASx3+VAJy
         jkghH0nhMk62iVvZAfjFfT5mPMJ7o8Gqnl4LZTO8hiYBzOneg1HMoxJL2wpa6D/AYxB0
         XQxvWwC6ked92deBRV5YB7ltu46SQEYyFG5rDAiQA6Kqlj65WoZg6sGmBbyICt3f+dtF
         rxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vX0pgWD4eJP8efW+dsX/jJhxVK3905FH6ltuzbxOcIs=;
        b=n5QqdHYSmiYbpoTgMGZNWRcNjH709VNPN4888Kvse+2SYn5ZMLdHvlTw8rcdT8u8Dk
         FwC85WorbM9j/CpgeuxIh7CuUWsfDBGnrU18phbMNov3FWTmVqe7MohLfGbvicKML8GG
         uFF98w0/i1SQGYdQSlEnMEIYBIU6ee59K1z+8fQ+XLOQw+kX8F6RKrT49dMzhGeVrTE1
         gT3xZ/VkJcckrg4SlF6hTn8PftY2nkr0Lh6MidG8xM0CvsEB+pJ2tJrIt86OZzpUBnYc
         v/4ARmJRb1oVTZAoOxbFwumE87ZS5GukvwDvlLmPb6XVVbYtQh30gVc+lfjLSOLoQuY1
         blnQ==
X-Gm-Message-State: APjAAAVHS9u+6H/keeVRod42zIByDwt2ofN5gvtxGakhyluetAAB2+5o
        Jjlyrqzqh9L8XIJQ1S7KoeTHhjXu7lGdgEa4zjk=
X-Google-Smtp-Source: APXvYqwkldp4iZ3MCvudWld91Zr42rdLPZzSvhb6X88LXXLuSuQZTeXVzkQLa7fJBOrUOnX8r3dzIBcSRPpg/BXlGis=
X-Received: by 2002:a17:902:9a03:: with SMTP id v3mr33056731plp.61.1574142198363;
 Mon, 18 Nov 2019 21:43:18 -0800 (PST)
MIME-Version: 1.0
References: <CABT=TjGqD3wRBBJycSdWubYROtHRPCBNq1zCdOHNFcxPzLRyWw@mail.gmail.com>
 <CAM_iQpUpof_ix=HJyxgjS4G9Mv5Zmno05bq0cmSVVN9E_Mzasg@mail.gmail.com> <CABT=TjGn8S3jy4bw6ShRpYJdcE3-H4fNaxEPGfNaxiEcxBtPrA@mail.gmail.com>
In-Reply-To: <CABT=TjGn8S3jy4bw6ShRpYJdcE3-H4fNaxEPGfNaxiEcxBtPrA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 18 Nov 2019 21:43:07 -0800
Message-ID: <CAM_iQpUF5rAXy7M5S=4tYtNKAnrmTHk+=1M9CR8xqj9VgSYqDg@mail.gmail.com>
Subject: Re: Unix domain socket missing error code
To:     Adeel Sharif <madeel.sharif@googlemail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 12:56 AM Adeel Sharif
<madeel.sharif@googlemail.com> wrote:
>
> It should but it is not used when two different sockets are communicating.
> This is the third check in the if statement and it is never called
> because the first unlikely check was false:
>
> if (other != sk &&
>         unlikely(unix_peer(other) != sk && unix_recvq_full(other))) {
>

Good catch!

It seems you already have a reproducer to trigger this OOM? If so
please share. And let me see if and how I can fix it.

Thanks.
