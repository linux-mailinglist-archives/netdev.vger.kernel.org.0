Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 954079273B
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfHSOnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:43:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43325 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfHSOnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:43:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id y8so8987804wrn.10;
        Mon, 19 Aug 2019 07:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jKjI6ZndqmMBsOtkkjCYvrMvrRJBMoNCPOLNG/SK2nY=;
        b=LzH2Ofa8/UVZVx15f5N7dL61l7W1f/ftuHWPZu99y206sZFFR0bgJvRTb8TNVKo66r
         +kNzaydBXpIy3QPJ740l7G7Lfrf9sikvl9wl2cFHs9jHGyy+4HvbsPKftpT8VKqcNT6S
         tdUwhmgOUexJQybQgUIRfFdA+cRxU9EnGXlKI7OI5XJhTo5XSoWlTBzQo5SEiH17GMXL
         BY/Qq64klJCYIHLde02gMkPH7hWz9dCYoA9c75gYnEfi9nG92Uvv8IhkJU+J9Axubblj
         jBde3Db7V3Lo78bEfmUCEhI1EqgHTRhl+1neJgzygDUWj0MmBxdurSdmVubxbPLD5v5c
         3SKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jKjI6ZndqmMBsOtkkjCYvrMvrRJBMoNCPOLNG/SK2nY=;
        b=VXeJbwxjKydeL4m5Mre9wHaROkITr64iB3Bv86lLYt9Lm/UTuOZ5XljgCGGlxD570Q
         Qi1ZfxPuKxxV8tqtPXAKmkpEO4pyBQ0rAvlvq8DFFAtWBhkm/vfG3Ng1Jw4eeTlQ5nre
         YgnhYvnc58g1zNhnxDS3EDqPv8KKKVI2i6B/ZDr5xY2fDKJlawNVx+UsUxPS1vySQiwj
         PdVuFNRr8m1YQkGKgjnSBzkIq3jY1kcHzNMTe2So7mkbdqb+GvdfwTyKYEWbMkvhknP/
         2a6Cq5II79+wVDXcTMa6FE/ZHr5DnKjhuMAqgo07J25SCQkt4pmk4LI9QykW2JYTXLJF
         Hwxw==
X-Gm-Message-State: APjAAAViF9ZA+jcVuiw2XYqO1rjj4iWxn0EUQLXYqWQzb4RwuAdMPtG5
        gFnVkAJa67eFrcfjmysVCSrNd3NzVYHhdsEulnLA3vkv
X-Google-Smtp-Source: APXvYqzBK0PfIcBTtukPi/LWTeqPxQo7O3eXvNRE7ESdrjO0i7sCB4+dNNSLevYRhclp7rphPaO5UNcmIv+VWSe7LJE=
X-Received: by 2002:adf:f90e:: with SMTP id b14mr26409029wrr.124.1566225794738;
 Mon, 19 Aug 2019 07:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1566223325.git.lucien.xin@gmail.com> <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
 <20190819143052.GC2870@localhost.localdomain>
In-Reply-To: <20190819143052.GC2870@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 19 Aug 2019 22:43:03 +0800
Message-ID: <CADvbK_dT6p7z0YUcEKakGr-+x+a7je_jNnGHOAnVs5mxtrSN1g@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] sctp: add SCTP_ASCONF_SUPPORTED sockopt
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 10:30 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Aug 19, 2019 at 10:02:46PM +0800, Xin Long wrote:
> > SCTP_ASCONF_SUPPORTED sockopt is used to set enpoint's asconf
> > flag. With this feature, each endpoint will have its own flag
> > for its future asoc's asconf_capable, instead of netns asconf
> > flag.
>
> Is this backed by a RFC? If yes, it should be noted in the patch
> description.
> Quickly searching, I found only FreeBSD references.
RFC doesn't define this sockopt clearly, unlike prsctp and reconfig,
not sure why.
but BSD supports it, so does some userland SCTP.
