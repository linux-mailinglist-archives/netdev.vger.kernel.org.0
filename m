Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01FF2491BA
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgHSARs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgHSARp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 20:17:45 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E4EC061389;
        Tue, 18 Aug 2020 17:17:45 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id o13so10533343pgf.0;
        Tue, 18 Aug 2020 17:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cwJJvwl+wwGOOqkLkrNY75DCUDoJdmUKN4BfYZbZXCo=;
        b=l9ubu3/lNk58Z2y8lE/Gy6GFsPgFIHSX5PVQN8JC90P/iRG4IwP2ubtrIHujRK1O7p
         0LOxqNttzpTyo9A2/FVWUcFJtjENGhi6HUDlOudqbK8jydFulPKcJmndY7bkD4+W8TJC
         DPdoBHmu19ao4TTEKl4g8aqCImqVxdVk0X2KfKqc2AGQQcODce6kSstrTbtR//CD8qnc
         VqKKTXyrCL3cMrk0I6zfq0fl+ftFQkO/s89wG4huMX2x6mte0qUOT6ZNkFogAKlEdgoS
         uL4XFptWHWEjs4TFFFPbWVvAghOps45JbOWshZYAP18d3ZigXxdRIszJZOfqD+SZaJ6a
         a6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cwJJvwl+wwGOOqkLkrNY75DCUDoJdmUKN4BfYZbZXCo=;
        b=fdAfAiNmqBvrwzq8C/tPeuvqLvSNiKxehDJMuEPOABE8cqHXqp1Fb60gk9Iu3pLA0U
         ArPiGWVIB7pGfdkQuw2Jy41BP33GfQoo7dBWKBOeEq+yCjal//vfPhw+9sQKT/209GiZ
         LPhYNE2jZ6dfc6NRGWz6srH+ql5CIOuiKW1LVISOfg3du2w3TW+geGcQkWZjUsTgqEY7
         n5gEfRl2ZApPGm42/EFbI9XOiNUqQwWAAQRagAVSxmY3zef/aph3UiWQ26Yv37aUI0+r
         ciSZ8BSU+wifR1cp6XxUxiRRfYt9kVRSYbI9p7LLQvd+XpXyVdQqo77Nf7d8MTzBnGfo
         Z0Pg==
X-Gm-Message-State: AOAM533mxiJBKNbahyOkdeMVXDcpcKoaFQLJtpnaEgFQOclna7GW7BiW
        UpeBgjQZyJz4an0XKDz9cAgaQHVNtjXBIWe4iQcwp/GigBI=
X-Google-Smtp-Source: ABdhPJw4c5c9o8vudPFNqVuHBWnNVhHvFJ/Mvj1mlcL7PYjVCceZ7nMnZiLwBmIyyqmoJjiV49lYd0rKTWL3sIi+grk=
X-Received: by 2002:a62:8303:: with SMTP id h3mr17248642pfe.169.1597796263812;
 Tue, 18 Aug 2020 17:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200808175251.582781-1-xie.he.0141@gmail.com>
In-Reply-To: <20200808175251.582781-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 18 Aug 2020 17:17:32 -0700
Message-ID: <CAJht_EN9eVKXJWL4JVCFt1nJeU3V-PnmRdqKwKA5oSkMyiHmdg@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/lapbether: Added needed_tailroom
To:     gnault@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guillaume Nault,

I'm currently trying to fix a driver's "needed_tailroom" setting. This
driver is a virtual driver stacked on top of Ethernet devices (similar
to pppoe). I believe its needed_tailroom setting should take into
account the underlying Ethernet device's needed_tailroom. So I
submitted this patch. I see you previously also did a change related
to needed_tailroom to pppoe. Can you help review this patch? Thank you
so much!

The patch is at:
http://patchwork.ozlabs.org/project/netdev/patch/20200808175251.582781-1-xie.he.0141@gmail.com/

Thanks!
Xie He
